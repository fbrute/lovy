import matplotlib
matplotlib.use("Svg")

import numpy as np
import matplotlib.pyplot as plot

from tephigram_python import Tephigram

def test_plot_dewpoint_temp():
    tephigram = Tephigram()

    sounding = np.loadtxt('../data/karu_d3_temps.txt', unpack=True)
    P = sounding[0]
    T = sounding[1]
    T_dp = sounding[3]

    tephigram.plot_sounding(P=P, T=T, T_dp=T_dp)
    tephigram.plot_sounding(P=P, T=T, T_dp=T_dp)
    tephigram.savefig('tephigram_example_dewpoint_temp.png')

