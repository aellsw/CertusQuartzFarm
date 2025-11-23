-- Certus Quartz Farm Installer
-- Run this script on your CC:Tweaked computer to download and install the farm monitor

local GITHUB_RAW = "https://raw.githubusercontent.com/aellsw/CertusQuartzFarm/main/"
local FILES = {
    "config.lua",
    "main.lua"
}

-- Function to download a file from GitHub
local function downloadFile(filename)
    print("Downloading " .. filename .. "...")
    
    local url = GITHUB_RAW .. filename
    local response = http.get(url)
    
    if not response then
        error("Failed to download " .. filename .. " from GitHub")
    end
    
    local content = response.readAll()
    response.close()
    
    -- Write to file
    local file = fs.open(filename, "w")
    file.write(content)
    file.close()
    
    print("✓ Downloaded " .. filename)
end

-- Function to backup existing files
local function backupFiles()
    for _, filename in ipairs(FILES) do
        if fs.exists(filename) then
            local backupName = filename .. ".backup"
            print("Backing up existing " .. filename .. " to " .. backupName)
            fs.copy(filename, backupName)
        end
    end
end

-- Main installation function
local function install()
    print("===================================")
    print(" Certus Quartz Farm Installer")
    print("===================================")
    print("")
    
    -- Check for HTTP API
    if not http then
        print("ERROR: HTTP API is not enabled!")
        print("Please enable it in the CC:Tweaked config.")
        return
    end
    
    print("This will download the farm monitor files from GitHub.")
    print("Press Y to continue, any other key to cancel.")
    
    local event, key = os.pullEvent("key")
    if key ~= keys.y then
        print("Installation cancelled.")
        return
    end
    
    print("")
    
    -- Backup existing files
    backupFiles()
    
    print("")
    print("Downloading files from GitHub...")
    print("")
    
    -- Download all files
    local success = true
    for _, filename in ipairs(FILES) do
        local ok, err = pcall(downloadFile, filename)
        if not ok then
            print("ERROR: " .. err)
            success = false
            break
        end
    end
    
    print("")
    
    if success then
        print("===================================")
        print(" Installation Complete!")
        print("===================================")
        print("")
        print("Files installed:")
        for _, filename in ipairs(FILES) do
            print("  • " .. filename)
        end
        print("")
        print("Next steps:")
        print("1. Edit config.lua to match your setup")
        print("2. Run: main.lua")
        print("")
        print("To start the farm monitor, type:")
        print("  main")
    else
        print("===================================")
        print(" Installation Failed")
        print("===================================")
        print("")
        print("Please check your internet connection")
        print("and try again.")
    end
end

-- Run installer
local success, error = pcall(install)

if not success then
    print("")
    print("Installation error:")
    print(error)
end
