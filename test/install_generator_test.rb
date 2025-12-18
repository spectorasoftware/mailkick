require_relative "test_helper"

require "generators/mailkick/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Mailkick::Generators::InstallGenerator
  destination File.expand_path("../tmp", __dir__)
  setup :prepare_destination

  def test_works
    run_generator
    assert_migration "db/migrate/create_mailkick_subscriptions.rb", /create_table :mailkick_subscriptions do/
  end

  def test_primary_key_type
    with_generator_options({active_record: {primary_key_type: :uuid}}) do
      run_generator
    end
    assert_migration "db/migrate/create_mailkick_subscriptions.rb", /id: :uuid/
    assert_migration "db/migrate/create_mailkick_subscriptions.rb", /type: :uuid/
  end

  private

  def with_generator_options(value)
    previous_value = Rails.configuration.generators.options
    begin
      Rails.configuration.generators.options = value
      yield
    ensure
      Rails.configuration.generators.options = previous_value
    end
  end
end
