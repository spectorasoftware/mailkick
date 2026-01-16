module Mailkick
  class Engine < ::Rails::Engine
    isolate_namespace Mailkick

    initializer "mailkick" do |app|
      Mailkick.discover_services unless Mailkick.services.any?

      # avoid app.key_generator due to https://github.com/ankane/ahoy_email/pull/168
      # hash_digest_class option added in Rails 7.0; Rails 6.1 uses SHA1 by default
      key_generator_options = { iterations: 1000 }
      key_generator_options[:hash_digest_class] = OpenSSL::Digest::SHA1 if Rails::VERSION::MAJOR >= 7
      Mailkick.secret_token ||= ActiveSupport::KeyGenerator.new(app.secret_key_base, **key_generator_options).generate_key("mailkick")
    end
  end
end
