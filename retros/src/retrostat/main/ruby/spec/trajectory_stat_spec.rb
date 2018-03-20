require 'trajectory_stat'

describe TrajectoryStat do
    
    before(:example) do
        folder = '~/lovy/retroprint/source/test'
        @tstat = TrajectoryStat.new folder
    end

    context "Given a folder we should provide a count for each gate provided" do
        
        it "should have an existing folder with tdump files" do
            expect(@tstat).to respond_to :folder
            expect(@tstat.files.length).to eq 1
        end

    
       it "should calculate the proper value for each season", :nwap do
            @tstat.count
            expect(@tstat.mjja[:nwap]).to eq 1
       end

    end
end
