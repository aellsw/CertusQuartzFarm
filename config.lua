-- Certus Quartz Farm Configuration
-- Edit these values to customize your farm setup

local config = {}

-- Redstone sides for observers
config.leftSide = "left"      -- Side for left crystal observer
config.rightSide = "right"    -- Side for right crystal observer
config.mainSide = "back"      -- Side for main certus quartz block observer

-- Growth stages
config.crystalMaxStage = 4    -- Max growth stage for left/right crystals (1-4)
config.mainMaxStage = 3       -- Max growth stage for main certus block (1-3)

-- Detection settings
config.checkInterval = 1      -- How often to check (in seconds)
config.enableLogging = true   -- Enable detailed logging
config.displayUpdates = true  -- Show growth stage updates on screen

-- Redstone signal strength thresholds (adjust if needed)
-- Different growth stages may output different signal strengths
config.thresholds = {
    stage1 = 1,
    stage2 = 5,
    stage3 = 10,
    stage4 = 15
}

return config
