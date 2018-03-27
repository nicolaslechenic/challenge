module Drivy
  class Application
    def self.json_data
      @data ||= JSON.parse(data)
    end

    def self.data
      File.read(DATA_PATH)
    end
  end
end
