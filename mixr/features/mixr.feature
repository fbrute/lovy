Feature: Calulate mixed ratio r 

   
    Scenario Outline: Test different values from wikipedia 

        Given the pressure in hPa is  <p>
        And the temperature in °C is <t>
        And the relative humidity in % is <hr>
        When MixR Calculator is run
        Then mixr is expected to be <mixr> g/kg
        
        Examples: 10 June 2012
            | p      | t    | hr   | mixr  |
            | 1014  | 27.8 | 93.0 |  18.94 |
            | 1000  | 19.8 | 14.8 |  18.17 |
            | 946   | 15.6 | 14.7 |  15.23 |

        
        

