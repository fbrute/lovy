require_relative('getArl')

def getArls
    date_current = Date.new(2007,01,02)
    date_debut_janvier = Date.new(2007,01,31)
    date_fin_fevrier = Date.new(2007,02,28)

    while  date_current <= date_fin_fevrier  do  
        arl = GetArlDay.new date_current    
        arl.getArl
        date_current = date_current + 1  
        sleep(300)
    end
end

getArls
