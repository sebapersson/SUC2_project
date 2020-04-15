# This file contains the DDE-models in a format where they can be solved using
# the DifferentialEquations package in Julia.
# The functions are split into two parts. First is the standard functions,
# then follows the model functions used when doing special parts with the
# models. This is for example when deleting a state, or running the second
# run in the STS estimation where certain parameters are kept fixed.

# The simple three state feedback model.
# Args:
#  du, the derivates (act as output)
#  u, the model states
#  h, the time-delay function
#  p, the model paraemters
#  t, the time
function simple_feedback_model(du, u, h, p, t)

    k1, k3, k5, k6, k7, k8, k9, tau1, tau2, Mig10, SUC20, X0  = p

    # The time-dealys, tau1 = 32 min
    hist_Mig1 = h(p, t - tau1)[1]
    hist_X = h(p, t - tau2)[3]

    # For making the reading easier
    Mig1, SUC2, X = u[1], u[2], u[3]

    # To emulate the glucose cut
    if t < 0.0483
       rate_in = k1
       HX = 0
    else
       HX = 1
       rate_in = k1 / 40
    end

    # Relationships from assuming steady state
    k4 = k3 / ((k7 + Mig10*Mig10) * SUC20)
    k2 = k1 / Mig10

    # The dynamics
    du[1] = rate_in - k2*Mig1 + k5 * hist_X
    du[2] = k3 / (k7 + hist_Mig1^2) - k4 * SUC2
    du[3] = HX * k8 / (k9 + Mig1) - k6 * X
end
