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

# Global Sensitivity test. This isn't really meaningful as the
# sensitivity of linear functions is trivial, but it's mostly a test
# of what is available in this.
using GlobalSensitivity

bounds = [[6.0,16.0],[3.0,8.0],[0.02,0.1],[1.5,5.0],[0.5,4.0],[0.04,0.1]]
function cf_model(x)
    0.0109*x[1] + 0.00843*x[2] + 0.889*x[3] + 0.0034*x[4] + 0.0017*x[5] + 1.698*x[6] + 0.00222
end
sens = gsa(cf_model, Morris(), bounds)

sens.means
sens.variances
# Running a global sensitivity analysis, the means of the
# sensitivities calculated are (as expected) the coefficients of the
# linear equation and the variances are incredibly small numbers
# because this is calculated with very high precision. This is an
# expected result as this analysis is trivial though.
