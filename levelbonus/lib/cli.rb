module CrazyCars
  # Thor is used as Command Line Interface
  # you can type ruby crazy_cars.rb -h to know more
  class CLI < Thor
    desc '-dl --download', 'Download images from dontclickhere.com to local images folder'
    map %w[-dl --download] => :download
    def download
      basename = '0000'

      TOTAL_IMAGES.times do |i|
        original_filename = "img#{i}.png"
        new_filename = "#{basename}.png"
        next if File.file?("#{IMAGES_FOLDER}/#{new_filename}")

        system("wget #{ORIGIN_IMAGES_URL}/#{original_filename} -O #{IMAGES_FOLDER}/#{new_filename}")

        basename.next!
      end
    end

    desc '-d --display', 'Display the secret message !'
    map %w[-d --display] => :display
    def display
      Dir["#{IMAGES_FOLDER}/*.png"].each do |image|
        magick_image = Magick::Image.read(image).first
        image_name = image.split('/')[-1]
        image_index = image_name.split('.').first.to_i

        system('clear') if image_index.zero?

        bits = Array.new(8) do |index|
          if image_index > 2684
            Steps.blue_cars(magick_image, index)
          elsif image_index > 1356
            Steps.dancing_cars(magick_image, index)
          else
            Steps.colored_cars(magick_image, index)
          end
        end

        puts '' if image_index == 2685
        print [bits.join].pack('B*')
      end
    end
  end
end
