class Player
  def play_turn(w)
    @sDirection = w.direction_of_stairs
    w.walk!(@sDirection)
  end
end