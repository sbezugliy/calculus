
module Calculus
  class MainWindow
    include Singleton

    def self.call(f)
      f.clear
      f.button("Integrals") {IntegralsWindow.call(f)}
      f.button("Close") { f.close }
    end
  end
end