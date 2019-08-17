module Calculus
  class IntegralsWindow
    class << self
      include Singleton
      include IntegrationHelpers

      METALS = [ 
        :all_metals,
        :steel,
        :copper,
        :lead,
        :mercury
      ] 

      def call(f)
        f.clear
        f.orientation = :horizontal
        set_panes(f)
        @axes = { x: 0.9, dx: 0.01, 
                  y: 2.2, dy: 0.1, 
                  z: 1.3, dz: 0.1}
        @axes_inputs = {}
        set_inputs()
        set_buttons(f)
        f.break
        menu(f)
      end

      def set_panes(f)
        @pramas_pane = f.pane("params")
        @plot_pane = f.pane("plot")
        @axis_pane = @pramas_pane.subpane("axis")
        @discretization_pane = @pramas_pane.subpane("discretization")
        @messages_pane = @pramas_pane.subpane("messages")
        @results_pane = @pramas_pane.subpane("results")
      end

      def set_inputs()
        @axis_pane.puts "X: "
        @axes_inputs[:x] = @axis_pane.input("Length", keep_label: true, value: @axes[:x])
        @axis_pane.puts "Y: "
        @axes_inputs[:y] = @axis_pane.input("Width",  value: @axes[:y])
        @axis_pane.puts "Z: "
        @axes_inputs[:z] = @axis_pane.input("Height", value: @axes[:z])
        @discretization_pane.puts "dx: "
        @axes_inputs[:dx] = @discretization_pane.input("dX", value: @axes[:dx])
        @discretization_pane.puts "dy: "
        @axes_inputs[:dy] = @discretization_pane.input("dY", value: @axes[:dy])
        @discretization_pane.puts "dz: "
        @axes_inputs[:dz] = @discretization_pane.input("dZ", value: @axes[:dz])
        @axes_inputs
      end

      def read_axes_inputs(f) 
        { x: @axes_inputs[:x].to_s, dx: @axes_inputs[:dx].to_s,
          y: @axes_inputs[:y].to_s, dy: @axes_inputs[:dy].to_s,
          z: @axes_inputs[:z].to_s, dz: @axes_inputs[:dz].to_s
        }.each_pair do |key, value|
          if /^?([1-9]\d*|0)(\.\d+)?$/.match(value)
            @axes[key] = value.to_f
          else
            @messages_pane.puts "Value of #{key} should be number".red
          end
        end
      end

      def set_buttons(f)
        METALS.each do |metal|
          f.button(metal.to_s.capitalize) {
            @messages_pane.clear
            read_axes_inputs(f)
            self.send(metal)
          }
        end
      end

      def menu(f)
        f.button("Back" ){
          f.pane("results").close
          f.pane("plot").close
          f.pane('axis').close
          f.pane('discretization').close
          f.pane('messages').close
          f.pane("params").close
          f.clear
          MainWindow.call(f)
        }
        f.button("Close"){
          f.close
        }
      end

      def all_metals()
        clear_results
        @alloy = Calculus::Metal.new(@axes)
        @alloy.set_parameters
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("All metals alloy", @alloy)
      end

      def steel
        clear_results
        @alloy = Steel.new(@axes)
        @alloy.set_parameters
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Steel", @alloy)
      end

      def uneven_steel
        clear_results
        @plot_pane.clear
        @alloy = Steel.new(@axes)
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
        @plot_pane.clear
        @alloy = Copper.new(@axes)
        @alloy.set_parameters
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Copper", @alloy)
      end

      def lead
        clear_results
        @alloy = Lead.new(@axes)
        @alloy.set_parameters
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Lead", @alloy)
      end

      def mercury
        clear_results
        @alloy = Mercury.new(@axes)
        @alloy.set_parameters
        @alloy.density_function = -> (ro_min, ro_max) {ro_min.to_f} 
        @alloy.integrate
        @alloy.get_mass
        @alloy.get_average_density
        output_info("Mercury", @alloy)
      end
      
      def clear_results
        @results_pane.clear
        @plot_pane.clear
      end

      def output_info(name, alloy)
        @results_pane.break
        @results_pane.puts "#{name.upcase}".green
        @results_pane.break
        @results_pane.puts "Density (kg/(meter^3)):".green
        @results_pane.puts "  min: #{alloy.min_density}".blue
        @results_pane.puts "  max: #{alloy.max_density}".blue
        @results_pane.break
        @results_pane.puts "Mass (kg): ".green
        @results_pane.puts "  #{alloy.mass}".blue
        @results_pane.puts "Average density(kg/(meter^3)): ".green
        @results_pane.puts "  #{alloy.average_density}".blue
        @results_pane.break
        @results_pane.puts "Approximation, digits after point: ".green
        @results_pane.puts "  #{alloy.approximation}".blue
        @results_pane.break
        @results_pane.puts "Plotted first dz unit by height only".yellow
        @results_pane.break
        @plot_pane.plot(@alloy.bar[0].map{|x| {x: x}})
      end
    end
  end
end