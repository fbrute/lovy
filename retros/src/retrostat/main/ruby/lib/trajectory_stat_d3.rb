require_relative 'trajectory_stat'

class TrajectoryStatD3 < TrajectoryStat
    def initialize folder, dates 
        super(folder)
        @files.reject! {|file| not dates.include? date(file) }
    end
end