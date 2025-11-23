-- Certus Quartz Farm Turtle
-- Listens for wireless commands and breaks blocks above

-- Configuration
local MY_ID = os.getComputerID()
local MODEM_SIDE = "back"  -- Side where wireless modem is attached

-- Wrap the wireless modem
local modem = peripheral.find("modem")
if not modem then
    error("No modem found! Please attach a wireless modem.")
end

-- Open communication channel
modem.open(1)

-- Function to break block above
local function breakBlockAbove()
    print("Breaking block above...")
    
    -- Try to dig up (block above)
    local success, reason = turtle.digUp()
    
    if success then
        print("Successfully broke block!")
    else
        print("Failed to break: " .. (reason or "unknown"))
    end
    
    return success
end

-- Function to update display
local function updateDisplay()
    term.clear()
    term.setCursorPos(1, 1)
    print("===========================")
    print(" Certus Farm Turtle #" .. MY_ID)
    print("===========================")
    print("")
    print("Status: Waiting for commands")
    print("")
    print("Listening on channel 1")
    print("")
    print("---------------------------")
    print("Press Ctrl+T to exit")
end

-- Main loop
local function main()
    updateDisplay()
    
    print("")
    print("Ready and listening...")
    
    while true do
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        
        -- Check if message is for this turtle
        if type(message) == "table" and message.command == "break" then
            if message.id == MY_ID then
                print("")
                print("Received break command!")
                breakBlockAbove()
                print("Waiting for next command...")
            end
        end
    end
end

-- Error handling
local success, error = pcall(main)

if not success then
    term.clear()
    term.setCursorPos(1, 1)
    print("Error occurred:")
    print(error)
    print("")
    print("Check modem connection")
end
