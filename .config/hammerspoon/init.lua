local function createNewSpace()
	local currentScreen = hs.screen.mainScreen()
	hs.spaces.addSpaceToScreen(currentScreen, true)
end

-- hs.hotkey.bind({ "ctrl" }, "W", function()
--   local spaces = hs.spaces.missionControlSpaceNames(true)
--   hs.spaces.gotoSpace(165)
-- end)

-- Function to focus on a window with a specific application ID
-- local function focusAppWindow()
--   local appWindows = hs.window.filter.new(false):setAppFilter("kitty", {}):getWindows()
--   if #appWindows > 0 then
--     appWindows[1]:focus()
--   else
--     print("No windows found for application with ID: " .. app)
--   end
-- end

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

spaceItem:setTitle("Space:" .. hs.spaces.focusedSpace())

hs.spaces.watcher
	.new(function(s)
		local spaces = hs.spaces.allSpaces()
		local uuid = hs.screen.mainScreen():getUUID()
		local spaceIDs = spaces[uuid]
		for i, v in ipairs(spaceIDs) do
			print(i, v)
			if v == hs.spaces.focusedSpace() then
				spaceItem:setTitle("Space:" .. i)
			end
		end
	end)
	:start()
