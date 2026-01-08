module Mailkick
  class Engine < ::Rails::Engine
    isolate_namespace Mailkick

    initializer "mailkick" do |app|
      Mailkick.discover_services unless Mailkick.services.any?

      # avoid app.key_generator due to https://github.com/ankane/ahoy_email/pull/168
      Mailkick.secret_token ||= ActiveSupport::KeyGenerator.new(app.secret_key_base, iterations: 1000, hash_digest_class: OpenSSL::Digest::SHA1).generate_key("mailkick")
    end
  end
end
