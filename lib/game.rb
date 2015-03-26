class Game
  attr_reader :wrong_letters_remaining, :answer,
    :player_guess, :incorrect_letters,
    :name, :save_key, :timestamp, :saved_games_file

  def initialize(wrong_letters_remaining, answer = self.class.random_word())
    @save_key = nil
    @name = nil
    @timestamp = nil
    @wrong_letters_remaining = wrong_letters_remaining
    @answer = answer
    @player_guess = Array.new(@answer.length).map{|c| ''}
    @incorrect_letters = []
  end

  @@saved_games_file = './saves'
  include Save
  include Load
  include Show

  def self.saved_games_file; @@saved_games_file; end

  def play
    show_intro()
    while @wrong_letters_remaining > 0
      show_updates()
      puts "type in 'help' or '?' if you need help"
      input = gets.chomp.downcase
      handle_input(input)
      break if @player_guess == @answer.split('')
    end
    show_outcome()
  end

  # wrapper for Save module methods
  def save_game()
    save_setup()
    save_current_game(@@saved_games_file, self)
  end

  # wrapper for Load module methods
  def load_game()
    all_saves = load_yaml(@@saved_games_file)
    show_all_saves(all_saves)

    choice = load_setup()
    case choice
    when 'l'
      show_all_saves(all_saves)
      load_game()
    when 'q'
      return_to_game()
    else
      # enter a name & return all games with a save_key that includes name
      game_name = find_matching_keys(all_saves)
      return_to_game() if game_name.nil?
	    saved_game = YAML::load(all_saves[game_name])
      puts
      puts "loaded a game by #{saved_game.name}"
      puts "from #{saved_game.timestamp}"
      puts
	    saved_game.play()
    end
  end

  def self.random_word()
    src = './dictionary.txt'
    min_length = 5
    max_length = 12

    begin
      file = File.readlines(src)
    rescue
      puts "unable to read from the dictionary, #{src}"
      false
    else
      word = file.sample().downcase().chomp()
      return (word.length >= min_length && word.length <= max_length) ?
        word :
        self.random_word()
    end
  end

  private
  def handle_input(input)
    case input
    when 'help', '?'
      show_help()
    when 'save'
      save_game()
    when 'load'
      load_game()
    when 'restart'
      restart_game()
    when 'list'
      show_all_saves(load_yaml(@@saved_games_file))
    when 'display'
      show_updates()
      puts
      input = gets.chomp
      handle_input(input)
    else
      get_player_guess(input)
    end
  end

  def restart_game()
    puts "are you sure you want to restart your game? [y/n]"
    choice = gets.chomp[0].downcase
    case choice
    when 'y'
      #puts "OK, starting a new game."
      #puts "how many chances at wrong letters do you want?"
      #n = gets.chomp.to_i
      #self.class.new(n)
    when 'n'
      return_to_game()
    else
      puts "****************************"
      puts "I didn't get that."
      puts "Type 'y' for yes. 'n' for no"
      restart_game()
    end
  end

  def return_to_game()
    puts
    puts 'returning to game in progress'
    puts
    return
  end

  def get_player_guess(letter)
    answer = @answer.split('')
    rate_guess(letter, answer)
    update_letter_sets(letter, answer)
  end

  def rate_guess(letter, answer)
    answer.each_with_index do |c, i|
      @player_guess[i] = letter if c == letter
    end
    @wrong_letters_remaining -= 1 unless answer.member?(letter)
  end

  def update_letter_sets(letter, answer)
    unless answer.member?(letter)
      @incorrect_letters << letter
      @incorrect_letters.sort!
    end
  end

end
