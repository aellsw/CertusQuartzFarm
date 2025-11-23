-- Certus Quartz Farm Configuration
-- Edit these values to customize your farm setup

local config = {}

-- Redstone relay peripheral
config.relayName = "redstone_relay_8"  -- Name of the redstone relay peripheral

-- Relay input sides for observers
config.leftSide = "left"      -- Relay side for left crystal observer
config.rightSide = "right"    -- Relay side for right crystal observer
config.mainSide = "top"       -- Relay side for main certus quartz block observer

-- Growth stages
config.crystalMaxStage = 4    -- Max growth stage for left/right crystals (1-4)
config.mainMaxStage = 3       -- Max growth stage for main certus block (1-3)

-- Wireless modem settings
config.modemSide = "back"     -- Side where wireless modem is attached
config.leftTurtleID = 7       -- Computer ID of left turtle
config.rightTurtleID = 5      -- Computer ID of right turtle  
config.mainTurtleID = 6       -- Computer ID of main block turtle

-- Breaking settings
config.mainBreakDelay = 0.5   -- Delay before breaking main (let sides break first)

-- Detection settings
config.enableLogging = true   -- Enable detailed logging
config.displayUpdates = true  -- Show growth stage updates on screen

return config
