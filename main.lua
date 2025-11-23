-- Certus Quartz Farm Monitor
-- Monitors crystal growth stages using CC:Tweaked and redstone

-- Load configuration
local config = require("config")

-- State tracking
local state = {
    leftStage = 0,
    rightStage = 0,
    mainStage = 0,
    lastUpdate = os.epoch("utc")
}

-- Function to log messages
local function log(message)
    if config.enableLogging then
        local timestamp = textutils.formatTime(os.time(), false)
        print("[" .. timestamp .. "] " .. message)
    end
end

-- Function to detect growth stage based on redstone input
local function detectStage(side, maxStage)
    local input = redstone.getInput(side)
    
    if not input then
        return 0
    end
    
    -- Get analog signal strength (0-15)
    local strength = redstone.getAnalogInput(side)
    
    -- Map signal strength to growth stages
    -- You may need to adjust this logic based on actual observer behavior
    if strength == 0 then
        return 0
    elseif strength >= config.thresholds.stage4 and maxStage >= 4 then
        return 4
    elseif strength >= config.thresholds.stage3 and maxStage >= 3 then
        return 3
    elseif strength >= config.thresholds.stage2 and maxStage >= 2 then
        return 2
    elseif strength >= config.thresholds.stage1 then
        return 1
    else
        return 0
    end
end

-- Function to update display
local function updateDisplay()
    if not config.displayUpdates then
        return
    end
    
    term.clear()
    term.setCursorPos(1, 1)
    
    print("===========================")
    print(" Certus Quartz Farm Monitor")
    print("===========================")
    print("")
    print("Left Crystal:  Stage " .. state.leftStage .. "/" .. config.crystalMaxStage)
    print("Right Crystal: Stage " .. state.rightStage .. "/" .. config.crystalMaxStage)
    print("Main Block:    Stage " .. state.mainStage .. "/" .. config.mainMaxStage)
    print("")
    print("---------------------------")
    print("Press Ctrl+T to exit")
    print("---------------------------")
    
    -- Visual progress bars
    print("")
    print("Left:  " .. string.rep("█", state.leftStage) .. string.rep("░", config.crystalMaxStage - state.leftStage))
    print("Right: " .. string.rep("█", state.rightStage) .. string.rep("░", config.crystalMaxStage - state.rightStage))
    print("Main:  " .. string.rep("█", state.mainStage) .. string.rep("░", config.mainMaxStage - state.mainStage))
end

-- Function to check all growth stages
local function checkGrowth()
    local leftStage = detectStage(config.leftSide, config.crystalMaxStage)
    local rightStage = detectStage(config.rightSide, config.crystalMaxStage)
    local mainStage = detectStage(config.mainSide, config.mainMaxStage)
    
    -- Check for changes
    local changed = false
    
    if leftStage ~= state.leftStage then
        log("Left crystal: Stage " .. state.leftStage .. " -> " .. leftStage)
        state.leftStage = leftStage
        changed = true
    end
    
    if rightStage ~= state.rightStage then
        log("Right crystal: Stage " .. state.rightStage .. " -> " .. rightStage)
        state.rightStage = rightStage
        changed = true
    end
    
    if mainStage ~= state.mainStage then
        log("Main block: Stage " .. state.mainStage .. " -> " .. mainStage)
        state.mainStage = mainStage
        changed = true
    end
    
    return changed
end

-- Main monitoring loop
local function main()
    term.clear()
    log("Starting Certus Quartz Farm Monitor...")
    log("Monitoring sides - Left: " .. config.leftSide .. ", Right: " .. config.rightSide .. ", Main: " .. config.mainSide)
    
    -- Initial display
    updateDisplay()
    
    while true do
        -- Check for growth changes
        local changed = checkGrowth()
        
        -- Update display if something changed or periodically
        if changed or (os.epoch("utc") - state.lastUpdate) > 5000 then
            updateDisplay()
            state.lastUpdate = os.epoch("utc")
        end
        
        -- Wait before next check
        sleep(config.checkInterval)
    end
end

-- Error handling wrapper
local success, error = pcall(main)

if not success then
    term.clear()
    term.setCursorPos(1, 1)
    print("Error occurred:")
    print(error)
    print("")
    print("Please check your configuration")
    print("and redstone connections.")
end
