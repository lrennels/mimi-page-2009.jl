using Mimi
using DataFrames
using Base.Test

include("../src/components/SLRDamages.jl")

m = Model()
set_dimension!(m, :region, ["EU", "USA", "OECD","USSR","China","SEAsia","Africa","LatAmerica"])
set_dimension!(m, :time, [2009, 2010, 2020, 2030, 2040, 2050, 2075, 2100, 2150, 2200])

slrdamages = addslrdamages(m)

set_parameter!(m, :SLRDamages, :y_year, [2009, 2010, 2020, 2030, 2040, 2050, 2075, 2100, 2150, 2200])
set_parameter!(m, :SLRDamages, :atl_adjustedtolerablelevelofsealevelrise, readpagedata(m,
"test/validationdata/atl_adjustedtolerablelevelofsealevelrise.csv"))
set_parameter!(m, :SLRDamages, :imp_actualreductionSLR, readpagedata(m,
"test/validationdata/imp_actualreductionSLR.csv"))
set_parameter!(m, :SLRDamages, :y_year_0, 2008.)
set_parameter!(m, :SLRDamages, :s_sealevel, readpagedata(m, "test/validationdata/s_sealevelrise.csv"))
set_parameter!(m, :SLRDamages, :cons_percap_consumption, readpagedata(m, "test/validationdata/cons_percap_consumption.csv"))
set_parameter!(m, :SLRDamages, :tct_per_cap_totalcostspercap, readpagedata(m, "test/validationdata/tct_per_cap_totalcostspercap.csv"))
set_parameter!(m, :SLRDamages, :act_percap_adaptationcosts, readpagedata(m, "test/validationdata/act_percap_adaptationcosts.csv"))
set_parameter!(m, :SLRDamages, :isatg_impactfxnsaturation, 28.333333333333336)

##running Model
run(m)

cons_percap_aftercosts = m[:SLRDamages, :cons_percap_aftercosts]
cons_percap_aftercosts_compare = readpagedata(m, "test/validationdata/cons_percap_aftercosts.csv")
@test ones(10, 8) ≈ cons_percap_aftercosts ./ cons_percap_aftercosts_compare rtol=.001

i_regionalimpactSLR = m[:SLRDamages, :i_regionalimpactSLR]
i_regionalimpactSLR_compare = readpagedata(m, "test/validationdata/i_regionalimpact_SLRise.csv")
@test i_regionalimpactSLR ≈ i_regionalimpactSLR_compare rtol=.001

iref_ImpactatReferenceGDPperCapSLR = m[:SLRDamages, :iref_ImpactatReferenceGDPperCapSLR]
iref_ImpactatReferenceGDPperCapSLR_compare = readpagedata(m, "test/validationdata/iref_ImpactatReferenceGDPperCap_sea.csv")
@test iref_ImpactatReferenceGDPperCapSLR ≈ iref_ImpactatReferenceGDPperCapSLR_compare rtol=.0001

rcons_per_cap_SLRRemainConsumption = m[:SLRDamages, :rcons_per_cap_SLRRemainConsumption]
rcons_per_cap_SLRRemainConsumption_compare = readpagedata(m, "test/validationdata/rcons_per_cap_SLRRemainConsumption.csv")
@test rcons_per_cap_SLRRemainConsumption ≈ rcons_per_cap_SLRRemainConsumption_compare rtol=.01

rgdp_per_cap_SLRRemainGDP = m[:SLRDamages, :rgdp_per_cap_SLRRemainGDP]
rgdp_per_cap_SLRRemainGDP_compare = readpagedata(m, "test/validationdata/rgdp_per_cap_SLRRemainGDP.csv")
@test rgdp_per_cap_SLRRemainGDP ≈ rgdp_per_cap_SLRRemainGDP_compare rtol=.01

igdp_ImpactatActualGDPperCapSLR = m[:SLRDamages, :igdp_ImpactatActualGDPperCapSLR]
igdp_ImpactatActualGDPperCapSLR_compare = readpagedata(m, "test/validationdata/igdp_ImpactatActualGDPperCap_sea.csv")
@test igdp_ImpactatActualGDPperCapSLR ≈ igdp_ImpactatActualGDPperCapSLR_compare rtol=.01

isat_ImpactinclSaturationandAdaptationSLR = m[:SLRDamages, :isat_ImpactinclSaturationandAdaptationSLR]
isat_ImpactinclSaturationandAdaptationSLR_compare = readpagedata(m, "test/validationdata/isat_ImpactinclSaturationandAdaptation_SLRise.csv")
@test isat_ImpactinclSaturationandAdaptationSLR ≈ isat_ImpactinclSaturationandAdaptationSLR_compare rtol=.001
