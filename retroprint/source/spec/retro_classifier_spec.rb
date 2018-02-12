require 'retroclassifier'
# France-Nor Brute, January 24, 2018
# expect to class retros files to proper seasons according to dates incorporated in name of files
# and D3 or ND3 state 

folder_test = "/Users/france-norbrute/Documents/trafin/fouyol/recherche/Hysplit4/karu_retros_1500_flatten_test"
dates = %w(2012-05-23 2016-12-14)


describe RetroClassifier do

    before do
        Dir.chdir(folder_test)
        %q(D3 ND3).split.each do |dir|
            if Dir.exists? File.join(Dir.pwd, dir)
                FileUtils.rm_r File.join(Dir.pwd, dir) 
            end
        end
    end

    context "Given the RetroClassifier has finished" do


        it "there should be 4 season subdirectories in its source folder" do
            rc = RetroClassifier.new(folder_test)

            expect(Dir.glob("#{rc.folder}/**/*").include? File.join(Dir.pwd,'D3','NDJF')).to be true

        end
        
        it "there should exist one file per subdirectory" do
            rc = RetroClassifier.new(folder_test)
            rc.classify(dates)
            expect(Dir.glob("#{rc.folder}/D3/NDJF/*").length).to eq 1
        end 
    end
end
