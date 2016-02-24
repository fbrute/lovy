require('watir')
require('watir-webdriver')
require('watir-jquery')
#require('watir-classic')


year = "2012"
week =  01
month = "01"
day = "01" 

Download_directory = "#{Dir.pwd}/arl_downloads"
#puts Download_directory
#download_directory.gsub!("/", "\\") if Selenium::WebDriver::Platform.windows?
prefs = {
  :download => {
  :prompt_for_download => false,
  :default_directory => Download_directory 
  }
} 
 
#browser = Watir::Browser.new :Chrome
browser = Watir::Browser.new :chrome, :prefs => prefs
#browser = Watir::Browser.new :firefox
#browser = Watir::Browser.new
browser.goto("http://ready.arl.noaa.gov/HYSPLIT.php")
browser.link(:text =>"Run HYSPLIT Trajectory Model").click
browser.window(:title, "Air Resources Laboratory - HYSPLIT Registration Instructions").close
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
browser.select_list(:name => 'mfile').select 'gdas1.jan12.w1'
Watir::Wait.until { browser.select_list(:name => "mfile").value == "gdas1.jan12.w1" }

browser.button(:text => "Next>>").click
Watir::Wait.until { browser.text.include? "Model Run Details" }

#Set trajectory to backward
browser.radio(:value => "Backward", :name =>"direction").set
Watir::Wait.until { browser.radio(:value => "Backward", :name =>"direction") }

browser.select_list(:name => "Start day").select "01"
Watir::Wait.until {browser.select_list(:name =>"Start day").value == "01"}

browser.text_field(:tag_name => "input" , :name =>"duration").set(168)
Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"duration").value == "168" }

browser.text_field(:tag_name => "input" , :name =>"Source hgt1").set(1500)
Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"Source hgt1").value == "1500" }

browser.text_field(:tag_name => "input" , :name =>"Source hgt2").set(1800)
Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"Source hgt2").value == "1800" }

browser.text_field(:tag_name => "input" , :name =>"Source hgt3").set(2200)
Watir::Wait.until { browser.text_field(:tag_name => "input" , :name =>"Source hgt3").value == "2200" }

#browser.radio(:value => "6", :name => "Label Interval").clear
#browser.radio(:value => "6", :name => "Label Interval").value  = false
#Watir::Wait.until { browser.radio(:name =>"Label Interval").value == false }

#browser.radio(:value => "24", :name => "Label Interval").set
browser.radio(:value => "24", :name => "Label Interval").set
Watir::Wait.until { browser.radio(:value => "24", :name =>"Label Interval").set? == true}

browser.button(:text => "Request trajectory").click

# Wait until results are available
#Watir::Wait.until { browser.text.include? "Creating traj PDF file" }
#Watir::Wait.until { browser.text.include? "Contact Us" }
#Watir::Wait.until { browser.text.include? "Contact Us" }


#Get the pdf
#browser.links[7].click

#Get Trajectory points
#browser.windows[0].use
#Watir::Wait.until { browser.windows.length == 2 }
#return


#Watir::Wait.until { browser.windows.length == 2 }
#browser.windows[1].close

Watir::Wait.until { browser.text.include? "The model and graphics are now complete" }

browser.links[9].click
#browser.windows[0].links[6].click
#Watir::Wait.until { browser.windows.length == 2 }
#browser.windows[0].links[6].click
Watir::Wait.until { browser.windows.length == 2 }

browser.window(:index => 1).use
Watir::Wait.until { browser.text.include? "PRESSURE" }


browser.send_keys(:command, "s")

#browser.windows.use
#name_trajplot_txt = "#{year}#{month}#{day}.txt"
#browser.send_keys(:command, "s")
#browser.send_keys(name_trajplot_txt)
#browser.send_keys(:enter, 's')


#browser.link(:text =>"/.pdf$/").click
#Click n deal with the pdf file 
#browser.window(:title => /trajplot/).use
#month = "06" 
#month = sprintf ("%02d" , "#{month}")
#day = "01" 
#day = sprintf ("%02d" , "#{day}")
#name_trajplot_pdf = "#{year}#{month}#{day}.pdf"
#browser.send_keys(name_trajplot_pdf)
#browser.button(:type => 'submit').click
#browser.send_keys(:enter)
#browser.send_keys(:command, "s")

#Click n deal with the gif file 
#browser.link(:text =>"/.gif$/").click
#browser.window(:title => /trajresults/).use
#browser.send_keys(:command, "s")
#month = sprintf "%02d" , "#{month}"
#day = sprintf "%02d" , "#{day}"
#name_trajplot_gif = "#{year}#{month}#{day}.gif"
#browser.send_keys(name_trajplot_gif)
#browser.send_keys(:enter)



#browser.link(:text ,  /pdf$/).click
#browser.link(:text ,  /gif$/).click
#Download
#browser.select(:name => "Start year").select_value("07")
