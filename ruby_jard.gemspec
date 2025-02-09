# frozen_string_literal: true

require_relative 'lib/ruby_jard/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_jard'
  spec.version       = RubyJard::VERSION
  spec.authors       = ['Minh Nguyen']
  spec.email         = ['nguyenquangminh0711@gmail.com']

  spec.summary       = 'Just Another Ruby Debugger'
  spec.description   = 'Ruby Jard provides an unified experience debugging Ruby source code in different platforms and \
                        editors.'
  spec.homepage      = 'https://github.com/nguyenquangminh0711/ruby_jard'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/nguyenquangminh0711/ruby_jard'
  spec.metadata['changelog_uri'] = 'https://github.com/nguyenquangminh0711/ruby_jard'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features|docs|javascripts|images|stylesheets|website|scripts)/})
    end
  end
  spec.bindir        = 'bin'
  spec.executables   = []
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'byebug', '>= 9.1', '< 12.0'
  spec.add_runtime_dependency 'pry', '~> 0.14'
  spec.add_runtime_dependency 'tty-screen', '~> 0.8'
end
