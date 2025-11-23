-- Certus Quartz Farm Turtle Installer
-- Run this on each turtle to set it up

local GITHUB_RAW = "https://raw.githubusercontent.com/aellsw/CertusQuartzFarm/main/"

print("===================================")
print(" Certus Farm Turtle Installer")
print("===================================")
print("")
print("This turtle ID: " .. os.getComputerID())
print("")

-- Check for HTTP API
if not http then
    print("ERROR: HTTP API is not enabled!")
    print("Enable it in CC:Tweaked config.")
    return
end

-- Check if this is actually a turtle
if not turtle then
    print("ERROR: This is not a turtle!")
    print("Run install.lua on the computer instead.")
    return
end

print("Downloading turtle.lua...")
print("")

local url = GITHUB_RAW .. "turtle.lua"
local response = http.get(url)

if not response then
    print("ERROR: Failed to download from GitHub")
    print("Check your internet connection")
    return
end

local content = response.readAll()
response.close()

-- Save to startup.lua so it runs on boot
local file = fs.open("startup.lua", "w")
file.write(content)
file.close()

print("✓ Downloaded and saved as startup.lua")
print("")
print("===================================")
print(" Installation Complete!")
print("===================================")
print("")
print("The turtle will automatically start")
print("listening for break commands on boot.")
print("")
print("Reboot now? (Y/N)")

local event, key = os.pullEvent("key")
if key == keys.y then
    print("")
    print("Rebooting...")
    sleep(1)
    os.reboot()
else
    print("")
    print("To start manually, run: startup")
    print("Or reboot the turtle.")
end
