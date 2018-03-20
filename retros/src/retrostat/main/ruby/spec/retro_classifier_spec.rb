require 'retroclassifier'
# France-Nor Brute, January 24, 2018
# expect to bdd classifier_main.rb, that classify retros files to proper seasons according to dates incorporated in name of files
# and D3 or ND3 state 

#folder_test = "/Users/france-norbrute/Documents/trafin/fouyol/recherche/Hysplit4/karu_retros_1500_flatten_test"
folder_test = __dir__ + "/../test/retros/multi_level_retros_folder"
dates = %w(2006-12-31 2007-02-20 2007-02-22 2009-04-30 2010-04-30 2010-07-08 2016-09-10 2016-09-09)


describe RetroClassifier do

    before(:all) do
        Dir.chdir(folder_test)
        %q(D3 ND3 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 ).split.each do |dir|
            if Dir.exists? File.join(Dir.pwd, dir)
                FileUtils.rm_r File.join(Dir.pwd, dir) 
            end
        end

        %q(2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 ).split.each do |dir|
                FileUtils.mkdir dir 
        end
        
        test_files = []        

        #D3 Files
        
        test_files << "touch 2007/gis_shape061231.shp"
        test_files << "touch 2007/gis_shape070222.shp"

        test_files << "touch 2009/gis_shape090430.prj"
        test_files << "touch 2009/gis_shape090430.shx"
        test_files << "touch 2009/gis_shape090430.shp"

        test_files << "touch 2010/gis_shape100708.shp"
        test_files << "touch 2010/gis_shape100708.dbf"
        test_files << "touch 2010/gis_shape100708.prj"
        test_files << "touch 2010/gis_shape100708.shx"

        test_files << "touch 2016/gis_shape160909.shx"

        #ND3 Files

        test_files << "touch 2007/gis_shape070221.shp"
        test_files << "touch 2009/gis_shape070228.shp"
        test_files << "touch 2007/gis_shape070223.shx"
        test_files << "touch 2007/gis_shape070223.prj"
        test_files << "touch 2008/gis_shape070223.dbf"

        test_files << "touch 2013/gis_shape130524.shx"
        test_files << "touch 2013/gis_shape130524.shp"
        test_files << "touch 2007/gis_shape070724.shp"

        test_files << "touch 2007/gis_shape140924.shx"
        test_files << "touch 2007/gis_shape140924.prj"
        test_files << "touch 2007/gis_shape140924.shp"
        test_files << "touch 2007/gis_shape140924.dbf"

        test_files .each { |cmd| system cmd }

    end

    context "Given the RetroClassifier has finished" do


        it "there should be 4 season subdirectories in its source folder" do
            rc = RetroClassifier.new(folder_test)

            #expect(Dir.glob("#{rc.folder}/**/*").include? File.join(Dir.pwd,'D3','NDJF')).to be true
            expect(File.exists? File.join(Dir.pwd,'D3','NDJF')).to be true
            expect(File.exists? File.join(Dir.pwd,'D3','NSPP')).to be false 
            expect(File.exists? File.join(Dir.pwd,'D3','MJJA')).to be true
            expect(File.exists? File.join(Dir.pwd,'D3','MA')).to be true
            expect(File.exists? File.join(Dir.pwd,'D3','SO')).to be true

        end
        
        it "there should exist the correct number of files per subdirectory" do
            rc = RetroClassifier.new(folder_test)
            rc.classify(dates)
            
            expect(Dir.glob("#{rc.folder}/D3/NDJF/*").length).to eq 2 
            expect(Dir.glob("#{rc.folder}/D3/MA/*").length).to eq 3 
            expect(Dir.glob("#{rc.folder}/D3/MJJA/*").length).to eq 4 
            expect(Dir.glob("#{rc.folder}/D3/SO/*").length).to eq  1 

            expect(Dir.glob("#{rc.folder}/ND3/NDJF/*").length).to eq 5 
            expect(Dir.glob("#{rc.folder}/ND3/MA/*").length).to eq 0
            expect(Dir.glob("#{rc.folder}/ND3/MJJA/*").length).to eq 3
            expect(Dir.glob("#{rc.folder}/ND3/SO/*").length).to eq   4
        end 
    end
end
