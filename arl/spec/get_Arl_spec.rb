require 'spec_helper'
require 'date'

describe GetArlDay do
    context "when the robot is created" do
        #before(:example) do
        DateArl = Date.new(2012,6,1)

        arl = GetArlDay.new DateArl
        #end

        download_directory = "#{Dir.pwd}/arl_downloads/"

        it "expect date  is an attribue" do
            expect(arl).to respond_to(:date)
        end 


        #it "expect time as attribute" do
        #    expect(arl).to respond_to(:time)
        #end

        it "expect a function to compose week from date" do
            expect(arl).to respond_to(:getWeekFromDate)
            expect(arl.getWeekFromDate).to eq "gdas1.jun12.w1" 
        end
        
        # Launch the principal function 
        
        

        it "should exit a pressure file with a name after the date" do
            arl.getArl
            day = arl.date.day.to_s.rjust(2, '0') 
            year = arl.year
            nmonth = arl.nmonth.to_s.rjust(2,'0')
            name_trajplot_txt = "#{download_directory}/#{year}_#{nmonth}_#{day}.txt"
            expect(File.exists? name_trajplot_txt).to be true
        end
    end
end
