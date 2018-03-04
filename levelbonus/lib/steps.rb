module CrazyCars
  class Steps
    #               ___
    # Solve step   /   \
    #             |  1  |
    #             -------
    # @param [Object] rmagick image
    # @param [Integer] car index on image
    # @return [Integer] binary
    def self.colored_cars(image, index)
      color = Color.pixel_to_color(image, index * 250 + 125, 190)

      color.include?(ONES.first) ? 1 : 0
    end

    #               ___
    # Solve step   /   \
    #             |  2  |
    #             -------
    # @param [Object] rmagick image
    # @param [Integer] car index on image
    # @return [Integer] binary 
    def self.dancing_cars(image, index)
      bit_one = ONES.first
      x = (index * 250) + ((250 / 2) - (WIDTH_SIZE / 2))
      y = (150 - (HEIGHT_SIZE / 2))

      cropped =  image.crop(x, y, WIDTH_SIZE, HEIGHT_SIZE)
      colors = Color.image_to_colors(cropped, bit_one)

      colors.include?(bit_one) ? 1 : 0
    end

    #               ___
    # Solve step   /   \
    #             |  3  |
    #             -------
    # @param [Object] rmagick image
    # @param [Integer] car index on image
    # @return [Integer] binary 
    def self.blue_cars(image, index)
      color = Color.pixel_to_color(image, index * 250 + 125, 190)

      color.include?(ONES.last) ? 1 : 0
    end
  end
end