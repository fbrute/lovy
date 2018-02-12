require 'trajectory_classifier'

describe TrajectoryClassifier do

    before(:example) do
        #@nwap_gate = {north: 25, south: 10, east: -15, west: -20} 
        #@swap_gate = {north: 10, south: 0, east: -15, west: -20} 

        @nwap_gate = double('gate')
        allow(@nwap_gate).to receive(:name) {:nwap}
        allow(@nwap_gate).to receive(:north) {25}
        allow(@nwap_gate).to receive(:south) {10}
        allow(@nwap_gate).to receive(:west) {-20}
        allow(@nwap_gate).to receive(:east) {-15}
        
        @swap_gate = double('gate')
        allow(@swap_gate).to receive(:name) {:swap}
        allow(@swap_gate).to receive(:north) {10}
        allow(@swap_gate).to receive(:south) {0}
        allow(@swap_gate).to receive(:west) {-20}
        allow(@swap_gate).to receive(:east) {-15}

        @neap_gate = double('gate')
        allow(@neap_gate).to receive(:name) {:neap}
        allow(@neap_gate).to receive(:north) {40}
        allow(@neap_gate).to receive(:south) {35}
        allow(@neap_gate).to receive(:west) {-60}
        allow(@neap_gate).to receive(:east) {-20}


        @gates = Array.new
        @gates << @nwap_gate
        @gates << @swap_gate
        @gates << @neap_gate
 
        @nwap_traj = Array.new
        @nwap_traj << "24 -13"
        @nwap_traj << "23 -14"
        @nwap_traj << "17 -15"
        @nwap_traj << "16 -15.5"
        @nwap_traj << "13 -16.5"

        @swap_traj = Array.new
        @swap_traj << "12 -13"
        @swap_traj << "8  -14"
        @swap_traj << "7 -15"
        @swap_traj << "6 -15.5"
        @swap_traj << "5 -16.5"

        @neap_traj = Array.new
        @neap_traj << "37 -38"
        @neap_traj << "42 -38"

        @ind_traj = Array.new
        @ind_traj << "33 -40"
        @ind_traj << "36 -65"


        @bad_traj = Array.new
        @bad_traj << ["12" , "-25"]
        @bad_traj << ["6" ,  "-2"]
        @bad_traj << ["5" ,  "-21"]


    end

    context "Given a trajectory and a Gate" do

       it "should have a trajectory as an array contaiing lat and lon in subarrays", :badtraj do 
        expect { tc = TrajectoryClassifier.new(@gates, @bad_traj) }. to raise_error  "data should be an array of strings, with each string containing lat and lon, space separated" 
        end

        it "should know if it passed thru nwap path", nwap: true do
            tc = TrajectoryClassifier.new(@gates, @nwap_traj)
            expect(tc.path).to eq :nwap
        end

        it "should know if it passed thru swap path" do
            tc = TrajectoryClassifier.new(@gates, @swap_traj)
            expect(tc.path).to eq :swap
        end

        it "should know if it passed thru neap path" do
            tc = TrajectoryClassifier.new(@gates, @neap_traj)
            expect(tc.path).to eq :neap
        end


        it "should know if it passed thru ind path" do
            tc = TrajectoryClassifier.new(@gates, @ind_traj)
            expect(tc.path).to eq :ind
        end


    end
    
end
