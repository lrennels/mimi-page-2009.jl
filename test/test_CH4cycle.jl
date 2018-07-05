using Mimi
using Base.Test

include("../src/utils/load_parameters.jl")
include("../src/components/CH4cycle.jl")

m = Model()
set_dimension!(m, :time, [2009.,2010.,2020.,2030.,2040., 2050., 2075.,2100.,2150.,2200.])
set_dimension!(m, :region, ["EU", "USA", "OECD","USSR","China","SEAsia","Africa","LatAmerica"])

addcomponent(m, ch4cycle, :ch4cycle)

set_parameter!(m, :ch4cycle, :e_globalCH4emissions, readpagedata(m,"test/validationdata/e_globalCH4emissions.csv"))
set_parameter!(m, :ch4cycle, :rtl_g_landtemperature, readpagedata(m,"test/validationdata/rtl_g_landtemperature.csv"))
set_parameter!(m,:ch4cycle,:y_year_0,2008.)

p = load_parameters(m)
p["y_year"] = Mimi.dim_keys(m.md, :time)
set_leftover_params!(m, p)

#running Model
run(m)

conc=m[:ch4cycle,  :c_CH4concentration]
conc_compare=readpagedata(m,"test/validationdata/c_ch4concentration.csv")

@test conc ≈ conc_compare rtol=1e-4
