# Quick Setup Guide

## For Your CC:Tweaked Computer

### Installation Command

Run this on your CC:Tweaked computer to install:

```lua
wget https://raw.githubusercontent.com/aellsw/CertusQuartzFarm/main/install.lua install.lua
install
```

### Configuration Steps

1. After installation, edit the config:
   ```
   edit config.lua
   ```

2. Update these settings to match your setup:
   - `config.leftSide` - Which side has the left crystal observer (e.g., "left", "right", "top", "bottom", "front", "back")
   - `config.rightSide` - Which side has the right crystal observer
   - `config.mainSide` - Which side has the main block observer

3. Save the file (Ctrl to bring up menu, then save and exit)

### Running the Monitor

Simply type:
```
main
```

Press `Ctrl+T` to exit the monitor.

## Physical Setup

1. Place observers facing your Certus Quartz crystals
2. Connect the observers to your CC:Tweaked computer with redstone
3. Make sure the redstone connects to the sides you configured

## Troubleshooting

- **Not detecting stages?** 
  - Check your redstone connections
  - Verify the sides in `config.lua` match your physical setup
  - Try adjusting the `thresholds` values in config.lua

- **Stages showing incorrectly?**
  - The thresholds may need adjustment for your specific setup
  - Edit config.lua and change the threshold values
  - Observers may output different signal strengths

## What the Program Does

- Monitors redstone input from 3 observers
- Displays current growth stage for each crystal
- Shows visual progress bars
- Logs stage changes with timestamps
- Updates in real-time (configurable interval)

The program currently only monitors - you mentioned not worrying about breaking the crystals yet, so that functionality isn't included.
