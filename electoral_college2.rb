require 'minitest/autorun'

class State
  @@total_population = 0
  @@all_states = []
  attr_accessor :initials, :population, :split, :electoral_votes

  def initialize initials, population, split = {dem: 50, rep: 50}
    @split = split
    @initials = initials
    @electoral_votes = 0
    @population = population
    @@total_population += population
    @@all_states << self
    State.update_electoral_votes
  end

  def population= pop_update
    @@total_population -= population
    @population = pop_update
    @@total_population += population
    State.update_electoral_votes
  end
  def self.total_population
    @@total_population
  end

  def self.reset
    @@total_population = 0
    @@all_states = []
  end

  def self.update_electoral_votes
    @@all_states.each do |state|
      votes = state.population * 435 / @@total_population
      votes = 1 if votes == 0
      votes += 2
      state.electoral_votes = votes
    end
  end
  def method_missing m
    split[m] * population / 100
  end
end






class TestVoterSim < Minitest::Test
  def test_state
    State.reset
    florida = State.new(:FL, 10000, {dem: 45, rep: 55})
    assert_equal florida.dem, 4500
  end
  def test_state_apply_split
    State.reset
    florida = State.new(:FL, 10)
    assert_equal florida.split, {dem: 50, rep: 50}
    florida.split = {dem: 30, rep: 70}
    assert_equal florida.dem, 3
  end
  def test_state_pop_change
    State.reset
    florida = State.new(:FL, 10, {dem: 30, rep: 70 })
    florida.population = 12
    assert_equal 12, florida.population
    assert_equal 3, florida.dem
  end
  def test_state_pop_reduction
    State.reset
    florida = State.new(:FL, 4)
    alabama = State.new(:AL, 3)
    florida.population = 2
    alabama.population = 12
    assert_equal 14, State.total_population
  end
  def test_electoral_college_assignment
    State.reset
    florida = State.new(:FL, 100)
    alabama = State.new(:AL, 200)
    assert_equal 147, florida.electoral_votes
    assert_equal 292, alabama.electoral_votes
    kentucky = State.new(:KT, 1)
    assert_equal 3, kentucky.electoral_votes
  end
  def test_popular_vote
    

  end
end
