require 'uri'
require 'net/http'
require 'date'

class MonthOfSoundingData
  attr_accessor :station_number
  attr_accessor :year
  attr_accessor :month
  attr_reader   :numberOfDays
  attr_reader   :request

  def initialize(year,month,station_number)
    @station_number  = station_number 
    @year  = year
    @month = month
    @month_str = "%02d" % month
    return nil if testDataPresence()
    @numberOfDays = getNumberOfDays() 
    @day_str = "%02d" % @numberOfDays 
    getRequest()
    getDataFromRequest()
    writeDataToFile()
  end

  def getNumberOfDays
    puts "year=#{@year}"
    puts "month=#{@month}"
    return Date.new(@year,@month,-1).day
  end

  def getRequest()
    @uri = URI("http://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=TEXT%3ALIST&YEAR=#{@year}&MONTH=#{@month_str}&FROM=0112&TO=#{@day_str}12&STNM=#{@station_number}")
  end

  def getDataFromRequest()
    res = Net::HTTP.get_response(@uri)
    @result = res.body if res.is_a?(Net::HTTPSuccess)
  end

  def getDataFileName()
    fname = "#{@station_number}_#{@year}_#{@month_str}.html"
  end

  def testDataPresence
    File.exists? getDataFileName() 
  end

  def writeDataToFile
    fname = getDataFileName()
    File.open(fname, "w") { |f| f.write @result } if @result.size > 0 
  end
end

def main_month
  mosd = MonthOfSoundingData.new(2020,2,78526)
  mosd.getRequest()
  data_html = mosd.getDataFromRequest()
  mosd.writeDataToFile()
end



