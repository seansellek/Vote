

class Voter
  @@all_voters = []
  attr_accessor :aff, :state
  def initialize state, affiliation = nil
    @state = state
    @aff = affiliation
    @@all_voters << self
  end

  def self.remove_by_state state_to_remove
    @@all_voters.delete_if {|voter| voter.state == state_to_remove}
  end
  def self.reset
    @@all_voters = []
  end
  def self.count
    @@all_voters.length
  end
  def self.[] i
    @@all_voters[i]
  end
  def self.all_voters
    @@all_voters
  end
  def self.method_missing(m, *args, &block)
    voters = []
    @@all_voters.each do |voter|
      voters << voter if voter.aff == m
    end
    return voters unless voters.empty?
    raise "'#{m.to_s}' No Method or No Voters of That Affiliation"
  end
end

class State
  @@all_states = []
  @@total_population = 0
  attr_accessor :name, :population, :split, :electoral_votes
  def initialize(name, population, split = {dem: 50, rep:50})
    @split = split
    @name = name
    @population = population
    @electoral_votes = 0
    set_population(population)
    update_pop_split
    @@all_states << self
    State.update_electoral_votes
  end
  def split= split_hash
    @split = split_hash
    update_pop_split
  end
  def set_population new_pop
    @population = new_pop
    Voter.remove_by_state(name)
    @voters = Array.new(population) {Voter.new(name)}
    update_pop_split
  end

  def update_pop_split
    parties = []
    split.each do |key, value|
      party = key
      proportion = value
      parties << {party: party, count: population * proportion / 100}
    end
    i = 0
    parties.each do |party|
      party[:count].times do
        voters[i].aff = party[:party]
        i+=1
      end
    end
  end

  def self.update_electoral_votes
    @@all_states.each do |state|
      votes = state.population*435/Voter.count
      votes = 1 if votes == 0
      votes += 2
      state.electoral_votes = votes
    end
  end

  def self.reset
    @@all_states = []
  end


  def method_missing(m, *args, &block)
    voters = []
    @voters.each do |voter|
      voters << voter if voter.aff == m
    end
    return voters unless voters.empty?
    raise "'#{m.to_s}' No Method or No Voters of That Affiliation"
  end

  private

  def voters
    @voters
  end

end


require 'minitest/autorun'
class TestVoterSim < Minitest::Test
  def test_voter_aff
    Voter.reset
    voter = Voter.new(:FL, :dem)
    voter = Voter.new(:FL, :dem)
    assert_equal :dem, voter.aff
  end
  def test_voter_counts
    Voter.reset
    voters = []
    10.times {voters << Voter.new(:FL, :tea)}
    assert_equal Voter.all_voters.length, 10
    assert_equal 10, Voter.tea.length
  end
  def test_state
    florida = State.new(:FL, 10000, {dem: 45, rep: 55})
    assert_equal florida.dem.length, 4500
  end
  def test_state_apply_split
    Voter.reset
    florida = State.new(:FL, 10)
    assert_equal florida.split, {dem: 50, rep: 50}
    florida.split = {dem: 30, rep: 70}
    assert_equal florida.dem.length, 3
  end
  def test_state_pop_change
    Voter.reset
    florida = State.new(:FL, 10, {dem: 30, rep: 70 })
    florida.set_population(12)
    assert_equal 12, florida.population
    assert_equal 3, florida.dem.length
  end
  def test_state_pop_reduction
    Voter.reset
    florida = State.new(:FL, 4)
    alabama = State.new(:AL, 3)
    florida.set_population(2)
    alabama.set_population(12)
    assert_equal 14, Voter.all_voters.length
  end
  def test_electoral_college_assignment
    Voter.reset
    florida = State.new(:FL, 100)
    alabama = State.new(:AL, 200)
    assert_equal 147, florida.electoral_votes
    assert_equal 292, alabama.electoral_votes
    kentucky = State.new(:KT, 1)
    assert_equal 3, kentucky.electoral_votes
  end
end
