module Load

  def load_setup()
    show_header(:load)
    puts "\tType username of the game you want to load"
    puts "\t* type 'l' to list all saved games"
    puts "\t* type 'q' to return to your game"
    choice = gets.chomp.downcase()
    choice
  end

  # loads a serialized yaml file as returns as deserialized ruby objects
  def load_yaml(file)
    YAML::load(File.read file)
  end

  def find_matching_keys(yaml_hash)
    puts "enter name of the person whose game you want to load"
    name = gets.chomp
  
    keys = yaml_hash.keys
    date_reg = /\s(\d){4}-(\d){2}-(\d){2}/

    matches = keys.select do |key|
      ind = key.index(date_reg) || key.length
      key[0...ind] == name
    end
  
    if matches.length == 0
      puts "no matches found. would you like to search again? [y/n]"
      choice = gets.chomp[0].downcase
      case choice
      when 'y'
        find_matching_keys(yaml_hash)
      else
        return nil
      end
    else
      pick(matches)
    end
  end

  # get a list of matches & pick one
  def pick(matches)
    unless matches.length > 1
      return matches[0]
    end
    puts "Found #{matches.length} matches. Here they are:"
    puts
    matches.each_with_index { |match, ind| puts "#{ind+1}: #{match}" }
    puts
    puts "Pick one by typing in its number"

    begin
      pick = (gets.chomp.to_i) - 1
      raise StandardError unless pick >= 0 && pick < matches.length
    rescue
      puts "###############################"
      puts "#{pick} is out of range!"
      puts "select a number between 1 and #{matches.length}"
      retry
    else
      puts "you chose: #{matches[pick]}"
      matches[pick]
    end
  end

end
