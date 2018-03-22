#!/usr/bin/env python
import matplotlib.pyplot as plt
import os.path

import tephi

# all cases

#karu_all_d3 = os.path.join(tephi.DATA_DIR, '..','dews.txt')

#print(tephi.DATA_DIR)
print(os.getcwd())

karu_filename = os.path.join('../sql/tephi', 'guadeloupe_tephi_data.txt')
pr_filename = os.path.join('../sql/tephi', 'puerto_rico_tephi_data.txt')
dunion_filename = os.path.join('../data', 'sal_dunion.csv')

columns = ('pressure', 'temp', 'dewpoint', 'rh')

karu_data ,  sal_data, pr_data = tephi.loadtxt(karu_filename, dunion_filename, pr_filename, column_titles = columns)


karu_temps = zip(karu_data.pressure, karu_data.temp)
sal_temps = zip(sal_data.pressure, sal_data.temp)
pr_temps = zip(pr_data.pressure, pr_data.temp)

tpg = tephi.Tephigram()

tpg.plot(karu_temps, label='Guadeloupe temperature', color='red', linewidth=2,linestyle='-', marker='s')

tpg.plot(pr_temps, label='Porto-Rico temperature', color='blue', linewidth=2,linestyle='-', marker='s')


tpg.plot(sal_temps, label='SAL Dunion temperature', color='black', linewidth=2, linestyle='-', marker='o')

plt.savefig('global_guad_pr_temp.jpg')
