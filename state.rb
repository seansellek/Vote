########################################################
#                         VOTE                         #
#                      State Class                     #
########################################################
# Holds:
# => A population
# => Poll results in the form of {'candidate' => percent_in_favor}
# => Number of electoral votes (calculated and set by Country class.)
class State
  attr_accessor :population, :polls, :electoral_votes

  def initialize(population, polls = {})
    @polls = polls
    @electoral_votes = 0
    @population = population
  end

  attr_reader :polls
end
