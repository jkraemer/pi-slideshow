module PiSlides

  ImageDir = Struct.new(:path) do
    def file_list(pattern = '**/*.jpg')
      @file_list ||= Dir[File.join(path, pattern)].shuffle
    end

    def reset
      @file_list = nil
    end

    def random_file
      file_list.pop
    end

    def size
      file_list.size
    end
  end

end
