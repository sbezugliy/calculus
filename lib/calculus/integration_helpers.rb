module Calculus::IntegrationHelpers

  include Math

  def convert_units(value, dx, dy, dz)
    value * dx * dy * dz
  end

  def density_f
    -> (ro_min, ro_max) {
      rand(ro_min.to_f ... ro_max.to_f)
    }
  end

  def fake_density
    -> (ro_min, ro_max, x, y, z) {
      (rand(ro_min.to_f ... ro_max.to_f) * (cos(x * y) + cos(z))).abs
    }
  end

  def actual_approximation(dx, dy, dz)
    ((dx * dy * dz).to_s.split('.').last.size).to_i + 2
  end

end