require 'yaml'

class Game
  attr_accessor :player_guess
  attr_reader :wrong_letters_remaining, :incorrect_letters, :saved_games_file

  @@saved_games_file = './saves'

  def initialize(wrong_letters_remaining, answer = self.class.random_word())
    @wrong_letters_remaining = wrong_letters_remaining
    @answer = answer
    @player_guess = Array.new(@answer.length).map{|c| ''}
    @incorrect_letters = []
  end

  def play
    print_intro()
    while @wrong_letters_remaining > 0
      print_updates()
      puts "type in 'help' or '?' if you need help"
      input = gets.chomp.downcase
      handle_input(input)
      break if @player_guess == @answer
    end
    print_outcome()
  end

  def handle_input(input)
    case input
    when 'help', '?'
      help()
    when 'save'
      save_game()
    when 'load'
      load_game()
    when 'display'
      print_updates()
      handle_input(gets)
    else
      get_player_guess(input)
    end
  end

  def help()
    puts "!!!!!!!!!!!!!!!!!!!!!!"
    puts "HELP MENU"
    puts
    puts "* 'save' to save your progress"
    puts "* 'load' to load a previous game"
    puts "* 'display' to display the game so far"
    puts 
    puts "to continue playing, just type in your next letter"
    puts "!!!!!!!!!!!!!!!!!!!!!!"
    handle_input(gets)
  end

  def save_game()
    puts "want to save your game? just enter your name"
    @name = gets.chomp
    @timestamp = Time.now.strftime("%Y-%m-%d %T")
    @filename = "#{@name} #{@timestamp}"

    data = {}
    instance_variables.map do |v|
      data[v] = instance_variable_get(v)
    end
    saved_game = data.to_yaml

    self.class.save_to_disk(saved_game)
  end

  def self.save_to_disk(saved_game)
    File.open(@@saved_games_file, 'a+') do |file|
      file.write(saved_game)
    end
    puts "your game has been saved!"
  end

  def print_intro()
    puts "the secret word is #{@player_guess.length} letters long"
    print_player_guess()
  end

  def print_updates()
    puts
    puts '#####'
    puts
    puts 'your guess so far:'
    print_player_guess()
    puts
    puts 'list of incorrect letters:'
    print_incorrect_letters()
    puts
    print_wrong_letters_remaining()
  end

  def print_outcome()
    puts
    puts "GAME OVER"
    puts "here is the answer:"
    puts "#{@answer}"
  end

  def self.random_word()
    src = File.readlines('./dictionary.txt')
    min_length = 5
    max_length = 12

    word = src.sample().downcase().chomp()

    return (word.length >= min_length && word.length <= max_length) ?
      word :
      self.random_word()
  end

  private
  def print_player_guess()
    @player_guess.each do |c|
      print ( c == '' ? '_ ' : c + ' ' )
    end
  end

  def print_incorrect_letters()
    @incorrect_letters.each{|c| print c + ' ' }
  end

  def print_wrong_letters_remaining()
    item = (@wrong_letters_remaining > 1 ? 'letters' : 'letter')
    puts "you have #{@wrong_letters_remaining} #{item} left"
  end

  def get_player_guess(letter)
    rate_guess(letter)
    @wrong_letters_remaining -= 1
    update_letter_sets(letter)
  end

  def rate_guess(letter)
    answer = @answer.split('')
    answer.each_with_index do |c, i|
      @player_guess[i] = letter if c == letter
    end
  end

  def update_letter_sets(letter)
    @incorrect_letters << letter
    @incorrect_letters.sort!
  end

end
