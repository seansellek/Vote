
class JSON_Importer
  def initialize world
    @world = world
  end
  def population
    data_file = File.read("./data/2010census.json")
    population_data = JSON.parse(data_file)
    population_data.each do |state, population|
      initials = state.to_sym
      @world.states[initials] = State.new(initials, population)
    end
    @world.update_population
  end
  def polls path = "./data/poll.json"
    data_file = File.read(path)
    poll_data = JSON.parse(data_file)
    poll_data.each do |state, polls|
      @world.states[state.to_sym].polls = polls
    end
  end
end