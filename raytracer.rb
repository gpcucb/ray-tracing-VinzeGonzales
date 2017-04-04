require_relative 'renderer.rb'
require_relative 'camera.rb'
require_relative 'vector.rb'
require_relative 'rgb.rb'
require_relative 'intersection.rb'
require_relative 'sphere.rb'
require_relative 'triangle.rb'
require_relative 'light.rb'
require_relative 'material.rb'

class RayTracer < Renderer

  attr_accessor :camera

  def initialize(width, height)
    super(width, height, 250.0, 250.0, 250.0)

    @nx = @width
    @ny = @height
    # Camera values
    e= Vector.new(0,0,-500)
    center= Vector.new(0,0,0)
    up= Vector.new(0,1,0)
    fov= 39.31
    df=0.035
    @camera = Camera.new(e, center, up, fov, df)

    # Ambient Values
    @ambient_color = Rgb.new(0.0392,0.1882,0.5372)
    @ambient_coeficient = Rgb.new(0.8,0.8,0.9)
    # Light Values
    light_color = Rgb.new(0.99, 0.0, 0.99)
    light_position = Vector.new(-250.0, 140.0, -100.0)
    @light = Light.new(light_position,light_color)

    light_color2 = Rgb.new(0.66, 0.0, 0.66)
    light_position2 = Vector.new(-20.0, 140.0, -40.0)
    @light2 = Light.new(light_position2,light_color2)

    light_color3 = Rgb.new(0.66, 0.0, 0.66)
    light_position3 = Vector.new(40,90,-400)
    @light3 = Light.new(light_position3,light_color3)

    light_color4 = Rgb.new(0.66, 0.0, 0.66)
    light_position4 = Vector.new(-400,0,70)
    @light4 = Light.new(light_position4,light_color4)

    # Triangle values
    a = Vector.new(150,-30,-480)
    b = Vector.new(250,-30,550)
    c = Vector.new(-480,-30,550)
    triangle_diffuse = Rgb.new(0.2352,0.6392,0.7647)
    triangle_specular = Rgb.new(1.0,1.0,1.0)
    triangle_reflection = 0.5
    triangle_power = 10000
    triangle_material = Material.new(triangle_diffuse, triangle_reflection, triangle_specular, triangle_power)

    #Triangle values 2
    a2 = Vector.new(150,-30,-480)
    b2 = Vector.new(-60,-30,-480)
    c2 = Vector.new(-480,-30,550)

    # Sphere values
    position = Vector.new(0,80,0)
    radius = 50
    sphere_diffuse = Rgb.new(0.66, 0.108, 0.66)
    sphere_specular =Rgb.new(1.0,1.0,1.0)
    sphere_reflection = 0.5
    sphere_power = 150
    sphere_material = Material.new(sphere_diffuse, sphere_reflection, sphere_specular, sphere_power)

# Sphere values 2
    position2 = Vector.new(50,0,-380)
    radius2 = 35
    sphere_diffuse2 = Rgb.new(0.66, 0.108, 0.66)
    sphere_specular2 =Rgb.new(1.0,1.0,1.0)
    sphere_reflection2 = 0.5
    sphere_power2 = 300
    sphere_material2 = Material.new(sphere_diffuse2, sphere_reflection2, sphere_specular2, sphere_power2)

# Sphere values 3
    position3 = Vector.new(-90,0,80)
    radius3 = 35
    sphere_diffuse3 = Rgb.new(0.66, 0.108, 0.66)
    sphere_specular3 =Rgb.new(1.0,1.0,1.0)
    sphere_reflection3 = 0.5
    sphere_power3 = 200
    sphere_material3 = Material.new(sphere_diffuse3, sphere_reflection3, sphere_specular3, sphere_power3)

# Sphere values 4
    position4 = Vector.new(-240,0,80)
    radius4 = 25
    sphere_diffuse4 = Rgb.new(0.66, 0.108, 0.66)
    sphere_specular4 =Rgb.new(1.0,1.0,1.0)
    sphere_reflection4 = 0.5
    sphere_power4 = 200
    sphere_material4 = Material.new(sphere_diffuse4, sphere_reflection4, sphere_specular4, sphere_power4)

    @sphere = Sphere.new(position, radius, sphere_material)
    @sphere2 = Sphere.new(position2, radius2, sphere_material2)
    @sphere3 = Sphere.new(position3, radius3, sphere_material3)
    @sphere4 = Sphere.new(position4, radius4, sphere_material4)
    @triangle = Triangle.new(a, b, c, triangle_material)
    @triangle2 = Triangle.new(a2, b2, c2, triangle_material)
    @objects=[]
    @objects << @triangle << @sphere <<@triangle2 <<@sphere2 <<@sphere3<<@sphere4
  end




  def calculate_lambertian_shading(intersection_point, intersection_normal, ray, light, object)
    n = intersection_point.normalize
    l = light.position.minus(intersection_point).normalize
    nl = n.scalar_product(l)

    kd = object.material.diffuse

    i = light.color
    color = kd.product_color(i.color_product([0,nl].max))

    return color

  end

  def blinn_phong_shading(intersection_point, intersection_normal, ray, light, object)
    n = intersection_point.normalize
    l = light.position.minus(intersection_point).normalize
    nl = n.scalar_product(l)

    kd = object.material.diffuse
    kdI = kd.product_color(light.color)

    v = (ray.position).minus(intersection_point).normalize
    ks = object.material.specular
    h = v.plus(l).normalize
    nh = n.scalar_product(h)

    ksI = ks.product_color(light.color)
    phong_val = object.material.power

    phong = ksI.color_product(([0,nh].max)**phong_val)
    lambert = kdI.color_product([0,nl].max)

    result = phong.plus_color(lambert)
  end

  def ambient_shadding(intersection_point, intersection_normal, ray, light, object, ambient_color, ambient_coeficient)
    n = intersection_point.normalize
    l = light.position.minus(intersection_point).normalize
    nl = n.scalar_product(l)
    kd = object.material.diffuse
    kdI = kd.product_color(light.color)

    v = (ray.position).minus(intersection_point).normalize
    ks = object.material.specular
    h = v.plus(l).normalize
    nh = n.scalar_product(h)

    ksI = ks.product_color(light.color)
    phong_val = object.material.power

    phong = ksI.color_product(([0,nh].max)**phong_val)
    lambert = kdI.color_product([0,nl].max)

    ambient = ambient_coeficient.product_color(ambient_color)

    result = ambient.plus_color(phong.plus_color(lambert))
  end

  def raycolor(ray,t0,t1)
    if condition

    end

  end

  def calculate_pixel(i, j)
    e = @camera.e
    dir = @camera.ray_direction(i,j,@nx,@ny)
    ray = Ray.new(e, dir)
    t = Float::INFINITY
    t2 = Float::INFINITY

    @obj_int = nil#intersected object
    @objects.each do |obj|
      intersection = obj.intersection?(ray, t)
      if intersection.successful?
        @obj_int = obj
        t = intersection.t

        ray2 = Ray.new((ray.position).plus(ray.direction.num_product(t)),dir)
        intersection2 = obj.intersection?(ray2, t2)

      end
    end
    if @obj_int==nil
      color = Rgb.new(i.to_f/@nx, 1.0/(@nx-@ny), j.to_f/@ny)
    else
      intersection_point = (ray.position).plus(ray.direction.num_product(t))
      intersection_normal = @obj_int.normal(intersection_point)



      lambert = calculate_lambertian_shading(intersection_point, intersection_normal, ray, @light, @obj_int)
      phong = blinn_phong_shading(intersection_point, intersection_normal, ray, @light, @obj_int)
      phong2 = blinn_phong_shading(intersection_point, intersection_normal, ray, @light2, @obj_int)
      phong3 = blinn_phong_shading(intersection_point, intersection_normal, ray, @light3, @obj_int)
      phong4 = blinn_phong_shading(intersection_point, intersection_normal, ray, @light4, @obj_int)
      ambient = ambient_shadding(intersection_point, intersection_normal, ray, @light, @obj_int,@ambient_coeficient,@ambient_color)

      multi_light = @ambient_coeficient.product_color(@ambient_color).plus_color(phong).plus_color(phong2).plus_color(phong3)#.plus_color(phong4)

      # color = lambert
      # color = phong
      # color = ambient
      color = multi_light
      # color = @obj_int.material.diffuse #2D
    end

    return {red: color.red, green: color.green, blue: color.blue}
  end




end
