module Show

  private
  def show_header(feature)
    menu_width = 80
    marker = '*'

    show_horizontal_rule(menu_width, marker)
    print elaborate_feature(feature).center(menu_width)
    show_horizontal_rule(menu_width, marker)
  end

  def elaborate_feature(feature)
    case feature
    when :help
      return "HELP MENU"
    when :save
      return "SAVE A GAME"
    when :load
      return "LOAD A GAME"
    when :list_saves
      return "LIST OF SAVED GAMES"
    else
      return ""
    end
  end

  def show_horizontal_rule(width, marker)
    width_minus_1 = width - 1

    puts
    (width_minus_1).times { print marker }
    puts
  end

  def show_all_saves(file)
    show_header(:list_saves)
    keys = file.keys
    date_reg = /(\d){4}-(\d){2}-(\d){2}/

    puts "\t#{'USERNAME'.ljust(20)} | #{'TIMESTAMP'.ljust(20)}"
    puts

    keys.each do |key|
      ind = key.index(date_reg) || key.length
      name = key[0...ind]
      timestamp = key[ind...key.length]
      puts "\t#{name.ljust(20)} | #{timestamp.ljust(20)}"
    end
  end

  def show_help()
    show_header(:help)
    puts "\t* 'help' to show the help menu"
    puts "\t* 'save' to save your progress"
    puts "\t* 'load' to load a previous game"
    puts "\t* 'list' to get a list of all saved games"
    puts "\t* 'display' to display the game so far"
    puts 
    puts "\tto continue playing, just type in your next letter"
    puts
    input = gets.chomp
    handle_input(input)
  end

  def show_intro()
    puts "the secret word is #{@player_guess.length} letters long"
    player_guess()
  end

  def show_updates()
    puts
    puts '#####'
    puts
    puts 'your guess so far:'
    show_player_guess()
    puts
    puts 'list of incorrect letters:'
    show_incorrect_letters()
    puts
    show_wrong_letters_remaining()
  end

  def show_outcome()
    puts
    puts "GAME OVER"
    puts "here is the answer:"
    puts "#{@answer}"
  end

  def show_player_guess()
    @player_guess.each do |c|
      print ( c == '' ? '_ ' : c + ' ' )
    end
  end

  def show_incorrect_letters()
    @incorrect_letters.each do |c|
      print c + ' '
    end
  end

  def show_wrong_letters_remaining()
    item = (@wrong_letters_remaining > 1 ? 'letters' : 'letter')
    puts "you have #{@wrong_letters_remaining} wrong #{item} before the game is over"
  end

end
