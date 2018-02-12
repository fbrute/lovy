require 'trajectory_stat_d3'

describe TrajectoryStatD3 do
    
    before(:example) do
        @folder = '~/lovy/retroprint/source/test'
        @d3dates = ["2012-06-03"] 
        @nd3dates = ["2012-06-02"] 
    end

    context do
        it "should take into account only the d3 days" do
            tsd3 = TrajectoryStatD3.new @folder, @d3dates
            tsd3.count
            expect(tsd3.mjja[:nwap]).to eq 1
        end

        it "should discard nd3 days" do
            tsd3 = TrajectoryStatD3.new @folder, @nd3dates
            tsd3.count
            expect(tsd3.mjja[:nwap]).to eq 0
        end

    end
end
