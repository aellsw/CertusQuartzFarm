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

-- Function to empty inventory into chest
local function emptyInventory()
    -- Try to find and drop into chest on any side
    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            turtle.select(slot)
            
            -- Try each direction to find a chest
            if not turtle.drop() then      -- front
                if not turtle.dropUp() then    -- up
                    if not turtle.dropDown() then  -- down
                        turtle.turnLeft()
                        if not turtle.drop() then  -- left side
                            turtle.turnRight()
                            turtle.turnRight()
                            if not turtle.drop() then  -- right side
                                turtle.turnLeft()  -- face forward again
                                print("Warning: No chest found for slot " .. slot)
                            else
                                turtle.turnLeft()  -- face forward again
                            end
                        else
                            turtle.turnRight()  -- face forward again
                        end
                    end
                end
            end
        end
    end
    turtle.select(1)  -- Reset to slot 1
end

-- Function to break block above
local function breakBlockAbove()
    print("Breaking block above...")
    
    -- Try to dig up (block above) - automatically collects items
    local success, reason = turtle.digUp()
    
    if success then
        print("Successfully broke block!")
        
        -- Small delay to ensure items are collected
        sleep(0.1)
        
        -- Try to suck up any items that might have spawned above
        turtle.suckUp()
        
        -- Empty inventory into hopper below
        emptyInventory()
        print("Emptied inventory into hopper")
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
