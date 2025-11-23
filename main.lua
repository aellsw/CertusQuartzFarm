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
        term.setCursorPos(1, 18)
        term.clearLine()
        write("[" .. timestamp .. "] " .. message)
    end
end

-- Function to update display
local function updateDisplay()
    if not config.displayUpdates then
        return
    end
    
    term.setCursorPos(1, 1)
    
    term.clearLine()
    print("============================")
    term.clearLine()
    print(" Certus Quartz Farm Monitor")
    term.clearLine()
    print("============================")
    term.clearLine()
    print("")
    term.clearLine()
    print("Left Crystal:  Stage " .. state.leftStage .. "/" .. config.crystalMaxStage)
    term.clearLine()
    print("Right Crystal: Stage " .. state.rightStage .. "/" .. config.crystalMaxStage)
    term.clearLine()
    print("Main Block:    Stage " .. state.mainStage .. "/" .. config.mainMaxStage)
    term.clearLine()
    print("")
    term.clearLine()
    print("----------------------------")
    term.clearLine()
    print("Press Ctrl+T to exit")
    term.clearLine()
    print("----------------------------")
    
    -- Visual progress bars
    term.clearLine()
    print("")
    term.clearLine()
    print("Left:  " .. string.rep("#", state.leftStage) .. string.rep("-", config.crystalMaxStage - state.leftStage))
    term.clearLine()
    print("Right: " .. string.rep("#", state.rightStage) .. string.rep("-", config.crystalMaxStage - state.rightStage))
    term.clearLine()
    print("Main:  " .. string.rep("#", state.mainStage) .. string.rep("-", config.mainMaxStage - state.mainStage))
end

-- Function to handle redstone events (observer pulses)
local function handleRedstoneChange(side)
    local changed = false
    
    if side == config.leftSide then
        state.leftStage = state.leftStage + 1
        if state.leftStage > config.crystalMaxStage then
            state.leftStage = config.crystalMaxStage
        end
        log("Left crystal grew to stage " .. state.leftStage)
        changed = true
    elseif side == config.rightSide then
        state.rightStage = state.rightStage + 1
        if state.rightStage > config.crystalMaxStage then
            state.rightStage = config.crystalMaxStage
        end
        log("Right crystal grew to stage " .. state.rightStage)
        changed = true
    elseif side == config.mainSide then
        state.mainStage = state.mainStage + 1
        if state.mainStage > config.mainMaxStage then
            state.mainStage = config.mainMaxStage
        end
        log("Main block grew to stage " .. state.mainStage)
        changed = true
    end
    
    return changed
end

-- Main monitoring loop
local function main()
    term.clear()
    
    -- Initial display
    updateDisplay()
    
    term.setCursorPos(1, 17)
    write("Waiting for observer pulses...")
    
    while true do
        -- Wait for redstone event (observer pulse)
        local event, side = os.pullEvent("redstone")
        
        -- Check if this side has an observer
        local changed = handleRedstoneChange(side)
        
        -- Update display if something changed
        if changed then
            updateDisplay()
        end
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
