Rails.application.config.generators do |g|
  g.jbuilder false
  g.template_engine :erb
  g.test_framework :test_unit,
    fixtures: true,
    helper_specs: false,
    routing_specs: false,
    controller_specs: true,
    request_specs: true
end
