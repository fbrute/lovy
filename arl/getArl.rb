require('watir')
require('watir-webdriver')
require('watir-jquery')
require('clipboard')

class GetArlDay
    
    #attr_accessor :date
    #attr_accessor :time
    attr_accessor :week
    attr_accessor :day
    attr_accessor :date
    attr_accessor :year
    attr_accessor :month
    attr_accessor :nmonth

    def initialize (date)
        @date = date
        #@time = time 
        @year = @date.year 
        @month = @date.month
        @nmonth = @date.month
        @week = "" 
#        #@longitude = 61
        

        #self.getArl
    end 
    
    def getWeekFromDate
        #@day = @date.day.rjust(2,'0') 
        @month = Date::MONTHNAMES[@date.month][0,3].downcase
        @year = @date.to_s[2,2]
        numday = @date.day

        if numday >=  1 && numday <=  7 then @week = "gdas1.#{@month}#{@year}.w1" end
        if numday >=  8 && numday <= 14 then @week = "gdas1.#{@month}#{@year}.w2" end
        if numday >= 15 && numday <= 21 then @week = "gdas1.#{@month}#{@year}.w3" end
        if numday >= 22 && numday <= 28 then @week = "gdas1.#{@month}#{@year}.w4" end
        if numday >= 29 && numday <= 31 then @week = "gdas1.#{@month}#{@year}.w5" end 
        return @week
    end

    def getArl
        self.getWeekFromDate
#profile = Selenium::WebDriver::Firefox::Profile.new
  


        client = Selenium::WebDriver::Remote::Http::Default.new
        client.timeout = 120000 # milliseconds – default is 60

        #b = Watir::Browser.new :firefox, :http_client => client


        download_directory = "#{Dir.pwd}/arl_downloads"
        #download_directory.gsub!("/", "\\") if Selenium::WebDriver::Platform.windows?
         
        profile = Selenium::WebDriver::Firefox::Profile.new
        #profile.native_events = false

        profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
        profile['browser.privatebrowsing.autostart'] = true

        #browser = Watir::Browser.new WEB_DRIVER, :profile => profile
        #profile['browser.download.folderList'] = 2 # custom location

        #profile['browser.download.dir'] = download_directory
        #profile['browser.helperApps.neverAsk.saveToDisk'] = "text/txt,application/pdf/text/htm,text/html"
 
         
        browser = Watir::Browser.new :firefox#, :profile => profile#, :http_client => client 
        #browser.execute_script "window.alert = function() { return true; }"
        #browser = Watir::Browser.new :firefox
        #browser = Watir::Browser.new
        browser.goto("http://ready.arl.noaa.gov/HYSPLIT.php")
        #Watir::Wait.until { browser.text.include ? "Run HYSPLIT Trajectory Model" }

        #Watir::Wait.until { browser.windows.length == 2 }

        #Watir::Wait.until { browser.window(:title =>  "Air Resources Laboratory - HYSPLIT Registration Instructions") }


        browser.link(:text =>"Run HYSPLIT Trajectory Model").click


        if (browser.window(:title, "Air Resources Laboratory - HYSPLIT Registration Instructions").exists?)  
            browser.window(:title, "Air Resources Laboratory - HYSPLIT Registration Instructions").close
        end


        browser.link(:text =>"Compute archive trajectories").click

        browser.button(:text => "Next>>").click

        #set latitude and longitude
        browser.text_field(:tag_name => "input" , :name =>"Lat").set(16)
        Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"Lat" == "16") }

        browser.text_field(:tag_name => "input" , :name =>"Lon").set(61)
        Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"Lon" == "61") }
        browser.button(:text => "Next>>").click

        # Choose archive file
        #browser.select_list(:name, "mfile").options.length => 624
        browser.select_list(:name => 'mfile').select @week 
        Watir::Wait.until { browser.select_list(:name => "mfile").value == @week }

        browser.button(:text => "Next>>").click
        Watir::Wait.until { browser.text.include? "Model Run Details" }

        #Set trajectory to backward
        browser.radio(:value => "Backward", :name =>"direction").set
        Watir::Wait.until { browser.radio(:value => "Backward", :name =>"direction") }
        
        day = @date.day.to_s.rjust(2,'0')
        browser.select_list(:name => "Start day").select day 
        Watir::Wait.until {browser.select_list(:name =>"Start day").value == day}

        browser.select_list(:name => "Start hour").select "12"
        Watir::Wait.until {browser.select_list(:name =>"Start hour").value == "12"}


        browser.text_field(:tag_name => "input" , :name =>"duration").set(200)
        Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"duration").value == "200" }

        browser.text_field(:tag_name => "input" , :name =>"Source hgt1").set(2200)
        Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"Source hgt1").value == "2200" }

        browser.text_field(:tag_name => "input" , :name =>"Source hgt2").set(2500)
        Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"Source hgt2").value == "2500" }

        browser.text_field(:tag_name => "input" , :name =>"Source hgt3").set(2800)
        Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"Source hgt3").value == "2800" }

        #browser.radio(:value => "6", :name => "Label Interval").clear
        #browser.radio(:value => "6", :name => "Label Interval").value  = false
        #Watir::Wait.until { browser.radio(:name =>"Label Interval").value == false }

        #browser.radio(:value => "24", :name => "Label Interval").set
        browser.radio(:value => "24", :name => "Label Interval").set
        Watir::Wait.until { browser.radio(:value => "24", :name =>"Label Interval").set? == true}

        browser.button(:text => "Request trajectory").click


        Watir::Wait.until { browser.text.include? "complete" }

        #6 gets the pdf
        #browser.links[6].click

        #9 gets the list of numbers
        browser.links[9].click
        Watir::Wait.until { browser.windows.length == 2 }

        browser.window(:index => 1).use
        Watir::Wait.until { browser.text.include? "PRESSURE" }

        browser.send_keys(:command, "a")
        browser.send_keys(:command, "c")
        
        year = @date.year
        @year = @date.to_s[2,2]
        name_trajplot_txt = "#{download_directory}/#{year}_#{@nmonth.to_s.rjust(2,'0')}_#{day}.txt"

        #File.open(Name_trajplot_txt, "w") do |file|
        #    file.write(Clipboard.paste)
        #end

        File.write(name_trajplot_txt, Clipboard.paste)

         browser.windows.each { |window| window.close}

     end
end
