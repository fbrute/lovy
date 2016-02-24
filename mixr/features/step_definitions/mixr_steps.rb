#Given(/^(\w+)\s* is (\d+)$/) do |arg, value|
#    instance_variable_set(('@'+ arg).to_sym , value.to_f)
#end

#Given(/^P0 is (\d+)$/) do |value|
#    @P0 = value.to_f
#end
#
#Given(/^T0 is (\d+)$/) do |value|
#    @T0 = value.to_f
#end
#
#Given(/^T  is (\d+)$/) do |value|
#    @T = value.to_f
#end
#
#Given(/^P  is (\d+)$/) do |value|
#    @P = value.to_f
#end
Given(/^the pressure in hPa is  (\d+)$/) do |arg1|
    @p = arg1.to_f * 100
end

Given(/^the temperature in °C is (\d+)\.(\d+)$/) do |arg1, arg2|
    @t = (arg1 + '.' + arg2).to_f + 273
end

Given(/^the relative humidity in % is (\d+)\.(\d+)$/) do |arg1, arg2|
    @hr = (arg1 + '.' + arg2).to_f
end



When(/^MixR Calculator is run$/) do
    @mixr = `ruby mixr.rb` 
    raise "no mixr.rb found" unless $?.success?
end

Then(/^mixr is expected to be (\d+)\.(\d+) g\/kg$/) do |arg1, arg2|
    #M = 0.018
    #Lv = 2.26e6
    #R = 8.31447
    #@Psat =  Math.exp(M*Lv/R*(1/@T0 - 1/@T)*@PO) 
    #@Psat =  Math.exp((1/@T0 - 1/@T) * M * Lv / R)  * @P0
    
    @psat =  Math.exp((13.7 - 5120/@t)) * 101325
    puts "psat = #{@psat}"
    @rsat = 0.622 * @psat / (@p - @psat) * 1000
    puts "rsat = #{@rsat}"
    @pvap = @hr / 100 * @psat
    @mixrestimated = 0.622 * @pvap / (@p - @pvap) * 1000
    @mixr = (arg1 + '.' + arg2).to_f

    expect(@mixrestimated).to eq @mixr

end

