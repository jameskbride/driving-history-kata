module DrivingCalculations
  def calc_speed(minutes, distance)
    normalized_minutes = minutes / 60

    normalized_minutes > 0 ? (distance / normalized_minutes).round.to_i : nil
  end
end