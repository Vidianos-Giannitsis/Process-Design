
"""
    rankine(Qout, Wout)

Compute design variables from heat and electricity requirements.

Takes heat and electricity requirements as key arguments and returns
steam mass flow (m) in kg/s, fraction used for heat generation (y),
fraction used for regeneration (z), heat requirement of the cycle
(qin1) in kW, heat requirement of the reheating (qin2) in kW and
utilization factor of the cycle (ε_u).

"""
function rankine(;Qout, Wout)
    m = (Wout+0.389Qout)/1167.91
    y = Qout/(2149.16m)
    z = 0.303*(1-y)
    h5 = 176.81y + 1274.21
    qin1 = (3603 - h5)*m
    qin2 = ((1-y)*(3674.9-3236.56))*m
    ε_u = (Qout+Wout)/(qin1+qin2)

    return [m, y, z, qin1, qin2, ε_u]
end
