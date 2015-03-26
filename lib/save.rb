module Save

  # add values to 3 more instance variables
  def save_setup()
    show_header(:save)
    begin
      puts "want to save your game? enter your name"
      name = gets.chomp()
      validate_name(name)
    rescue StandardError => e
      puts e.message
      retry
    end
    @name = name
    @timestamp = Time.now.strftime("%Y-%m-%d %T")
    @save_key = "#{@name} #{@timestamp}"
  end

  # converts current game to serialized yaml form
  # loads all existing saves as deserialized ruby objects
  def save_current_game(saved_games_file, current_game)
    game_yaml = YAML::dump(current_game)
    all_games = load_yaml(saved_games_file)

    key = self.save_key
    all_games[key] = game_yaml

    save_yaml(saved_games_file, all_games)
    puts "Success! Your game has been saved to #{saved_games_file}"
  end

  # open a `file` in write-only mode (writes over existing contents)
  # then writes all of `game_or_games` to `file` as a YAML string.
  # closes the file when done
  def save_yaml(file, game_or_games)
    File.open(file, 'w') do |f|
      f.write( YAML::dump(game_or_games) )
    end
  end

  def validate_name(name)
    invalid_names = ['load', 'save', 'help', 'restart', 'list', 'display']
    if invalid_names.include?(name)
      err_message = "#{name} is not a valid name. Please choose another."
      raise(NameError, err_message)
      return
    elsif name.length < 3
      err_message = "Names must be 3 or more characters. Please choose another"
      raise(NameError, err_message)
      return
    end
    name
  end
end
