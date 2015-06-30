########################################################
#                         VOTE                         #
#                     Country Class                    #
########################################################
# Holds:
# => A hash of states in the form of  {:FL => state_object}
# => A national population
# => Methods for manipulating it's states
# => Methods for calculating electoral votes & election results
class Country
  attr_accessor :states, :population
  def initialize
    @population = 0
    @states = {}
    update_population
  end

  ##
  # UPDATE POPULATION
  # => Updates national population and calls update_votes
  ##
  def update_population
    @population = 0
    @states.each { |_initials, state|  @population += state.population }
    update_votes
  end

  ##
  # IMPORT COUNTRY
  # => takes a hash in the form of {"AL": 4802982} and imports it to @states hash
  ##
  def import_country(population_hash)
    @states = {}
    population_hash.each do |state, population|
      initials = state.to_sym
      @states[initials] = State.new(population)
    end
    update_population
  end

  ##
  # UPDATE VOTES
  # => Updates each state's electoral vote count
  ##
  def update_votes
    states.each do |_initials, state|
      votes = state.population.to_f * 435 / population
      votes = 1 if votes == 0
      votes += 2
      state.electoral_votes = votes.round
    end
  end

  ##
  # APPLY POLLS
  # => Takes a hash in the form shown below and stores each poll object to it's
  # requisite state in @states
  # {
  #   "AL": {
  #     "obama": 38.4,
  #     "romney": 60.7
  #    }
  # }
  ##
  def apply_polls(poll_hash)
    poll_hash.each do |state, polls|
      states[state.to_sym].polls = polls
    end
  end

  ##
  # GET VOTES
  # => Takes state initials as argument and retrieves electoral votes for that state
  ##
  def get_votes(initials)
    states[initials].electoral_votes
  end

  ##
  # Get State
  # => Retrieves state object from supplied initials
  ##
  def get_state(initials)
    @states[initials]
  end

  ##
  # POPULAR RESULTS
  # => Calculates popular results and returns a hash in the form of
  # { "candidate" => percent_votes_earned}
  ##
  def popular_results
    results = {}
    @states.each_value do |state|
      pop = state.population
      state.polls.each do |candidate, percent|
        results[candidate] ||= 0
        results[candidate] += pop * percent / 100
      end unless state.polls.empty?
    end
    results.each do |candidate, tally|
      results[candidate] = tally / population * 100
    end
    results
  end

  ##
  # ELECTORAL RESULTS
  # => Calculates electoral results and returns a hash in the form of
  # { "candidate" => count_votes_earned}
  ##
  def electoral_results
    results = {}
    @states.each do |_slug, state|
      next if state.polls.empty?
      winning_candidate, _percent = state.polls.max_by { |_k, v| v }
      results[winning_candidate] ||= 0
      results[winning_candidate] += state.electoral_votes
    end
    results
  end

  ##
  # ADD STATES
  # => Creates a state with specified initials and population
  ##
  def add_state(slug, population)
    @states[slug] = State.new(population)
    update_population
  end

  ##
  # STATE EXISTS?
  # => Returns TRUE if state exists, false otherwise
  ##
  def state_exists?(slug)
    @states[slug] ? true : false
  end

  ##
  # SET STATE POPULATION
  # => Updates population for specified state
  ##
  def set_state_population(slug, population)
    @states[slug].population = population
    update_population
  end
end
