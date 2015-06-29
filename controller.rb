
class Controller
  attr_accessor :country, :ui, :running, :import, :state
  def initialize
    @country = Country.new()
    @ui = UI.new(@country)
    @running = true
    @import = JSON_Importer.new(@country)
    @state = :help
  end
  def run
    get_user_action while running
  end
  def get_user_action
    ui.display(state)
    input = ui.get_input()
    case input
      when /^import census$/i
        import.population
        puts "Imported 2010 Census Data"
      when /^import poll [\w\/\.]+$/i
        input = input.split(' ')
        import.polls(input[2])
        puts "Imported polls from #{input[2]}"
      when /^run$/i
        @state = :display_data unless country.states.empty?
      when /^help$/i
        @state = :help
    end
  end

end