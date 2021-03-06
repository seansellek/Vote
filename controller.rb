
class Controller
  attr_accessor :country, :ui, :running, :import, :state
  def initialize
    @country = Country.new
    @ui = UI.new(@country)
    @running = true
    @import = JSON_Importer.new(@country)
    @state = :help
  end

  def run
    user_action while running
  end

  def user_action
    ui.display(state)
    input = ui.get_input
    case input
    when /^\w\w \d+$/i
      input = input.split(' ')
      slug = input[0].upcase
      population = input[1].to_i
      if country.state_exists? slug
        country.set_state_population(slug, population)
      else
        country.add_state(slug, population)
      end
      @state = :display_data unless country.states.empty?
    when /^import census$/i
      import.population
      puts 'Imported 2010 Census Data'
      sleep(1)
      @state = :display_data unless country.states.empty?
    when %r{^import poll [\w/\.]+$}i
      input = input.split(' ')
      import.polls(input[2])
      puts "Imported polls from #{input[2]}"
      sleep(1)
      @state = :display_data unless country.states.empty?
    when /^import poll$/i
      import.polls
      puts 'Imported polls from 2012 election'
      sleep(1)
      @state = :display_data unless country.states.empty?
    when /^import$/i
      import.population
      import.polls
      puts 'Imported population and polls'
      sleep(1)
    when /^list$/i
      @state = :display_data unless country.states.empty?
    when /^run$/i
      @state = :results unless country.states.empty?
    when /^help$/i
      @state = :help
    when /^exit$/i
      @running = false
    else
      puts "'#{input}' is invalid input."
      sleep(1)
    end
  end
end
