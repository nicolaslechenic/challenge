module CrazyCars
  class Color
    def self.pixel_to_color(image, x, y)
      pixel_coordinates = image.pixel_color(x, y)
      image.to_color(pixel_coordinates)
    end

    # Faster than image.each_pixel
    #
    # Get color of each  image pixel and break if
    # color is known as 0 or 1 (PINK or bit_one)
    #
    # @param [Object] rmagick image
    # @param [String] bit one code color
    # @return [Array] with image colors
    def self.image_to_colors(image, bit_one)
      Array.new(WIDTH_SIZE) do |x|
        line = Array.new(HEIGHT_SIZE) do |y|
          color = pixel_to_color(image, x, y)

          break [color] if color == bit_one
          break [color] if color == PINK

          color
        end

        break line if line.size < HEIGHT_SIZE
      end.flatten.uniq
    end
  end
end
