# Calculate the temperature of the earth using the simplest model
# @jake
# https://discourse.julialang.org/t/seven-lines-of-julia-examples-sought/50416/121

using Unitful, Plots
p_sun = 386e24u"W"      # power output of the sun
radius_a = 6378u"km"    # semi-major axis of the earth
radius_b = 6357u"km"    # semi-minor axis of the earth
orbit_a = 149.6e6u"km"  # distance from the sun to earth
orbit_e = 0.017         # eccentricity of r = a(1-e^2)/(1+ecos(θ))  & time ≈ 365.25 * θ / 360 where θ is in degrees
a = 0.75                # absorptivity of the sun's radiation
e = 0.6                 # emmissivity of the earth (very dependent on cloud cover)
σ = 5.6703e-8u"W*m^-2*K^-4"  # Stefan-Boltzman constant
temp_sky = 3u"K"        # sky temperature



t = (0:0.25:365.25)u"d"       # day of year in 1/4 day increments
θ = 2*π/365.25u"d" .* t       # approximate angle around the sun
r = orbit_a * (1-orbit_e^2) ./ (1 .+ orbit_e .* cos.(θ))    # distance from sun to earth
area_projected = π * radius_a * radius_b    # area of earth facing the sun
ec = sqrt(1-radius_b^2/radius_a^2)  # eccentricity of earth

area_surface = 2*π*radius_a^2*(1 + radius_b^2/(ec*radius_b^2)*atanh(ec)) # surface area of the earth

q_in = p_sun * a * area_projected ./ (4 * π .* r.^2) # total heat impacting the earth

temp_earth = (q_in ./ (e*σ*area_surface) .+ temp_sky^4).^0.25 # temperature of the earth

plot(t*u"d^-1", temp_earth*u"K^-1" .- 273.15, label = false, title = "Temperature of Earth", xlabel = "Day", ylabel = "Temperature [C]")
