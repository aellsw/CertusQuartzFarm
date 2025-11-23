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

-- Function to empty inventory into hopper behind
local function emptyInventory()
    -- Get the turtle's own inventory peripheral name
    local turtleName = peripheral.getName(turtle)
    
    -- Wrap the hopper behind the turtle
    local hopper = peripheral.wrap("back")
    
    if not hopper then
        print("Warning: No hopper found behind turtle")
        return false
    end
    
    -- Push all items from turtle into hopper inventory
    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            -- Use hopper.pullItems to pull from turtle into hopper
            local pulled = hopper.pullItems(turtleName, slot)
            if pulled == 0 then
                print("Warning: Could not transfer slot " .. slot)
            end
        end
    end
    
    turtle.select(1)  -- Reset to slot 1
    return true
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
