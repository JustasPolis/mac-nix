-- Define a function to create a new space
local function createNewSpace()
	local currentScreen = hs.screen.mainScreen()
	hs.spaces.addSpaceToScreen(currentScreen, true)
end

-- Bind a hotkey to create a new space
hs.hotkey.bind({ "ctrl" }, "Q", function()
	createNewSpace()
end)

hs.hotkey.bind({ "ctrl" }, "W", function()
	local spaces = hs.spaces.missionControlSpaceNames(true)
	hs.spaces.gotoSpace(165)
end)

local app = "com.apple.dt.Xcode"

-- Function to focus on a window with a specific application ID
local function focusAppWindow()
	local appWindows = hs.window.filter.new(false):setAppFilter("kitty", {}):getWindows()
	if #appWindows > 0 then
		appWindows[1]:focus()
	else
		print("No windows found for application with ID: " .. app)
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
