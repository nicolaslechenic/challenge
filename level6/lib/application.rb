module Drivy
  class Application
    def self.json_datas
      @datas ||= JSON.parse(datas)
    end

    def self.datas
      File.read(DATAS_PATH)
    end
  end
end
