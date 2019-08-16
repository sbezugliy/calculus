require "calculus/version"
require 'singleton'
require 'flammarion'
require 'colorized'
require 'calculus/integration_helpers'
require 'calculus/metal_integral'

require 'calculus/main_window'
require 'calculus/integrals_window'

module Calculus
  
  class Error < StandardError; end

  class Main

    include IntegrationHelpers

    def initialize
      f = Flammarion::Engraving.new(exit_on_disconnect: true)
      MainWindow.call(f)
      f.wait_until_closed
    end

  end
end