Rails.application.config.generators do |g|
  g.assets false
  g.helper false
  g.test_framework :rspec,
    fixtures: true,
    view_specs: false,
    helpers_specs: false,
    controller_specs: false,
    request_specs: false
  g.fixture_replacement :factory_girl, dir: 'spec/factories'
  g.jbuilder false
end
