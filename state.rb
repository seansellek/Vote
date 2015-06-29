class State
  attr_accessor :population, :polls, :electoral_votes

  def initialize slug, population, polls = {}
    @polls = polls
    @slug = slug
    @electoral_votes = 0
    @population = population
  end
  def polls
    @polls
  end
end