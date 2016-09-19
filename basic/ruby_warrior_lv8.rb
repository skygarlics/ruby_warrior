class Player
  def play_turn(w)
    @w = w
    @health ||= 20
    @direction ||= :forward
    @retreat ||= 0
    @front = look(@direction)
    @back = look(d_reverse)
    action(@direction)
    @health = w.health
  end
  
  def action(d, w=@w)
    front(d)
  end

  def front(d, w=@w)
	case @front[0]
	  when 0
	    case @front[1]
		  when 'enemy'; w.attack!(d)
		  when 'captive'; w.rescue!(d)
		  when 'wall'; @direction = d_reverse; w.pivot!(@direction)
	    end
	  when 1, 2
	    case @front[1]
		  when 'enemy'; w.shoot!(d)
		  else; w.walk!(d)
	    end
	  when 3
	    w.walk!(d)
    end
  end

  def archer(d, w=@w)
    if damaged?
      if w.health<12; retreat
      else;w.walk!(d)
      end
    elsif w.health< 19; w.rest!
    else; w.walk!(d)
    end
  end

  def look(d, w=@w)
    i = 0
    w.look(d).each do |s|
	  if s.captive?; return [i, 'captive']
	  elsif s.enemy?; return [i, 'enemy']
	  elsif s.wall?; return[i, 'wall']
	  end
	  i += 1
	  return [i, 'nothing'] if i == 3
    end
  end
  
  
  def damaged?(w=@w)
    w.health<@health
  end
  
  def retreat(w=@w)
    w.walk!(d_reverse)
  end
  
  def d_reverse
    if @direction == :forward; return :backward
    else; return :forward
    end
  end
  
end