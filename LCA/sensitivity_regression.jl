using MLJ, CSV, DataFrames

# Read the data from the csvs
input = CSV.read("sensitivity_input.csv", DataFrame)
output = CSV.read("sensitivity_output.csv", DataFrame)

# Extract the data excluding the name column
input_data = input[:, 2:32]
output_data = output[:,2:32]

# Tidy up the data to do linear regression for CF
# First, we need to rotate the x table for the regression to work.
X = DataFrame(Tables.table(Matrix(input_data)'))
cf = Vector(output_data[1,:])

# Train the regression model
using GLM, MLJGLMInterface
LinearRegressor = @load LinearRegressor pkg=GLM

model = LinearRegressor()

cf_mach = machine(model, X, cf)
fit!(cf_mach)

# Check the output
fitted_params(cf_mach)
report(cf_mach)
cf_hat = MLJ.predict_mean(cf_mach, X)
rsq_cf = RSquared()(cf_hat, cf)
# R^2 = 0.987

# We can do the same for the other output variables
wu = Vector(output_data[2,:])
ed = Vector(output_data[3,:])
ap = Vector(output_data[4,:])
ep = Vector(output_data[5,:])
ht = Vector(output_data[6,:])

wu_mach = machine(model, X, wu)
fit!(wu_mach)
fitted_params(wu_mach)
report(wu_mach)
wu_hat = MLJ.predict_mean(wu_mach, X)
rsq_wu = RSquared()(wu_hat, wu)
# R^2 = 0.998

ed_mach = machine(model, X, ed)
fit!(ed_mach)
fitted_params(ed_mach)
report(ed_mach)
ed_hat = MLJ.predict_mean(ed_mach, X)
rsq_ed = RSquared()(ed_hat, ed)
# R^2 = 0.989

ap_mach = machine(model, X, ap)
fit!(ap_mach)
fitted_params(ap_mach)
report(ap_mach)
ap_hat = MLJ.predict_mean(ap_mach, X)
rsq_ap = RSquared()(ap_hat, ap)
# R^2 = 0.29

ep_mach = machine(model, X, ep)
fit!(ep_mach)
fitted_params(ep_mach)
report(ep_mach)
ep_hat = MLJ.predict_mean(ep_mach, X)
rsq_ep = RSquared()(ep_hat, ep)
# R^2 = 0.965

ht_mach = machine(model, X, ht)
fit!(ht_mach)
fitted_params(ht_mach)
report(ht_mach)
ht_hat = MLJ.predict_mean(ht_mach, X)
rsq_ht = RSquared()(ht_hat, ht)
# R^2 = 0.99

# Improvement of the models
new_X = DataFrame(Tables.table(X[1:6,1]))
new_ap = ap[1:6]
ap_mach = machine(model, new_X, new_ap)
fit!(ap_mach)
fitted_params(ap_mach)
report(ap_mach)
ap_hat = MLJ.predict_mean(ap_mach, new_X)
rsq_ap = RSquared()(ap_hat, new_ap)
# If tried with 2 parameters, the model is not linear. However, if we
# only include the effect of the olive kernel, the model becomes
# linear with R^2 = 0.994.

new_X = select(X, 1, 3)
new_X = vcat(new_X[1:6,:], new_X[12:16,:])
new_ep = [ep[1:6]' ep[12:16]']'
ep_mach = machine(model, new_X, new_ep)
fit!(ep_mach)
fitted_params(ep_mach)
report(ep_mach)
ep_hat = MLJ.predict_mean(ep_mach, new_X)
rsq_ep = RSquared()(ep_hat, new_ep)
# This model has a very slight increase in R^2 (0.965 -> 0.97) and
# gives a very similar result. It is more correct however, because we
# know only these factors truly relate.

new_X = select(X, 2, 5)
new_X = vcat(new_X[6:11, :], new_X[22:26, :])
new_wu = [wu[6:11]' wu[22:26]']'
wu_mach = machine(model, new_X, new_wu)
fit!(wu_mach)
fitted_params(wu_mach)
report(wu_mach)
wu_hat = MLJ.predict_mean(wu_mach, new_X)
rsq_wu = RSquared()(wu_hat, new_wu)
# Similar results with above

# Now let's visualize the hotspot and sensitivity analyses
cf_sens = reshape([0.0109, 0.889, 1.698], (1,3))
y_label = ["Olive Kernel", "Hexane", "Hydrogen"]

cf_pie = [0.252/0.452, 0.04/0.452, 0.139/0.452, (0.452-0.431)/0.452]
colors = Makie.wong_colors()[1:length(cf_pie)]
labels = ["Olive Kernel", "Hexane", "Hydrogen", "Other"]

cf_fig = Figure(size = (600, 400))
ax1, hm1 = CairoMakie.heatmap(cf_fig[1,1], cf_sens, axis = (xticks = (1:2, ["", ""]), yticks = (1:3, y_label), title = "Sensitivity Analysis for Carbon Footprint"))
Colorbar(cf_fig[1,2], hm1)
ax, plt = pie(cf_fig[2,1], cf_pie, color=colors, axis=(aspect=DataAspect(), title = "Hot Spot analysis for Carbon Footprint"))
hidedecorations!(ax)
hidespines!(ax)
Legend(cf_fig[2,2], [PolyElement(color=c) for c in colors], labels, framevisible=false)
save("plots/cf_plots.png", cf_fig)

wu_sens = reshape([0.001, 0.00519], (1,2))
y_label = ["Steam Explosion Water", "Distillation Cooling"]

wu_pie = [5.85e-3/2e-2, 5e-3/2e-2, (2e-2 - 10.85e-3)/2e-2]
colors = Makie.wong_colors()[1:length(wu_pie)]
labels = ["Steam Explosion Water", "Distillation Cooling", "Other Cooling Needs"]

wu_fig = Figure(size = (600,400))
ax, hm = CairoMakie.heatmap(wu_fig[1,1], wu_sens, axis = (xticks = (1:2, ["", ""]), yticks = (1:2, y_label), title = "Sensitivity Analysis for Water Usage"))
Colorbar(wu_fig[1,2], hm)
ax, plt = pie(wu_fig[2,1], wu_pie, color = colors, axis = (aspect=DataAspect(), title = "Hot Spot analysis for Water Usage"))
hidedecorations!(ax)
hidespines!(ax)
Legend(wu_fig[2,2], [PolyElement(color=c) for c in colors], labels, framevisible=false)
save("plots/wu_plots.png", wu_fig)

ed_sens = reshape([0.234, 3.117, 61.8676, 68.867], (1,4))
y_label = ["Olive Kernel", "Steam Explosion Water", "Hexane", "Hydrogen"]

ed_pie = [12.22/43.85, 18.5/43.85, 2.7/43.85, 6.18/43.85, (43.85-39.6)/43.85]
colors = Makie.wong_colors()[1:length(ed_pie)]
labels = ["Olive Kernel", "Steam Explosion Water", "Hexane", "Hydrogen", "Other"]

ed_fig = Figure(size = (750, 500))
ax, hm = CairoMakie.heatmap(ed_fig[1,1], ed_sens, axis = (xticks = (1:2, ["", ""]), yticks = (1:4, y_label), title = "Sensitivity Analysis for Energy Demand"))
Colorbar(ed_fig[1,2], hm)
Label(ed_fig[2,1], "Note that Water has 10 times higher sensitivity \nthan Olive Kernel")
ax, plt = pie(ed_fig[3,1], ed_pie, color = colors, axis = (aspect=DataAspect(), title = "Hot Spot analysis for Energy Demand"))
hidedecorations!(ax)
hidespines!(ax)
Legend(ed_fig[3,2], [PolyElement(color=c) for c in colors], labels, framevisible=false)
save("plots/ed_plots.png", ed_fig)

ep_sens = reshape([0.00058, 0.0833], (1,2))
y_label = ["Olive Kernel", "Hexane"]

ep_pie = [6.62e-3/0.017, 8.4e-3/0.017, (0.017-0.015)/0.017]
colors = Makie.wong_colors()[1:length(ep_pie)]
labels = ["Olive Kernel", "Hexane", "Other"]

ep_fig = Figure(size = (600,400))
ax, hm = CairoMakie.heatmap(ep_fig[1,1], ep_sens, axis = (xticks = (1:2, ["", ""]), yticks = (1:2, y_label), title = "Sensitivity Analysis for Eutrophication Potential"))
Colorbar(ep_fig[1,2], hm)
ax, plt = pie(ep_fig[2,1], ep_pie, color = colors, axis = (aspect=DataAspect(), title = "Hot Spot analysis for Eutrophication Potential"))
hidedecorations!(ax)
hidespines!(ax)
Legend(ep_fig[2,2], [PolyElement(color=c) for c in colors], labels, framevisible=false)
save("plots/ep_plots.png", ep_fig)

ht_sens = reshape([0.0106, 0.03, 0.749, 0.0136], (1,4))
y_label = ["Olive Kernel", "Steam Explosion Water", "Hexane", "Distillation Heat"]

ht_pie = [0.234/0.492, 0.175/0.492, 0.033/0.492, 0.037/0.492, (0.492-0.479)/0.492]
colors = Makie.wong_colors()[1:length(ht_pie)]
labels = ["Olive Kernel", "Steam Explosion Water", "Hexane", "Distillation Heat", "Other"]

ht_fig = Figure(size = (750, 500))
ax, hm = CairoMakie.heatmap(ht_fig[1,1], ht_sens, axis = (xticks = (1:2, ["", ""]), yticks = (1:4, y_label), title = "Sensitivity Analysis for Human Toxicity"))
Colorbar(ht_fig[1,2], hm)
Label(ht_fig[2,1:2], "All sensitivities besides Hexane are very low, however, Water has 2 and 3 times \nhigher sensitivity than the Heat and Olive Kernel respectively")
ax, plt = pie(ht_fig[3,1], ht_pie, color = colors, axis = (aspect=DataAspect(), title = "Hot Spot analysis for Human Toxicity"))
hidedecorations!(ax)
hidespines!(ax)
Legend(ht_fig[3,2], [PolyElement(color=c) for c in colors], labels, framevisible=false)
save("plots/ht_plots.png", ht_fig)

# We can also try doing a Sobol's sensitivity analysis which finds
# what amount of the variance of the output is due to the variance in
# the input. This is a different measure of sensitivity than the
# derivative (which is trivial in linear functions) which can also be
# deemed important.

# First, we need to define the functions we found above.
function cf_fun(x)
    0.0109x[1]+0.0084x[2]+0.889x[3]+0.0034x[4]+0.0017x[5]+1.698x[6]+0.0022
end

function wu_fun(x)
    0.001x[2]+0.00519x[5]+0.00412
end

function ed_fun(x)
    0.234x[1]+3.117x[2]+61.868x[3]+1.413x[4]+0.0235x[5]+68.867x[6]+0.509
end

function ap_fun(x)
    0.00209x[1]+0.00145
end

function ep_fun(x)
    0.000582x[1]+0.0833x[3]+0.0067
end

function ht_fun(x)
    0.0106x[1]+0.03x[2]+0.749x[3]+0.0136x[4]+0.00088x[5]+0.0021x[6]+0.00654
end

# Run the Sobol's method
sens_bounds = [[6.0, 16.0], [3.0,8.0], [0.02,0.1], [1.5,5.0], [0.5,4.0], [0.04, 0.1]]

cf_sensit = gsa(cf_fun, Sobol(), sens_bounds, samples=500)
wu_sensit = gsa(wu_fun, Sobol(), sens_bounds, samples=500)
ed_sensit = gsa(ed_fun, Sobol(), sens_bounds, samples=500)
ap_sensit = gsa(ap_fun, Sobol(), sens_bounds, samples=500)
ep_sensit = gsa(ep_fun, Sobol(), sens_bounds, samples=500)
ht_sensit = gsa(ht_fun, Sobol(), sens_bounds, samples=500)

# Check the first order Sobol indices
cf_S1 = cf_sensit.S1
wu_S1 = wu_sensit.S1
ed_S1 = ed_sensit.S1
ap_S1 = ap_sensit.S1
ep_S1 = ep_sensit.S1
ht_S1 = ht_sensit.S1

