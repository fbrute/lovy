require_relative 'trajectory_stat'
require_relative 'getPm10FromDate'

class TrajectoryStatD3Pm10sDates < TrajectoryStat
    include GetPm10

    def initialize folder, dates, pm10sFile 
        super(folder)
        puts "dates.length = #{dates.length}"
        @files.reject! {|file| not dates.include? date(file) }
        @pm10s = pm10sFile

        @seasons = Array.new
        
        #@ndjf = {neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :ndjf , months: [11,12,1,2] } 
        #@ma   = {neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :ma   , months: [3,4] } 
        #@mjja = {neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :mjja , months: [5,6,7,8] } 
        #@so   = {neap: 0, nwap: 0, swap: 0, ind: 0, sa: 0, north: 0, name:  :so   , months: [9,10] } 

        @ndjf = {   neap:  {total: 0, dates: [], pm10s: []},
                    nwap:  {total: 0, dates: [], pm10s: []},
                    swap:  {total: 0, dates: [], pm10s: []},
                    ind:   {total: 0, dates: [], pm10s: []}, 
                    sa:    {total: 0, dates: [], pm10s: []}, 
                    north: {total: 0, dates: [], pm10s: []}, 
                    name:  :ndjf ,
                    months: [11,12,1,2] } 

        @ma = {     neap:  {total: 0, dates: [], pm10s: []},
                    nwap:  {total: 0, dates: [], pm10s: []},
                    swap:  {total: 0, dates: [], pm10s: []},
                    ind:   {total: 0, dates: [], pm10s: []}, 
                    sa:    {total: 0, dates: [], pm10s: []}, 
                    north: {total: 0, dates: [], pm10s: []}, 
                    name:  :ma ,
                    months: [3,4] } 
        
        @mjja = {   neap:  {total: 0, dates: [], pm10s: []},
                    nwap:  {total: 0, dates: [], pm10s: []},
                    swap:  {total: 0, dates: [], pm10s: []},
                    ind:   {total: 0, dates: [], pm10s: []}, 
                    sa:    {total: 0, dates: [], pm10s: []}, 
                    north: {total: 0, dates: [], pm10s: []}, 
                    name:  :mjja ,
                    months: [5,6,7,8] } 

        @so = {     neap:  {total: 0, dates: [], pm10s: []},
                    nwap:  {total: 0, dates: [], pm10s: []},
                    swap:  {total: 0, dates: [], pm10s: []},
                    ind:   {total: 0, dates: [], pm10s: []}, 
                    sa:    {total: 0, dates: [], pm10s: []}, 
                    north: {total: 0, dates: [], pm10s: []}, 
                    name:  :so ,
                    months: [9,10] } 

        [@ndjf, @ma, @mjja, @so].each {|season| @seasons << season }
    end

    def count_retros files, gates, pm10s
        #puts "length of files to be treated = #{files.length}"
        # to keep track of treated dates
        remaining_files = Array.new
        puts "nfiles = #{files.length}"
        files.each do |file|
            trajectory = traj(file)
            trajclass = TrajectoryClassifier.new gates, trajectory
            month = month file
            date = date file
            pm10 = pm10s[GetPm10.toDate date] 
            
            puts "date = #{date}"
            puts "pm10 = #{pm10}"

            @seasons.each do |season|
                if season[:months].include? month
                    path =  trajclass.path gates 
                    if gates.any? {|gate| gate.name == path} then 
                        season[path][:total] +=1
                        season[path][:dates] << date
                        season[path][:pm10s] << pm10 
                        next
                    else
                        # keep track of treated dates
                        remaining_files << file 
                    end
                end
            end
        end
        #puts "length of remaining_files = #{remaining_files.length}"
        remaining_files
        
    end

    def count_by_seasons_pm10s_dates
        # Version of counting with pm10s and dates
        # get pm10s values as a hash with date as key
        pm10sValues = GetPm10.getPm10s(@pm10s)
        # First counting nwap and swap retros 
        remaining_files = count_retros @files, [@nwap, @swap], pm10sValues
        # Then count neap and leave the others to indetermined
        remaining_files =  count_retros remaining_files, [@neap]    , pm10sValues
        remaining_files =  count_retros remaining_files, [@sa]      , pm10sValues
        remaining_files =  count_retros remaining_files, [@north]   , pm10sValues
        remaining_files =  count_retros remaining_files, [@ind]     , pm10sValues
    end
end
