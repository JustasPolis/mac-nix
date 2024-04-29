local function createNewSpace()
	local currentScreen = hs.screen.mainScreen()
	hs.spaces.addSpaceToScreen(currentScreen, true)
end

local function yabai(commands)
	for _, cmd in ipairs(commands) do
		os.execute("/opt/homebrew/bin/yabai -m " .. cmd)
	end
end

hs.loadSpoon("RecursiveBinder")

spoon.RecursiveBinder.escapeKey = { {}, "escape" } -- Press escape to abort
spoon.RecursiveBinder.showBindHelper = false

local singleKey = spoon.RecursiveBinder.singleKey

local keyMap = {
	[singleKey("r", "reload")] = function()
		hs:reload()
	end,
	[singleKey("m", "move")] = {
		[singleKey("e", "empty")] = function()
			createNewSpace()
			local focusedWindow = hs.window.focusedWindow()
			local spaces = hs.spaces.allSpaces()
			local uuid = focusedWindow:screen():getUUID() -- uuid for current screen
			local spaceIDs = spaces[uuid]
			yabai({ "window --space " .. #spaceIDs })
		end,
		[singleKey("1", "empty")] = function()
			yabai({ "window --space 1" })
		end,
		[singleKey("2", "empty")] = function()
			yabai({ "window --space 2" })
		end,
		[singleKey("3", "empty")] = function()
			yabai({ "window --space 3" })
		end,
		[singleKey("4", "empty")] = function()
			yabai({ "window --space 4" })
		end,
		[singleKey("5", "empty")] = function()
			yabai({ "window --space 5" })
		end,
		[singleKey("6", "empty")] = function()
			yabai({ "window --space 6" })
		end,
		[singleKey("7", "empty")] = function()
			yabai({ "window --space 7" })
		end,
	},
	[singleKey("a", "apps")] = {
		[singleKey("t", "terminal")] = function()
			hs.application.launchOrFocus("kitty")
		end,
		[singleKey("b", "browser")] = function()
			hs.application.launchOrFocus("Arc")
		end,
		[singleKey("x", "xcode")] = function()
			hs.application.launchOrFocus("Xcode-15.2.0")
		end,
	},
}

hs.hotkey.bind({}, "F18", spoon.RecursiveBinder.recursiveBind(keyMap))

local spaceItem = hs.menubar.new(true, "spaceItem")

local spaces = hs.spaces.allSpaces()
local uuid = hs.screen.mainScreen():getUUID()
local spaceIDs = spaces[uuid]
for i, v in ipairs(spaceIDs) do
	if v == hs.spaces.focusedSpace() then
		spaceItem:setTitle("Space:" .. i)
	end
end

hs.spaces.watcher
	.new(function(s)
		local spaces = hs.spaces.allSpaces()
		local uuid = hs.screen.mainScreen():getUUID()
		local spaceIDs = spaces[uuid]
		for i, v in ipairs(spaceIDs) do
			if v == hs.spaces.focusedSpace() then
				spaceItem:setTitle("Space:" .. i)
			end
		end
	end)
	:start()
