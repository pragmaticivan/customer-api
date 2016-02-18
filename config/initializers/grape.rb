Rails.application.config do |config|
  config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
  config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
end
