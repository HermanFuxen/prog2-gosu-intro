require "gosu"

class Game < Gosu::Window
  def initialize
    @window_width = 1920
    @window_height = 1080 
    super(@window_width,@window_height)
    self.caption = "Asteroids"
    #self.fullscreen = true
    @thruster = Gosu::Image.new("media/img/player_thrust.png")
    @player = Player.new("media/img/player.png",(@window_width/2.0)-47,(@window_height/2.0)-32,0.0,0.0,@window_width,@window_height)
    @bullets = []
    @asteroids = []
    @coldown1 = Time.now
    @coldown2 = Time.now + 5
  end

  def update
    # --player movement--
    @player.update_x
    @player.update_y
    @player.update_dir(@player.dir + 0.1) if Gosu.button_down?(Gosu::KB_RIGHT)
    @player.update_dir(@player.dir - 0.1) if Gosu.button_down?(Gosu::KB_LEFT)
    @player.update_vel(5) if Gosu.button_down?(Gosu::KB_SPACE)

    # --bullets--
    if Gosu.button_down?(Gosu::KB_W) && @coldown1 < Time.now
      @bullets << Bullet.new("media/img/bullet.png",@player.x,@player.y,15.0,@player.dir,@player.vel_x,@player.vel_y)
      @coldown1 = Time.now + 0.3
    end
    
    @bullets.each do |x|
      if x.x.between?(-64,@window_width) == false || x.y.between?(-32,@window_height) == false
        @bullets.delete(x)
      end
      x.update_x
      x.update_y
    end
    
    # -- asteroids --
    if @coldown2 < Time.now 
      @coldown2 = Time.now + 10
      #@asteroids < Asteroid.new(image_path,x,y,vel,dir)
    end

  end

  def draw
    if Gosu.button_down?(Gosu::KB_SPACE)
      @thruster.draw_rot(@player.x,@player.y,0,(@player.dir * 180/Math::PI))
    else 
      @player.draw_rot(@player.x,@player.y,0,(@player.dir * 180/Math::PI))
    end
    @bullets.each do |x|
      x.draw_rot(x.x,x.y,0,(x.dir * 180/Math::PI))
    end
  end
  

end

class Entity < Gosu::Image
  attr_reader :x,:y,:vel_x,:vel_y,:dir

  def initialize(image_path,x,y,vel,dir)
    super(image_path)
    raise ArgumentError, "cordinates must not me empty" if x==nil || y==nil
    raise ArgumentError, "cordinates must be float" unless x.class == Float && y.class == Float
    raise ArgumentError, "velocity must not me empty" if vel==nil || dir==nil
    raise ArgumentError, "velocity must be float" unless vel.class == Float && dir.class == Float 

    @x = x
    @y = y
    @vel_x = vel * Math.cos(dir)
    @vel_y = vel * Math.sin(dir)
    @dir = dir
  end

  def update_x
    @x +=@vel_x
  end
  def update_y
    @y += @vel_y
  end
  
  def update_vel(acc)
    @vel_x += acc * Math.cos(@dir) * 0.0166666667
    @vel_y += acc * Math.sin(@dir) * 0.0166666667

    @vel_x = 0 if @vel_x.abs < 0.01
    @vel_y = 0 if @vel_y.abs < 0.01
  end

  def update_dir(new_dir)
    @dir = new_dir
  end

end

class Player < Entity
  def initialize(image_path,x,y,vel,dir,window_width,window_height)
    super(image_path,x,y,vel,dir)
    @window_width = window_width
    @window_height = window_height
  end

  def update_x
    super
    @x = @x + @window_width + 94 if x + 47 < 0
    @x = @x - @window_width - 94 if x - 47 > @window_width
  end
  def update_y
    super
    @y = @y + @window_height + 64 if y + 32 < 0
    @y = @y - @window_height - 64 if y - 32 > @window_height
  end
end

class Bullet < Entity
  def initialize(image_path,x,y,vel,dir,player_vel_x,player_vel_y)
    super(image_path,x,y,vel,dir)
    @vel_x += player_vel_x
    @vel_y += player_vel_y  
  end
end

class Asteroid < Entity
#  def initialize(image_path,x,y,vel,dir)
#    super(image_path,x,y,vel,dir)
#  end
end

Game.new.show