require "gosu"

class Game < Gosu::Window
  def initialize
    super(640,480)
    self.caption = "lamas morotter"
    @lama = Gosu::Image.new("media/img/llama.png")
    @lama_x = 320 - (@lama.width)/2
    @lama_y = 210 - (@lama.height)/2

    @carrot = Gosu::Image.new("media/img/carrot.png")
    @carrot_x = Gosu.random(0,width - @carrot.width)
    @carrot_y = Gosu.random(0,height - @carrot.height)

    @monch = Gosu::Sample.new("media/audio/omnomnom.mp3")
    @score = 0

    @font = Gosu::Font.new(24)
  end

  def update
    @lama_x += 5 if Gosu.button_down?(Gosu::KB_D)
    @lama_x -= 5 if Gosu.button_down?(Gosu::KB_A)
    @lama_y += 5 if Gosu.button_down?(Gosu::KB_S)
    @lama_y -= 5 if Gosu.button_down?(Gosu::KB_W)

    @lama_x = @lama_x.clamp(0,width - @lama.width)
    @lama_y = @lama_y.clamp(0,height - @lama.height)

    if Gosu.distance(@lama_x,@lama_y,@carrot_x,@carrot_y) < 60
      @carrot_x = Gosu.random(0,width - @carrot.width)
      @carrot_y = Gosu.random(0,height - @carrot.height)
      @score += 1
      @monch.play
    end

  end

  def draw
    @lama.draw(@lama_x,@lama_y,0)
    @carrot.draw(@carrot_x,@carrot_y,-1)
    @font.draw_text("morötter: #{@score}", 10,10,10)
  end
end

Game.new.show