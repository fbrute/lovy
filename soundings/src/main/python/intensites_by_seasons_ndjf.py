#!/usr/bin/env python
import matplotlib.pyplot as plt
import os.path

import tephi

# all cases

#karu_all_d3 = os.path.join(tephi.DATA_DIR, '..','dews.txt')

#print(tephi.DATA_DIR)
print(os.getcwd())

karu_jnp_filename = os.path.join('../sql/tephi', 'guadeloupe_jnp_tephi_data.txt')
karu_jp_faible_filename =  os.path.join('../sql/tephi', 'guadeloupe_jp_intensite_faible_tephi_data.txt')
karu_jp_moyen_filename =  os.path.join('../sql/tephi', 'guadeloupe_jp_intensite_moyen_tephi_data.txt')
karu_jp_fort_filename =  os.path.join('../sql/tephi', 'guadeloupe_jp_intensite_fort_tephi_data.txt')

pr_jnp_filename = os.path.join('../sql/tephi', 'puerto_rico_jnp_tephi_data.txt')
pr_jp_faible_filename = os.path.join('../sql/tephi', 'puerto_rico_jp_intensite_faible_tephi_data.txt')
pr_jp_moyen_filename = os.path.join('../sql/tephi', 'puerto_rico_jp_intensite_moyen_tephi_data.txt')
pr_jp_fort_filename = os.path.join('../sql/tephi', 'puerto_rico_jp_intensite_fort_tephi_data.txt')
#pr_jnp_filename = os.path.join('../sql/tephi', 'puerto_rico_jnp_so_tephi_data.txt')

dunion_filename = os.path.join('../data', 'sal_dunion.csv')

columns = ('pressure', 'temp', 'dewpoint', 'rh')

karu_jnp_data , karu_jp_faible_data, karu_jp_moyen_data, karu_jp_fort_data, sal_data, pr_jnp_data, pr_jp_faible_data, pr_jp_moyen_data, pr_jp_fort_data = tephi.loadtxt(karu_jnp_filename, karu_jp_faible_filename,karu_jp_moyen_filename, karu_jp_fort_filename, dunion_filename, pr_jnp_filename, pr_jp_faible_filename ,pr_jp_moyen_filename ,pr_jp_fort_filename, column_titles = columns)

#print(karu_d3_data.pressure)
#print(karu_d3_data.temp)

karu_jnp_temps = zip(karu_jnp_data.pressure, karu_jnp_data.temp)
karu_jp_faible_temps = zip(karu_jp_faible_data.pressure, karu_jp_faible_data.temp)
karu_jp_moyen_temps = zip(karu_jp_moyen_data.pressure, karu_jp_moyen_data.temp)
karu_jp_fort_temps = zip(karu_jp_fort_data.pressure, karu_jp_fort_data.temp)
sal_temps = zip(sal_data.pressure, sal_data.temp)
pr_jnp_temps = zip(pr_jnp_data.pressure, pr_jnp_data.temp)
pr_jp_faible_temps = zip(pr_jp_faible_data.pressure, pr_jp_faible_data.temp)
pr_jp_moyen_temps = zip(pr_jp_moyen_data.pressure, pr_jp_moyen_data.temp)
pr_jp_fort_temps = zip(pr_jp_fort_data.pressure, pr_jp_fort_data.temp)

#pr_jnp_temps = zip(pr_jnp_data.pressure, pr_jnp_data.temp)

#pressures = zip(karu_d3_data.pressure, karu_d3_data.pressure)

tpg = tephi.Tephigram()

tpg.plot(karu_jp_faible_temps, label='Guadeloupe JP faible intensite temperature', color='salmon', linewidth=2,linestyle='-', marker='s')
tpg.plot(karu_jp_moyen_temps, label='Guadeloupe JP moyenne intensite temperature', color='orangered', linewidth=2,linestyle='-', marker='s')
tpg.plot(karu_jp_fort_temps, label='Guadeloupe JP forte intensite temperature', color='darkred', linewidth=2,linestyle='-', marker='s')

tpg.plot(karu_jnp_temps, label='Guadeloupe JNP temperature', color='magenta', linewidth=2,linestyle='--', marker='s')

tpg.plot(pr_jp_faible_temps, label='Porto-Rico JP faible intensite temperature', color='lightskyblue', linewidth=2,linestyle='-', marker='s')
tpg.plot(pr_jp_moyen_temps, label='Porto-Rico JP moyenne intensite temperature', color='dodgerblue', linewidth=2,linestyle='-', marker='s')
tpg.plot(pr_jp_fort_temps, label='Porto-Rico JP forte intensite temperature', color='darkblue', linewidth=2,linestyle='-', marker='s')

tpg.plot(pr_jnp_temps, label='Porto-Rico JNP temperature', color='cyan', linewidth=2,linestyle='--', marker='s')

tpg.plot(sal_temps, label='SAL Dunion temperature', color='black', linewidth=2, linestyle='-', marker='o')

plt.savefig('intensites_jp_jnp_guad_pr_temp.jpg')
