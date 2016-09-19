class Player
  def play_turn(w)
    @health ||= w.health
	@bound ||= []
    @w = w
	@sD = w.direction_of_stairs
	@aD = [:forward, :backward, :left, :right]
	@felt = feel
	action
	@health = w.health
  end

  def action(w=@w)
    a = false
    
	if @felt.value?(:enemy)
      @felt.each do |d, v|
	    if v == :enemy
		  w.bind!(d); @bound.push(d)
		  a = true; break
		end
      end

    elsif @felt.value?(:captive)
	  @felt.each do |d, v|
		if w.health < 15; w.rest!; a= true; break
		elsif v==:captive && !@bound.include?(d);
		  w.rescue!(d)
		  a = true; break
		elsif v==:captive && @bound.include?(d);
		  w.attack!(d); @bound.delete(d);
		  a = true; break
		end
	  end

	elsif a == false
	  if w.health<14; w.rest!
      else; w.walk!(@sD)
	  end
	end

  end


  def feel(w=@w)
    felt = {}
    @aD.each do |d|
	  if w.feel(d).enemy?; felt[d] = :enemy
	  elsif w.feel(d).captive?; felt[d] = :captive
	  else; felt[d] = :nothing
	  end
	end
	return felt
  end


end