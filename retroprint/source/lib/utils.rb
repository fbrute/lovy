# France-Nor Brute
# Janvier 2018
#

module Utils
    def month date
        date.match(/(\d{2})(\d{2})(\d{2})/)[2]
    end
end
