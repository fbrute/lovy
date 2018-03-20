#!/usr/bin/env python
import matplotlib.pyplot as plt
import os.path

import tephi

# all cases

#karu_all_d3 = os.path.join(tephi.DATA_DIR, '..','dews.txt')

print(tephi.DATA_DIR)
print(os.getcwd())

#karu_d3_filename = os.path.join(tephi.DATA_DIR, 'karu_d3_temps.txt')
karu_d3_filename = os.path.join('../data', 'karu_d3_all_cases.csv')
karu_nd3_filename = os.path.join('../data', 'karu_nd3_all_cases.csv')
dunion_filename = os.path.join('../data', 'sal_dunion.csv')

#barbs_filename = os.path.join(os.getcwd(), 'data','barbs.txt')

print(os.getcwd())
print(karu_d3_filename)
print(os.path.exists(karu_d3_filename))

#pr_d3_all_cases_temps_csv_filename = os.path.join(os.getcwd(), '..', 'data','pr_d3_all_cases_pressures_temps.csv')
#sal_d3_all_cases_temps_csv_filename = os.path.join(os.getcwd(), '..', 'data','sal_pressure_temps.csv')

#column_titles = [('pressure', 'temp'), ('pressure', 'temp'),('pressure','temp')]
columns = ('pressure', 'temp','mixr','rh')

#karu_d3_all_cases_temps_data, pr_d3_all_cases_pressures_temps_data, sal_d3_all_cases_temps_data = tephi.loadtxt(karu_d3_all_cases_temps_csv_filename, pr_d3_all_cases_temps_csv_filename
#karu_d3_data = tephi.loadtxt(karu_d3_filename, column_titles = columns)
karu_d3_data, karu_nd3_data, sal_data = tephi.loadtxt(karu_d3_filename, karu_nd3_filename, dunion_filename, column_titles = columns)

print(karu_d3_data.pressure)
print(karu_d3_data.temp)

karu_d3_temps = zip(karu_d3_data.pressure, karu_d3_data.temp)
karu_nd3_temps = zip(karu_nd3_data.pressure, karu_nd3_data.temp)
sal_temps = zip(sal_data.pressure, sal_data.temp)

#pressures = zip(karu_d3_data.pressure, karu_d3_data.pressure)

tpg = tephi.Tephigram()
#tpg.plot(pressure)
print(karu_d3_temps)
#tpg.plot(dews, label='Dew-point temperature', color='blue', linewidth=2, linestyle='--', marker='s')

tpg.plot(karu_d3_temps, label='Guadeloupe D3 temperature', color='red', linewidth=2,linestyle='--', marker='s')

tpg.plot(karu_nd3_temps, label='Guadeloupe ND3 temperature', color='orange', linewidth=2,linestyle='--', marker='s')

tpg.plot(sal_temps, label='SAL Dunion temperature', color='blue', linewidth=2, linestyle='-', marker='o')

print(dir(tpg))

print(dir(tephi))

#plt.show()
#tpg.suptitle('Profil de Temperature')

plt.savefig('temps_all_cases.png')
plt.savefig('temps_all_cases.jpg')
