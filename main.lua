-- Certus Quartz Farm Monitor
-- Monitors crystal growth stages using CC:Tweaked and redstone relay

-- Load configuration
local config = require("config")

-- Wrap the redstone relay peripheral
local relay = peripheral.wrap(config.relayName)
if not relay then
    error("Could not wrap relay: " .. config.relayName)
end

-- Wrap the wireless modem
local modem = peripheral.wrap(config.modemSide)
if not modem then
    error("Could not wrap modem on side: " .. config.modemSide)
end
modem.open(1)  -- Open channel 1 for communication

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

-- Function to send break command to turtle
local function breakTurtle(turtleID, crystalName)
    modem.transmit(1, 1, {command = "break", id = turtleID})
    log(crystalName .. " turtle breaking...")
end

-- Function to break all crystals
local function breakAll()
    log("Breaking sides first...")
    -- Break left and right simultaneously
    breakTurtle(config.leftTurtleID, "Left")
    breakTurtle(config.rightTurtleID, "Right")
    
    -- Wait a moment, then break main
    sleep(config.mainBreakDelay)
    breakTurtle(config.mainTurtleID, "Main")
    
    -- Reset stages
    state.leftStage = 0
    state.rightStage = 0
    state.mainStage = 0
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
        
        -- Break if max stage reached
        if state.leftStage == config.crystalMaxStage then
            breakTurtle(config.leftTurtleID, "Left")
            state.leftStage = 0
        end
    end
    
    -- Right crystal
    if rightSig then
        state.rightStage = clamp(state.rightStage + 1, config.crystalMaxStage)
        log("Right crystal: Stage " .. state.rightStage)
        changed = true
        
        -- Break if max stage reached
        if state.rightStage == config.crystalMaxStage then
            breakTurtle(config.rightTurtleID, "Right")
            state.rightStage = 0
        end
    end
    
    -- Main block
    if mainSig then
        state.mainStage = clamp(state.mainStage + 1, config.mainMaxStage)
        log("Main block: Stage " .. state.mainStage)
        changed = true
        
        -- Break if max stage reached
        if state.mainStage == config.mainMaxStage then
            breakTurtle(config.mainTurtleID, "Main")
            state.mainStage = 0
        end
    end
    
    return changed
end

-- Main monitoring loop
local function main()
    term.clear()
    
    -- Initial display
    updateDisplay()
    
    term.setCursorPos(1, 17)
    write("Starting up...")
    
    -- Startup: Break all crystals to sync state
    print("")
    print("Breaking all to sync state...")
    sleep(0.5)  -- Give relays time to initialize
    
    -- Break left and right first (in case they're full)
    log("Breaking side crystals...")
    breakTurtle(config.leftTurtleID, "Left")
    breakTurtle(config.rightTurtleID, "Right")
    sleep(config.mainBreakDelay)
    
    -- Then break main
    log("Breaking main block...")
    breakTurtle(config.mainTurtleID, "Main")
    sleep(0.5)  -- Wait for breaks to complete
    
    -- Reset all stages
    state.leftStage = 0
    state.rightStage = 0
    state.mainStage = 0
    
    updateDisplay()
    term.setCursorPos(1, 17)
    write("Monitoring relay: " .. config.relayName)
    print("")
    log("Startup complete - monitoring...")
    
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
