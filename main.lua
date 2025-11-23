-- Certus Quartz Farm Monitor
-- Monitors crystal growth stages using CC:Tweaked and redstone relay

-- Load configuration
local config = require("config")

-- Wrap the redstone relay peripheral
local relay = peripheral.wrap(config.relayName)
if not relay then
    error("Could not wrap relay: " .. config.relayName)
end

-- State tracking
local state = {
    leftStage = 0,
    rightStage = 0,
    mainStage = 0
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

-- Function to clamp values
local function clamp(n, max)
    return math.min(max, math.max(0, n))
end

-- Function to handle redstone events (observer pulses)
local function handleRedstoneChange()
    local changed = false
    
    -- Check relay inputs for pulses
    local leftSig = relay.getInput(config.leftSide)
    local rightSig = relay.getInput(config.rightSide)
    local mainSig = relay.getInput(config.mainSide)
    
    -- Left crystal
    if leftSig then
        state.leftStage = clamp(state.leftStage + 1, config.crystalMaxStage)
        log("Left crystal: Stage " .. state.leftStage)
        changed = true
    end
    
    -- Right crystal
    if rightSig then
        state.rightStage = clamp(state.rightStage + 1, config.crystalMaxStage)
        log("Right crystal: Stage " .. state.rightStage)
        changed = true
    end
    
    -- Main block
    if mainSig then
        state.mainStage = clamp(state.mainStage + 1, config.mainMaxStage)
        log("Main block: Stage " .. state.mainStage)
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
    write("Monitoring relay: " .. config.relayName)
    
    while true do
        -- Wait for redstone event (observer pulse)
        local event = os.pullEvent("redstone")
        
        -- Check relay inputs
        local changed = handleRedstoneChange()
        
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
