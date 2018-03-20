class TrajectoryFolder 
    attr_reader :folder, :folders

    def initialize folder
        @folder = folder
        @folders = Dir.glob("#{@folder}/*").select { |file| File.directory? file } . reject { |file| file.match 'd3' }
    end
end
