module Calculus
  class IntegralsWindow
    class << self
      include Singleton
      include IntegrationHelpers

      def call(f)
        f.clear
        f.orientation = :horizontal
        @p_results = f.pane("results")
        @p_plot = f.pane("plot")
        f.button("All metals") {all_metals()}
        f.button("Steel") {steel()}
        f.button("Uneven steel") {uneven_steel()}
        f.button("Copper") {copper()}
        f.button("Lead") {lead()}
        f.button("Mercury") {mercury()}
        f.break
        menu(f)
      end

      def menu(f)
        f.button("Back" ){
          f.pane("results").close
          f.pane("plot").close
          MainWindow.call(f)
        }
        f.button("Close"){
          f.close
        }
      end

      def all_metals()
        clear_results
        @alloy = Calculus::Metal.new(0.9, 0.01, 2.2, 0.1, 1.3, 0.1)
        @alloy.set_parameters
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("All metals alloy", @alloy)
      end

      def steel
        clear_results
        @alloy = Steel.new(0.9, 0.01, 2.2, 0.1, 1.3, 0.1)
        @alloy.set_parameters
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Steel", @alloy)
      end

      def uneven_steel
        clear_results
        @p_plot.clear
        @alloy = Steel.new(0.9, 0.01, 2.2, 0.1, 1.3, 0.1)
        @alloy.set_parameters
        # Redefined function 
        # and used integration method which uses function by (dx)(dy)(dz)
        @alloy.density_function = fake_density 
        @alloy.integrate_by_function
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Uneven steel", @alloy)
      end

      def copper
        clear_results
        @p_plot.clear
        @alloy = Copper.new(0.9, 0.01, 2.2, 0.1, 1.3, 0.1)
        @alloy.set_parameters
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Copper", @alloy)
      end

      def lead
        clear_results
        @alloy = Lead.new(0.9, 0.01, 2.2, 0.1, 1.3, 0.1)
        @alloy.set_parameters
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Lead", @alloy)
      end

      def mercury
        clear_results
        @alloy = Mercury.new(0.9, 0.01, 2.2, 0.1, 1.3, 0.1)
        @alloy.set_parameters
        @alloy.density_function = -> (ro_min, ro_max) {ro_min.to_f} 
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Mercury", @alloy)
      end
      
      def clear_results
        @p_results.clear
        @p_plot.clear
      end

      def output_info(name, alloy)
        @p_results.puts "#"*20
        @p_results.puts "-"*20
        @p_results.puts " #{name.upcase}:"
        @p_results.puts "-"*20
        @p_results.puts "   Mass : "
        @p_results.puts "     #{alloy.mass} kg"
        @p_results.puts "   Average density: "
        @p_results.puts "     #{alloy.average_density} kg/(meter^3)"
        @p_results.puts "-"*20
        @p_plot.plot(@alloy.bar[0])
      end
    end
  end
end