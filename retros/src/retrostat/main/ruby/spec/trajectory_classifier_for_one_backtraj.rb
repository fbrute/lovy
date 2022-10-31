require 'trajectory_stat_for_one_backtraj'

describe TrajectoryStatForOneBacktraj do

    before(:example) do
        @station = 'puer'
        @level = 1500
        @date = "2007-03-28"
    end

    context do
        it "should find the gate for a specific backtraj", :first do
            ts_one = TrajectoryStatForOneBacktraj.new @station, @level, @date
            expect(ts_one.date.year).to eq 2007
            expect(ts_one.file).to eq '/media/kwabena/MODIS/hysplit_data/tests/retros_mars_2018/puer_1500/2007/tdump070328.txt'
            gate = ts_one.count_one_backtraj
            expect(gate.to_s).to eq 'neap'
        end
    end
end
