require 'monthofsoundingdata'
require 'nokogiri'

describe MonthOfSoundingData do
  describe "#numberOfDays" do
    it "returns the number of days for a month if the file is not already present" do
      mosd = MonthOfSoundingData.new(2020,2, 78526)
      unless mosd.testDataPresence()
        expect(mosd.numberOfDays).to eql(29)
      end
    end
    it "returns the number of days for a month" do
      mosd = MonthOfSoundingData.new(2020,2, 78526)
      unless mosd.testDataPresence()
        expect(mosd.numberOfDays).to eql(29)
      end
    end
  end
  describe "#getRequest" do
    it "returns the correct request string" do
      mosd = MonthOfSoundingData.new(2019,2, 78954)
      unless mosd.testDataPresence()
        request = mosd.getRequest()
        expect(request.to_s).to eq("http://weather.uwyo.edu/cgi-bin/sounding?region=naconf&TYPE=TEXT%3ALIST&YEAR=2019&MONTH=02&FROM=0112&TO=2812&STNM=78954")
      end
    end
  end
  describe "#getDataFromRequest" do
    it "returns the correct amount of data" do
      mosd = MonthOfSoundingData.new(2019,2, 78954)
      unless mosd.testDataPresence()
        mosd.getRequest()
        data = mosd.getDataFromRequest()
        expect(data.length).to be > 0
      end
    end
  end
  describe "writeDataToFile" do
    it "saves the data with an html structure" do
      mosd = MonthOfSoundingData.new(2019,2, 78954)
      unless mosd.testDataPresence()
        mosd.getRequest()
        mosd.getDataFromRequest()
        mosd.writeDataToFile()
        fname = mosd.getDataFileName()
        data = File.open(fname).read()
        filetype = `file #{fname}`
        expect(filetype.include?('HTML'))
      end
    end
  end
end