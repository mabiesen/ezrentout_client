# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ezrentout/client/version'

Gem::Specification.new do |spec|
  spec.name     = 'ezrentout-client'
  spec.version  = EZRentout::Client::VERSION
  spec.authors  = ['mbiesen']
  spec.email    = ['mabiesen@outlook.com']
  spec.summary  = 'Interfaces with the EZClient API'
  spec.homepage = 'https://www.github.com/mabiesen/ezrentout-client'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://gems.enova.com/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rspec'
end
