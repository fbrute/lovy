#########################
#########################
require 'gate'

describe Gate do

    before(:example) do
    end
    
    context "Given a specified gate, thru which retros get" do

       it "should have a name" do

            expect { @gate = Gate.new nil, 25, -15, 10, -20 }. to raise_error("the gate should have a name!!!")
            expect { @gate = Gate.new :ool, 25, -15, 10, -20 }. to raise_error("the names are restricted to :neap, :swap or :nwap!!!")
            expect { @gate = Gate.new "neap", 25, -15, 10, -20 }. to raise_error("the names are restricted to :neap, :swap or :nwap!!!")

            @gate = Gate.new :neap, 25, -15, 10, -20  
            expect(@gate.name).to eq :neap

            @gate = Gate.new :swap, 25, -15, 10, -20  
            expect(@gate.name).to eq :swap

            @gate = Gate.new :nwap, 25, -15, 10, -20  
            expect(@gate.name).to eq :nwap

        end


        it "should have proper limits for north" do
            expect { @gate = Gate.new :neap, 125, 90,  50, -61 }. to raise_error("bad north limit for the gate!!!")
            expect { @gate = Gate.new :neap, -100, 90, 50, -61 }. to raise_error("bad north limit for the gate!!!")

            @gate = Gate.new :neap, 25, -15, 10, -20

            expect(@gate.north).to eq 25
            expect(@gate.east).to eq -15 
            expect(@gate.south).to eq 10 
            expect(@gate.west).to eq -20 
        end

        it "should have proper limits for east" do
            expect { @gate = Gate.new :neap,  50, 200,  50, -61 }.  to raise_error("bad east limit for the gate!!!")
            expect { @gate = Gate.new :neap,  50, 200,  50, -61 }.  to raise_error("bad east limit for the gate!!!")
        end

        it "should have proper limits for south" do
            expect { @gate = Gate.new :neap,  50, -20, -95, -61 }. to raise_error("bad south limit for the gate!!!")
            expect { @gate = Gate.new :neap,  50, -50, 92, -61 }.   to raise_error("bad south limit for the gate!!!")
        end

        it "should have proper limits for west" do
            expect { @gate = Gate.new :neap,  50, -20, -50, -192 }. to raise_error("bad west limit for the gate!!!")
            expect { @gate = Gate.new :neap,  50, -50, 50, 200 }.   to raise_error("bad west limit for the gate!!!")
        end

       it "should have meaningful limits in terms for a gate" do
            expect { @gate = Gate.new :neap,  -50, -20, 50, -178 }. to raise_error("north limit should be higher than south's!!!")
            expect { @gate = Gate.new :neap,  50, -20, 40, -15 }.   to raise_error("east limit should be right of west's")
        end

        it "should have a minimum width and height" do
            expect { @gate = Gate.new :neap,  50.5, -20, 50, -20.8 }. to raise_error("width should be 1 degree minimum!!!")
            expect { @gate = Gate.new :neap,  50.5, -20, 50, -21 }. to raise_error("height should be 1 degree minimum!!!")
        end

 
    end 
    
end
