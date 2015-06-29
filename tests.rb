require 'minitest/autorun'
class TestVoterSim < Minitest::Test
  def prepare_country
    usa = Country.new()
    world_builder = Data_Importer.new(usa)
    world_builder.import_population
    world_builder.import_polls
    return usa
  end
  def test_prepare_country
    usa = prepare_country
    assert_equal 309183463, usa.population
  end
  def test_state
    usa = prepare_country
    florida_pop = usa.get_state(:FL).population
    assert_equal 18900773, florida_pop
  end

  def test_electoral_votes
    usa = prepare_country
    assert_equal 29, usa.get_votes(:FL)
  end

  def test_apply_polls
    usa = prepare_country
    assert_equal usa.get_state(:FL).polls, {"obama" => 50.0, "romney" => 49.1}
  end

  def test_run_popular_election
    usa = prepare_country
    correct_results = { 
      "obama" => 51.1,
      "romney" => 47.2
    }
    assert_in_delta correct_results["obama"], usa.popular_results["obama"], 0.5
    assert_in_delta correct_results["romney"], usa.popular_results["romney"], 0.5
  end

  def test_run_electoral_election
    usa = prepare_country
    correct_results = {
      "obama" => 330,
      "romney" => 206
    }
    assert_equal correct_results, usa.electoral_results[:total]
  end
end
