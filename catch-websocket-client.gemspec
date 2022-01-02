lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'catch-websocket-client/version'

Gem::Specification.new do |spec|
  spec.name          = "catch-websocket-client"
  spec.version       = CatchWebSocket::VERSION
  spec.authors       = ["nierouter"]
  spec.email         = ["nierouter@gmail.com"]
  spec.description   = %q{Catch WebSocket Client for Ruby}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/nierouter/catch-websocket-client"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.7.5'

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
  end

  spec.files         = `git ls-files`.split($/).reject{|f| f == "Gemfile.lock" }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "socket"
  spec.add_dependency "websocket"
  spec.add_dependency "timeout"
  spec.add_dependency "openssl"
  spec.add_dependency "uri"
  spec.add_dependency "json"
end
