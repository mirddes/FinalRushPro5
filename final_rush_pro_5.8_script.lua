function OnPopulate()
	import('/lua/sim/ScenarioUtilities.lua').InitializeArmies()
	import('/maps/final_rush_pro_5.8.v0001/src/FinalRushPro.lua').newInstance(ScenarioInfo).setUp()

	import('/lua/SimSync.lua')
end
