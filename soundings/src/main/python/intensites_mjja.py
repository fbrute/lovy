#!/usr/bin/env python
import matplotlib.pyplot as plt
import os.path

import tephi

# all cases

#karu_all_d3 = os.path.join(tephi.DATA_DIR, '..','dews.txt')

#print(tephi.DATA_DIR)
print(os.getcwd())

karu_jnp_so_filename = os.path.join('../sql/tephi', 'guadeloupe_jnp_so_tephi_data.txt')
karu_so_faible_filename =  os.path.join('../sql/tephi', 'guadeloupe_so_faible_tephi_data.txt')
karu_so_moyen_filename =  os.path.join('../sql/tephi', 'guadeloupe_so_moyen_tephi_data.txt')
karu_so_fort_filename =  os.path.join('../sql/tephi', 'guadeloupe_so_fort_tephi_data.txt')

pr_jnp_so_filename = os.path.join('../sql/tephi', 'puerto_rico_jnp_so_tephi_data.txt')
pr_so_faible_filename =  os.path.join('../sql/tephi', 'puerto_rico_so_faible_tephi_data.txt')
pr_so_moyen_filename =  os.path.join('../sql/tephi', 'puerto_rico_so_moyen_tephi_data.txt')
pr_so_fort_filename =  os.path.join('../sql/tephi', 'puerto_rico_so_fort_tephi_data.txt')

dunion_filename = os.path.join('../data', 'sal_dunion.csv')

columns = ('pressure', 'temp', 'dewpoint', 'rh')

karu_jnp_so_data , karu_so_faible_data, karu_so_moyen_data, karu_so_fort_data, sal_data, pr_jnp_so_data, pr_so_faible_data, pr_so_moyen_data, pr_so_fort_data = \
tephi.loadtxt(karu_jnp_so_filename, karu_so_faible_filename,karu_so_moyen_filename, karu_so_fort_filename, dunion_filename, pr_jnp_so_filename, pr_so_faible_filename , pr_so_moyen_filename , pr_so_fort_filename, column_titles = columns)

#print(karu_d3_data.pressure)
#print(karu_d3_data.temp)

karu_jnp_so_temps = zip(karu_jnp_so_data.pressure, karu_jnp_so_data.temp)
karu_so_faible_temps = zip(karu_so_faible_data.pressure, karu_so_faible_data.temp)
karu_so_moyen_temps = zip(karu_so_moyen_data.pressure, karu_so_moyen_data.temp)
karu_so_fort_temps = zip(karu_so_fort_data.pressure, karu_so_fort_data.temp)

sal_temps = zip(sal_data.pressure, sal_data.temp)

pr_jnp_so_temps = zip(pr_jnp_so_data.pressure, pr_jnp_so_data.temp)
pr_so_faible_temps = zip(pr_so_faible_data.pressure, pr_so_faible_data.temp)
pr_so_moyen_temps = zip(pr_so_moyen_data.pressure, pr_so_moyen_data.temp)
pr_so_fort_temps = zip(pr_so_fort_data.pressure, pr_so_fort_data.temp)

tpg = tephi.Tephigram()

tpg.plot(karu_jnp_so_temps, label='Guadeloupe JNP SO ', color='magenta', linewidth=2,linestyle='--', marker='s')
tpg.plot(karu_so_faible_temps, label='Guadeloupe JP SO faible intensite ', color='salmon', linewidth=2,linestyle='-', marker='s')
tpg.plot(karu_so_moyen_temps, label='Guadeloupe JP SO moyenne intensite ', color='orangered', linewidth=2,linestyle='-', marker='s')
tpg.plot(karu_so_fort_temps, label='Guadeloupe JP SO forte intensite ', color='darkred', linewidth=2,linestyle='-', marker='s')

tpg.plot(pr_jnp_so_temps, label='Porto-Rico JNP SO ', color='cyan', linewidth=2,linestyle='--', marker='s')
tpg.plot(pr_so_faible_temps, label='Porto-Rico JP SO faible intensite ', color='lightskyblue', linewidth=2,linestyle='-', marker='s')
tpg.plot(pr_so_moyen_temps, label='Porto-Rico JP SO moyenne intensite ', color='dodgerblue', linewidth=2,linestyle='-', marker='s')
tpg.plot(pr_so_fort_temps, label='Porto-Rico JP SO forte intensite ', color='mediumblue', linewidth=2,linestyle='-', marker='s')


tpg.plot(sal_temps, label='SAL Dunion temperature', color='black', linewidth=2, linestyle='-', marker='o')

plt.savefig('intensites_so_guad_pr_temp.jpg')
