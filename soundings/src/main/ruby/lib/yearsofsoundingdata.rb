require_relative 'monthofsoundingdata'

class YearsOfSoundingData
  attr_accessor :station_number
  attr_accessor :years
  attr_accessor :months

  def initialize(station_number, start_year, end_year)
    @station_number = station_number
    @years = Range.new(start_year, end_year)
    @months = Range.new(1,12)
  end

  def main()
    @years.each do |year|
      puts "Getting sounding data for year #{year}"
      @months.each do | month |
        puts "Getting sounding data for month #{month}"
        mosd = MonthOfSoundingData.new(year, month, @station_number)
        mosd.getDataFromRequest()
        mosd.writeDataToFile()
      end
    end
  end
end

def main_years
  yosd = YearsOfSoundingData.new(78526, 1973, 2020)
  yosd.main()
end

main_years()