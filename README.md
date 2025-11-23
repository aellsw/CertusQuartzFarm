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
- A CC:Tweaked computer with redstone connectivity

## Installation

### Quick Install (On CC:Tweaked Computer)

1. Run this command on your CC:Tweaked computer:
   ```lua
   pastebin run <code>
   ```
   Or download the installer:
   ```lua
   wget https://raw.githubusercontent.com/aellsw/CertusQuartzFarm/main/install.lua install.lua
   install
   ```

2. The installer will download all necessary files automatically

### Manual Install

1. Download `config.lua` and `main.lua` from this repository
2. Place them on your CC:Tweaked computer
3. Edit `config.lua` to match your setup

## Configuration

Edit `config.lua` to customize your farm:

```lua
-- Redstone sides for observers
config.leftSide = "left"      -- Side for left crystal observer
config.rightSide = "right"    -- Side for right crystal observer
config.mainSide = "back"      -- Side for main certus quartz block observer

-- Growth stages
config.crystalMaxStage = 4    -- Max growth stage for left/right crystals
config.mainMaxStage = 3       -- Max growth stage for main certus block

-- Detection settings
config.checkInterval = 1      -- How often to check (in seconds)
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

The program monitors redstone signals from observers watching your Certus Quartz crystals. As the crystals grow through different stages, the observers output redstone signals that the program detects and displays.

## Troubleshooting

- **No detection**: Check that your redstone connections match the configured sides in `config.lua`
- **Wrong stages**: Adjust the `thresholds` values in `config.lua` based on your observer signal strengths
- **HTTP errors**: Make sure HTTP is enabled in CC:Tweaked config

## License

MIT License - Feel free to modify and distribute
