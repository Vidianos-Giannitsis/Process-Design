using DifferentialEquations
using Optimization
using OptimizationOptimJL
using DiffEqParamEstim
using Plots
using CSV
using DataFrames

"""
    monod(du, u, p, t)

System of differential equations describing microbial growth.

The microorganism in question is C. glycerinogenes a glycerol
producing osmophilic yeast, whose kinetics are unkown but assumed to
be of the form of inhibition by the product glycerol. This function
will be used for parameter estimation to figure out the intended
parameters of the model.
"""
function monod(du, u, p, t)
    x, G, S = u
    μmax, Ks, α, β = p

    du[1] = rx = @. (μmax*x)/(Ks/S+1)
    du[2] = rg = @. (((α*μmax)/(Ks/S+1))+β)*x
    du[3] = rs = @. -((((22.3+2.3α)*μmax)/(Ks/S+1))+2.3β)*x
end

# Defining the ODEProblem using parameters that are assumed to be correct
u0 = [0.93824;0;230.44]
tspan = (0.0, 80.0)
p = [0.011, 236.19, 2.5, 1]
prob = ODEProblem(monod, u0, tspan, p)

sol = solve(prob, Tsit5())

# Collecting the experimental data
exp_data_frame = CSV.read("c_glycerinogenes_kinetics.csv",
                          DataFrame)
exp_data = copy(exp_data_frame)
t = exp_data.t
data = vcat(exp_data.x', exp_data.G', exp_data.S')

p = plot(t, [exp_data.G, exp_data.S])
scatter!(t, [exp_data.G, exp_data.S])
plot!(twinx(), t, exp_data.x)
scatter!(twinx(), t, exp_data.x)

# Solve the optimization problem
cost_function = build_loss_objective(prob, Tsit5(), L2Loss(t, data),
                                     Optimization.AutoForwardDiff(),
                                     maxiters=10000, verbose=false)
optprob = Optimization.OptimizationProblem(cost_function, [0.011, 236.19, 30, 2.5, 1])
optsol = solve(optprob, BFGS())
