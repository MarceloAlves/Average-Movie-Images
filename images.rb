require 'RMagick'
include Magick

images = ImageList.new
hash = Hash.new
counter = 0

Dir.glob("images/*.png") do |item|
  images.read(item)
  counter += 1
end

puts "Found #{counter} images"

(0..images.first.columns).each do |x|
  (0..images.first.rows).each do |y|
    key = "#{x},#{y}"
    hash[key] = {:red => 0, :green => 0, :blue => 0}
  end
end

images.each do |img|
  (0..img.columns).each do |x|
    (0..img.rows).each do |y|
      key = "#{x},#{y}"
      pixel = img.pixel_color(x, y)
      hash[key][:red] += pixel.red
      hash[key][:green] += pixel.green
      hash[key][:blue] += pixel.blue
    end
  end
  puts "Finished #{img.filename}"
end

finalimage = Image.new(images.first.columns, images.first.rows)

hash.each do |k,v|
  x = k.split(',').first.to_i
  y = k.split(',').last.to_i

  r = v[:red] / counter
  g = v[:green] / counter
  b = v[:blue] / counter

  pixel = Pixel.new(r,g,b,1)
  finalimage.pixel_color(x,y,pixel)
end

finalimage.write('final.png')