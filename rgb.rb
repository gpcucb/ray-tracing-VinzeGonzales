class Rgb
  attr_accessor :red, :green, :blue

  def initialize(red,green,blue)
    @red = red.to_f
    @green = green.to_f
    @blue = blue.to_f
  end

  def product_color(color)
    r = @red*color.red
    g = @green*color.green
    b = @blue*color.blue
    Rgb.new(r,g,b)
  end

  def color_product(number)
    float_number = number.to_f
    return Rgb.new(@red*float_number, @green*float_number, @blue*float_number)
  end

  def plus_color(color)
    r = @red + color.red
    g = @green + color.green
    b = @blue + color.blue
    Rgb.new(r,g,b)
  end

end
