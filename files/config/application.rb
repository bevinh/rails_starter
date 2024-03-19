
## This file is only to be used if MONGOID selection is chosen
require "rails"
require "action_controller/railtie" rescue LoadError
require "action_view/railtie" rescue LoadError
require "action_mailer/railtie" rescue LoadError
require "active_job/railtie" rescue LoadError
require "action_cable/engine" rescue LoadError
require "rails/test_unit/railtie" rescue LoadError
