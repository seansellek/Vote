class UI
  def initialize country
    @country = country
  end

  def clear
    system('clear')
  end
  def print_line symbol = "\# "
    puts symbol*65
  end
  def display state = :none
    print_header
    case state
      when :help
        print_help
      when :display_data
        if @country.states[:AL].polls.empty?
          draw_state(:populations)
        else
          draw_state(:populations, :polls)
        end
    end
    puts
  end
  def print_help
    puts
    puts "Instructions: Prepare your scenario (state populations & polls) with the commands below. then type 'run'\n".center(130)
    puts "CREATE    To manually create a state with population =>\t'FL 18900773'"
    puts "UPDATE    To update an existing state's population =>\t'FL 19800773'"
    puts "IMPORT    To load 2010 US Census Data, type =>\t\t'import census'"
    puts "\t  To load poll results from json => \t \t'import poll ./data/poll.json"
    puts
    puts "Recommended: import census => import poll => run".center(130)
    puts
  end

  def get_input prompt = "Input: "
    print prompt
    gets.chomp
  end

  def draw_state *options
    output = ""
    candidates = []
    @country.states.each_with_index do |(initials,state), index|
      candidates = state.polls.keys
      output << "\n" if index%3 == 0
      output << initials.to_s + ": "
      if options.include? :polls
        output << " "
        output << blue_highlight(" " + state.electoral_votes.to_s + " ") if state.polls[candidates[0]] > state.polls[candidates[1]]
        output << red_highlight(" " + state.electoral_votes.to_s + " ") if state.polls[candidates[1]] > state.polls[candidates[0]]
        output << " "
      end
      if options.include? :populations
        output << " " + state.electoral_votes.to_s + "\t" unless options.include? :polls
        output << format_num(state.population,10) + "\t" 
      end
      if options.include? :polls
        state.polls.each_with_index do |(candidate,percent), index|
          output << blue(percent.to_s) if candidate == candidates[0]
          output << red(percent.to_s) if candidate == candidates[1]
          output << " / " if index < state.polls.length - 1
        end
      end
      output << "\t\t"
    end
    puts output
    puts 
    print_line("= ")
  end

  def format_num(int, digits)
    ary_with_comas = int.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse.split('')
    ary_with_comas.insert(0, " ") while ary_with_comas.length < digits
    ary_with_comas.join('')
  end

  def print_header
    clear
    puts "                                         \033[34m:::     :::  :::::::: ::::::::::: ::::::::::
                                         :+:     :+: :+:    :+:    :+:     :+:        
                                         +:+     +:+ +:+    +:+    +:+     +:+\033[0m        
                                         +#+     +:+ +#+    +:+    +#+     +#++:++#   
                                          \033[31m+#+   +#+  +#+    +#+    +#+     +#+        
                                           #+#+#+#   #+#    #+#    #+#     #+#       
                                             ###      ########     ###     \@seansellek\033[0m"
    puts
    print_line
    puts
    puts "Vote parses the latest state by state polls and calculates popular vs electoral outcomes.".center(130)
    puts
    print_line
  end
  def blue string
    "\033[34m" + string.to_s + "\033[0m"
  end
  def blue_highlight string
    "\033[44m" + string.to_s + "\033[0m"
  end
  def red string
    "\033[31m" + string.to_s + "\033[0m"
  end
  def red_highlight string
    "\033[41m" + string.to_s + "\033[0m"
  end
end
