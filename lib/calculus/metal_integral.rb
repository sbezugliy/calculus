module Calculus
  class Metal

    include Calculus::IntegrationHelpers

    attr_writer   :x, :y, :z
    attr_writer   :dx, :dy, :dz
    attr_accessor :ro_min, :ro_max
    attr_reader   :approximation
    attr_accessor :density_function
    attr_reader   :bar
    attr_reader   :mass
    attr_reader   :average_density

    def initialize(x, dx, y, dy, z, dz)
      @x, @y, @z = x, y, z
      @dx ,@dy, @dz = dx ,dy, dz
      @min_density = 543 # kg/m^3, lithium
      @max_density = 22587 # kg/m^3, osmium 
    end

    def set_parameters
      @ro_min = convert_units(@min_density, @dx, @dy, @dz)
      @ro_max = convert_units(@max_density, @dx, @dy, @dz)
      @approximation = actual_approximation(@dx, @dy, @dz)
      @density_function = density_f
    end

    def integrate
      @bar = (0..@z/@dz).map do
        (0..@y/@dy).map do
          (0..@x/@dx).map{|ro| @density_function.(@ro_min, @ro_max)}
        end
      end
    end

    def integrate_by_function
      @bar = (0..@z/@dz).map do |z|
        (0..@y/@dy).map do |y|
          (0..@x/@dx).map do |x|
            @density_function.(@ro_min, @ro_max, x, y, z)
          end
        end
      end
    end

    def get_mass
      @mass = @bar.flatten.sum.round(@approximation)
    end

    def get_average_density
      @average_density = (
        (@bar.flatten.sum/@bar.flatten.length)/@dx/@dy/@dz
      ).round(@approximation)
    end

  end

  class Steel < Metal
    def initialize(x, dx, y, dy, z, dz)
      super(x, dx, y, dy, z, dz)
      @min_density = 7000
      @max_density = 8000
    end
  end

  class Copper < Metal
    def initialize(x, dx, y, dy, z, dz)
      super(x, dx, y, dy, z, dz)
      @min_density = 8020
      @max_density = 8960
    end
  end
  class Lead < Metal
    def initialize(x, dx, y, dy, z, dz)
      super(x, dx, y, dy, z, dz)
      @min_density = 10660
      @max_density = 11340
    end
  end

  class Mercury < Metal
    def initialize(x, dx, y, dy, z, dz)
      super(x, dx, y, dy, z, dz)
      @min_density = 13534
      @max_density = 13534
    end
  end
end