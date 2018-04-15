newInstance = function(ScenarioInfo)
    local options = import('/maps/final_rush_pro_5.9.v0001/src/frp/FinalRushOptions.lua').newInstance(ScenarioInfo.Options)
    ScenarioInfo.Options = options.getRawOptions()

    local textPrinter = import('/maps/final_rush_pro_5.9.v0001/src/lib/TextPrinter.lua').newInstance()
    local playerArmies = import('/maps/final_rush_pro_5.9.v0001/src/frp/PlayerArmies.lua').newInstance(ListArmies())
    local buildRestrictor = import('/maps/final_rush_pro_5.9.v0001/src/frp/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo)

    local function setupTents()
        if ScenarioInfo.Options.opt_tents > 0 then
            local tents = import('/maps/final_rush_pro_5.9.v0001/src/artifacts/PrebuildTents.lua').newInstance(playerArmies);
            LOG("Spawning " .. ScenarioInfo.Options.opt_tents .. " tents")
            tents.spawn(ScenarioInfo.Options.opt_tents)
        end
    end

    local function setupLighthouses()
        import('/maps/final_rush_pro_5.9.v0001/src/artifacts/CivilianLighthouses.lua').newInstance(textPrinter, playerArmies).spawn();
    end

    local function restrictTechs()
        if ScenarioInfo.Options.opt_timeunlocked ~= 0 then
            local techRestrictor = import('/maps/final_rush_pro_5.9.v0001/src/frp/TechRestrictor.lua').newInstance(
                buildRestrictor,
                textPrinter,
                playerArmies,
                ScenarioInfo.Options.opt_timeunlocked
            );

            techRestrictor.startRestrictedTechCascade()
        end
    end

    local function setupParagonWars()
        if options.isParagonWars() then
            local paragonWars = import('/maps/final_rush_pro_5.9.v0001/src/paragon/ParagonWars.lua').newInstance(playerArmies, textPrinter)
            paragonWars.setUp()
        end
    end

    local function setupServival()
        if options.isSurvivalGame() then
            local survival = import('/maps/final_rush_pro_5.9.v0001/src/survival/Survival.lua').newInstance(ScenarioInfo, options, textPrinter, playerArmies)
            survival.start()
        end
    end

    local function setupAutoReclaim()
        if ScenarioInfo.Options.opt_AutoReclaim > 0 then
            ForkThread(
                import('/maps/final_rush_pro_5.9.v0001/src/frp/AutoReclaim.lua').AutoReclaimThread,
                options,
                playerArmies
            )
        end
    end

    local function showWelcomeMessage()
        local welcomeMessages = import('/maps/final_rush_pro_5.9.v0001/src/frp/WelcomeMessages.lua').newInstance(ScenarioInfo, options, textPrinter)
        welcomeMessages.startDisplay()
    end

    return {
        setUp = function()
            showWelcomeMessage()
            buildRestrictor.resetToStartingRestrictions()
            setupTents()
            setupLighthouses()
            restrictTechs()
            setupParagonWars()
            setupServival()
            setupAutoReclaim()
        end
    }
end