require "gosu"

class Game < Gosu::Window
  def initialize
    super(1920,1080)
    self.caption = "Asteroids"
    #self.fullscreen = true
    
  end
end

class Entity
  attr_reader :x,:y,:z,:vel_x,:vel_y

  def initialize(x,y,z,vel,dir)
    raise ArgumentError, "cordinates must not me empty" if x==nil || y==nil || z==nil
    raise ArgumentError, "cordinates must be float" unless x.class == Float && y.class == Float && z.class == Float
    raise ArgumentError, "velocity must not me empty" if vel==nil || dir==nil
    raise ArgumentError, "velocity must be float" unless vel.class == Float && dir.class == Float 

    @x = x
    @y = y
    @z = z
    @vel_x = vel * Math.cos(dir)
    @vel_y = vel * Math.sin(dir)
  end

  def update_x(x)
    @x = x if x != nil && x.class == Float
  end
  def update_y(y)
    @y = y if y != nil && y.class == Float
  end
  def update_z(z)
    @z = z if z != nil && z.class == Float
  end

  def update_vel(acc,dir)
    @vel_x += acc * Math.cos(dir) * 0.0166666667
    @vel_y += acc * Math.sin(dir) * 0.0166666667
  end

end


p test = Entity.new(3.0, 3.0, 3.0, 10.0, 0.25*Math::PI)
