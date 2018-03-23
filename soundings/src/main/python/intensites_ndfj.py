#!/usr/bin/env python
import matplotlib.pyplot as plt
import os.path

import tephi

# all cases

#karu_all_d3 = os.path.join(tephi.DATA_DIR, '..','dews.txt')

#print(tephi.DATA_DIR)
print(os.getcwd())

karu_jnp_ndjf_filename = os.path.join('../sql/tephi', 'guadeloupe_jnp_ndfj_tephi_data.txt')
karu_ndjf_faible_filename =  os.path.join('../sql/tephi', 'guadeloupe_ndjf_faible_tephi_data.txt')
karu_ndjf_moyen_filename =  os.path.join('../sql/tephi', 'guadeloupe_ndjf_moyen_tephi_data.txt')
karu_ndjf_fort_filename =  os.path.join('../sql/tephi', 'guadeloupe_ndjf_fort_tephi_data.txt')

pr_jnp_ndjf_filename = os.path.join('../sql/tephi', 'puerto_rico_jnp_ndjf_tephi_data.txt')
pr_ndjf_faible_filename =  os.path.join('../sql/tephi', 'puerto_rico_ndjf_faible_tephi_data.txt')
pr_ndjf_moyen_filename =  os.path.join('../sql/tephi', 'puerto_rico_ndjf_moyen_tephi_data.txt')
#pr_ndjf_fort_filename =  os.path.join('../sql/tephi', 'puerto_rico_ndjf_fort_tephi_data.txt')

dunion_filename = os.path.join('../data', 'sal_dunion.csv')

columns = ('pressure', 'temp', 'dewpoint', 'rh')

karu_jnp_ndjf_data , karu_ndjf_faible_data, karu_ndjf_moyen_data, karu_ndjf_fort_data, sal_data, pr_jnp_ndjf_data, pr_ndjf_faible_data, pr_ndjf_moyen_data, pr_ndjf_fort_data = \
tephi.loadtxt(karu_jnp_ndjf_filename, karu_ndjf_faible_filename,karu_ndjf_moyen_filename, karu_ndjf_fort_filename, dunion_filename, pr_jnp_ndjf_filename, pr_ndjf_faible_filename , pr_ndjf_moyen_filename , pr_ndjf_fort_filename, column_titles = columns)

#print(karu_d3_data.pressure)
#print(karu_d3_data.temp)

karu_jnp_ndjf_temps = zip(karu_jnp_ndjf_data.pressure, karu_jnp_ndjf_data.temp)
karu_ndjf_faible_temps = zip(karu_ndjf_faible_data.pressure, karu_ndjf_faible_data.temp)
karu_ndjf_moyen_temps = zip(karu_ndjf_moyen_data.pressure, karu_ndjf_moyen_data.temp)
karu_ndjf_fort_temps = zip(karu_ndjf_fort_data.pressure, karu_ndjf_fort_data.temp)

sal_temps = zip(sal_data.pressure, sal_data.temp)

pr_jnp_ndjf_temps = zip(pr_jnp_ndjf_data.pressure, pr_jnp_ndjf_data.temp)
pr_ndjf_faible_temps = zip(pr_ndjf_faible_data.pressure, pr_ndjf_faible_data.temp)
pr_ndjf_moyen_temps = zip(pr_ndjf_moyen_data.pressure, pr_ndjf_moyen_data.temp)
pr_ndjf_fort_temps = zip(pr_ndjf_fort_data.pressure, pr_ndjf_fort_data.temp)

tpg = tephi.Tephigram()

tpg.plot(karu_jnp_ndjf_temps, label='Guadeloupe JNP NDJF temperature', color='magenta', linewidth=2,linestyle='--', marker='s')
tpg.plot(karu_ndjf_faible_temps, label='Guadeloupe JP NDJF faible intensite temperature', color='salmon', linewidth=2,linestyle='-', marker='s')
tpg.plot(karu_ndjf_moyen_temps, label='Guadeloupe JP NDJF moyenne intensite temperature', color='orangered', linewidth=2,linestyle='-', marker='s')
tpg.plot(karu_ndjf_fort_temps, label='Guadeloupe JP NDJF forte intensite temperature', color='darkred', linewidth=2,linestyle='-', marker='s')

tpg.plot(pr_jnp_ndjf_temps, label='Porto-Rico JNP NDJF temperature', color='cyan', linewidth=2,linestyle='--', marker='s')
tpg.plot(pr_ndjf_faible_temps, label='Porto-Rico JP NDJF faible intensite temperature', color='lightskyblue', linewidth=2,linestyle='-', marker='s')
tpg.plot(pr_ndjf_moyen_temps, label='Porto-Rico JP NDJF moyenne intensite temperature', color='dodgerblue', linewidth=2,linestyle='-', marker='s')
tpg.plot(pr_ndjf_fort_temps, label='Porto-Rico JP NDJF forte intensite temperature', color='darkblue', linewidth=2,linestyle='-', marker='s')


tpg.plot(sal_temps, label='SAL Dunion temperature', color='black', linewidth=2, linestyle='-', marker='o')

plt.savefig('intensites_ndjf_guad_pr_temp.jpg')
