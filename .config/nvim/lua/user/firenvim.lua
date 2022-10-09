-- Sites to not load firenvim on
local blacklist = {
    "https://mlochbaum.github.io/BQN/try.html",
    "https://bqnpad.mechanize.systems/",
    "https://*.fandom.com/*",
    "https://www.desmos.com",
    "https://www.codewars.com",
}

-- Default recommended settings
-- expept localSettings is empty due to problematic key names (".*")
local firenvim_config = {
    globalSettings = { alt = "all" },
    localSettings = {}
}

-- Take a reference to localSettings
local fc = firenvim_config.localSettings

-- Add every blacklisted site name with `selector` set to ""
for k, site in pairs(blacklist) do
    fc[site] = { selector = "" }
end

-- Set a global vim variable with the new config
vim.g.firenvim_config = firenvim_config
