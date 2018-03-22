#!/usr/bin/env python
import matplotlib.pyplot as plt
import os.path

import tephi

# all cases

#karu_all_d3 = os.path.join(tephi.DATA_DIR, '..','dews.txt')

#print(tephi.DATA_DIR)
print(os.getcwd())

#karu_d3_filename = os.path.join(tephi.DATA_DIR, 'karu_d3_temps.txt')
karu_jp_filename = os.path.join('../sql/tephi', 'guadeloupe_jp_tephi_data.txt')
print("##########################")
print(karu_jp_filename)
print("##########################")

karu_jnp_filename = os.path.join('../sql/tephi', 'guadeloupe_jnp_tephi_data.txt')
karu_jp_filename =  os.path.join('../sql/tephi', 'guadeloupe_jp_tephi_data.txt')

pr_jp_filename = os.path.join('../sql/tephi', 'puerto_rico_jp_tephi_data.txt')
pr_jnp_filename = os.path.join('../sql/tephi', 'puerto_rico_jnp_tephi_data.txt')

dunion_filename = os.path.join('../data', 'sal_dunion.csv')

columns = ('pressure', 'temp', 'dewpoint', 'rh')

karu_jp_data, karu_jnp_data  ,sal_data, pr_jp_data, pr_jnp_data = tephi.loadtxt(karu_jp_filename, karu_jnp_filename, dunion_filename, pr_jp_filename, pr_jnp_filename, column_titles = columns)

#print(karu_d3_data.pressure)
#print(karu_d3_data.temp)

karu_jp_temps = zip(karu_jp_data.pressure, karu_jp_data.temp)
karu_jnp_temps = zip(karu_jnp_data.pressure, karu_jnp_data.temp)
sal_temps = zip(sal_data.pressure, sal_data.temp)
pr_jp_temps = zip(pr_jp_data.pressure, pr_jp_data.temp)
pr_jnp_temps = zip(pr_jnp_data.pressure, pr_jnp_data.temp)

#pressures = zip(karu_d3_data.pressure, karu_d3_data.pressure)

tpg = tephi.Tephigram()

tpg.plot(karu_jp_temps, label='Guadeloupe JP temperature', color='red', linewidth=2,linestyle='-', marker='s')

tpg.plot(karu_jnp_temps, label='Guadeloupe JNP temperature', color='magenta', linewidth=2,linestyle='--', marker='s')

tpg.plot(pr_jp_temps, label='Porto-Rico JP temperature', color='blue', linewidth=2,linestyle='-', marker='s')

tpg.plot(pr_jnp_temps, label='Porto-Rico JNP temperature', color='cyan', linewidth=2,linestyle='--', marker='s')

tpg.plot(sal_temps, label='SAL Dunion temperature', color='black', linewidth=2, linestyle='-', marker='o')

plt.savefig('global_jp_jnp_guad_pr_temp.jpg')
