require 'trajectory'


describe Trajectory do
    before do
        traj = Array.new
        nwap = {north: 25, south: 10, east: -20, west: -15} 
        nwap = {north: 10, south: 0, east: -20, west: -15} 
    end

    context "Given a trajectory and a Gate" do
        it "should know if the gate is passed thru" do
            traj = Trajectory.new
        end
    end
    
end
