require 'trajectory_stat_d3_pm10s_dates'

describe TrajectoryStatD3Pm10sDates do
    
    before(:example) do
        folder = '/Volumes/Velo/trafin/fouyol/recherche/velo/data/bts/retros_mars_2018/karu_1500'
        d3dates_filepath = '~/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/data/d3/karu_d3_sup35.txt'
        pm10s =            '~/Documents/trafin/fouyol/recherche/lovy/retros/src/retrostat/data/pm10karu.csv'
        #pm10s = '/Volumes/MODIS/trafin/it/sauvegardes/trafin/fouyol/recherche/lovy/data/pm10/pm10karu.csv'
        d3dates = IO.readlines(File.expand_path d3dates_filepath).each {|date| date.chomp!}.uniq

        @tstat = TrajectoryStatD3Pm10sDates.new(folder,d3dates,pm10s)
    end

    context "Given a folder we should provide a count for each gate provided" do
        
        it "should have an existing folder with tdump files" do
            expect(@tstat).to respond_to :folder
            #expect(@tstat.files.length).to eq 1
        end

    
       it "should calculate the proper value for each season", :nwap do
            @tstat.count_by_seasons_pm10s_dates
            #expect(@tstat.mjja[:nwap]).to eq 1
       end

    end
end
