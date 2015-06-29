class Country
  attr_accessor :states, :population
  def initialize
    @population = 0
    @states = {}
    update_population
  end
  def update_population
    @population = 0
    @states.each {|initials, state|  @population += state.population}
    update_votes
  end
  def import_country population_hash
    @states = {}
    population_hash.each do |state, population|
      initials = state.to_sym
      @states[initials] = State.new(initials, population)
    end
    update_population
  end
  def update_votes
    states.each do |initials, state|
      votes = state.population.to_f * 435 / population
      votes = 1 if votes == 0
      votes += 2
      state.electoral_votes = votes.round
    end
  end
  def apply_polls poll_hash
    poll_hash.each do |state, polls|
      states[state.to_sym].polls = polls
    end
  end
  def get_votes initials
    states[initials].electoral_votes
  end
  def get_state initials
    @states[initials]
  end
  def popular_results
    results = {}
    @states.each_value do |state|
      pop = state.population
      state.polls.each do |candidate, percent|
        results[candidate] ||= 0
        results[candidate] += pop*percent/100
      end if !state.polls.empty?
    end
    results.each do |candidate, tally|
      results[candidate] = tally/population * 100
    end
    results
  end
  def electoral_results
    results = {}
    @states.each do |slug, state|
      if !state.polls.empty?
        winning_candidate, percent = state.polls.max_by {|k,v| v}
        results[winning_candidate] ||= 0
        results[winning_candidate] += state.electoral_votes
      end      
    end
    results
  end
  def add_state slug, population
    @states[slug] = State.new(slug,population)
    update_population
  end
  def state_exists? slug
    return !!@states[slug]
  end
  def set_state_population slug, population
    @states[slug].population = population
    update_population
  end
end