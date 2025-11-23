# Certus Quartz Farm Monitor

A CC:Tweaked program for monitoring Certus Quartz crystal growth in Applied Energistics 2 (Minecraft 1.20.1).

## Features

- Monitors 3 observers via redstone:
  - Left crystal (4 growth stages)
  - Right crystal (4 growth stages)  
  - Main certus quartz block (3 growth stages)
- Real-time visual display with progress bars
- Configurable via `config.lua`
- Easy installation from GitHub

## Requirements

- Minecraft 1.20.1
- Applied Energistics 2 mod
- CC:Tweaked mod
- A CC:Tweaked computer with:
  - Redstone Relay #8 for observers
  - Wireless modem (on back)
- 3 Mining Turtles with wireless modems:
  - Turtle #5 (right crystal)
  - Turtle #6 (main block)
  - Turtle #7 (left crystal)

## Installation

### Computer Setup

1. Run this on your CC:Tweaked computer:
   ```lua
   wget https://raw.githubusercontent.com/aellsw/CertusQuartzFarm/main/install.lua install.lua
   install
   ```

2. Edit `config.lua` if your turtle IDs are different

3. Run the monitor:
   ```lua
   main
   ```

### Turtle Setup

Run this on **each** of your 3 mining turtles:

```lua
wget https://raw.githubusercontent.com/aellsw/CertusQuartzFarm/main/install-turtle.lua install-turtle.lua
install-turtle
```

The turtle will automatically start listening for break commands on reboot.

### Manual Install

1. Download `config.lua` and `main.lua` from this repository
2. Place them on your CC:Tweaked computer
3. Edit `config.lua` to match your setup

## Configuration

Edit `config.lua` to customize your farm:

```lua
-- Redstone relay
config.relayName = "redstone_relay_8"

-- Relay input sides
config.leftSide = "left"
config.rightSide = "right"
config.mainSide = "top"

-- Turtle IDs
config.leftTurtleID = 7
config.rightTurtleID = 5
config.mainTurtleID = 6

-- Growth stages
config.crystalMaxStage = 4    -- Left/right crystals
config.mainMaxStage = 3       -- Main block
```

## Usage

1. Connect your observers to the CC:Tweaked computer via redstone
2. Configure the sides in `config.lua`
3. Run the program:
   ```
   main
   ```
4. Press `Ctrl+T` to exit

## How It Works

1. Observers detect crystal growth and pulse the redstone relay
2. The computer counts pulses to track growth stages
3. When crystals reach max stage:
   - Computer sends wireless command to corresponding turtle
   - Turtle breaks the crystal/block above it
   - Stage counter resets and growth starts again

## Troubleshooting

- **No detection**: Check that your redstone connections match the configured sides in `config.lua`
- **Wrong stages**: Adjust the `thresholds` values in `config.lua` based on your observer signal strengths
- **HTTP errors**: Make sure HTTP is enabled in CC:Tweaked config

## License

MIT License - Feel free to modify and distribute
