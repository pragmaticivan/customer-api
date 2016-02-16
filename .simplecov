SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/app/helpers/'
  add_filter '/app/views/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Libraries', 'lib'
end if ENV["COVERAGE"]
