class TrajectoryClassifier

    def initialize(gates, traj)
        # We expect first gate to be nwap, second swap
        @gates = gates
        @traj = traj

        raise "data should be an array of strings, with each string containing lat and lon, space separated" if @traj.first.class != String
    end
    
    def pathsaved
        idx = classify 
        if idx == 0 then return :nwap
        elsif idx == 1 then return :swap
        elsif idx == 2 then return :ind
        else return :neap
        end
    end

    def path_v1 
        @gates.each do |gate|
            #@gates.each{|g| puts g.inspect}
            #p "@@@@@@@@@@@@@@@@@@@@@@@@@"
            #p @traj.inspect
            if (@traj.any? do |latlon| lat,lon  = latlon.split " " 
                                    lat.to_f > gate.south && 
                                    lat.to_f < gate.north && 
                                    lon.to_f > gate.west && 
                                    lon.to_f < gate.east 
                end) then return gate.name 
            end
        end # gates.each
        # index 2, greater than @gates.length 
        :ind        
    end

    def path_v2 gates 
        gates.each do |gate|
            #@gates.each{|g| puts g.inspect}
            #p "@@@@@@@@@@@@@@@@@@@@@@@@@"
            #p @traj.inspect
            if (@traj.any? do |latlon| lat,lon  = latlon.split " " 
                                    lat.to_f > gate.south && 
                                    lat.to_f < gate.north && 
                                    lon.to_f > gate.west && 
                                    lon.to_f < gate.east 
                end) then return gate.name 
            end
        end # gates.each
        # index 2, greater than @gates.length 
        :ind
    end

     def path gates 
        gates.each do |gate|
            #@gates.each{|g| puts g.inspect}
            #p "@@@@@@@@@@@@@@@@@@@@@@@@@"
            #p @traj.inspect
            if (@traj.any? do |latlon| lat,lon  = latlon.split " " 
                                    lat.to_f > gate.south && 
                                    lat.to_f < gate.north && 
                                    lon.to_f > gate.west && 
                                    lon.to_f < gate.east 
                end) then return gate.name 
            end
        end # gates.each
    end


end
