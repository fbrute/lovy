require 'trajectory_folder'

describe TrajectoryFolder do 

    before(:all) do
        @folder_test = File.join(File.dirname(__FILE__), '..','test', 'retros')
    end

    before(:example) do
        @traj_folder = TrajectoryFolder.new @folder_test
    end

    context "Given a folder containing subfolders with retros (tdump files)" do

        it "should return all the subfolders" do
            expect(@traj_folder.folders.length).to eq 3 
        end

        it "should find the corresponding d3dates file" do
            expect(@traj_folder.folders[1].d3folder).to match /karu/
        end
    end
end
