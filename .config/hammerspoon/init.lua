local function pressFn(mods, key)
	if key == nil then
		key = mods
		mods = {}
	end

	return function()
		hs.eventtap.keyStroke(mods, key, 1000)
	end
end

local function remap(mods, key, pressFn)
	hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
end

remap({ "ctrl" }, "n", pressFn("down"))
remap({ "ctrl" }, "p", pressFn("up"))
remap({ "ctrl", "shift" }, "n", pressFn("right"))
remap({ "ctrl", "shift" }, "p", pressFn("left"))

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
			hs.application.launchOrFocus("/System/Volumes/Data/Applications/Xcode-15.2.0.app/")
		end,
	},
	[singleKey("f", "focus")] = {
		[singleKey("l", "right")] = function()
			yabai({ "window --focus east" })
		end,
		[singleKey("h", "left")] = function()
			yabai({ "window --focus west" })
		end,
		[singleKey("k", "top")] = function()
			yabai({ "window --focus north" })
		end,
		[singleKey("j", "bottom")] = function()
			yabai({ "window --focus south" })
		end,
		[singleKey("n", "next")] = function()
			local xcode = hs.application.get("Xcode")
			hs.eventtap.keyStroke({ "alt", "cmd" }, "`", 200, xcode)
		end,
	},
	[singleKey("x", "xcode")] = {
		[singleKey("f", "focus")] = {
			[singleKey("n", "next")] = function()
				local xcode = hs.application.get("Xcode")
				hs.eventtap.keyStroke({ "alt", "cmd" }, "`", 200, xcode)
			end,
		},
		[singleKey("g", "goto")] = {
			[singleKey("d", "jump to definition")] = function()
				hs.eventtap.keyStroke({ "ctrl", "cmd" }, "J")
			end,
			[singleKey("b", "go back")] = function()
				hs.eventtap.keyStroke({ "ctrl", "cmd" }, "left")
			end,
		},
		[singleKey("t", "toggle")] = {
			[singleKey("d", "debug")] = function()
				hs.eventtap.keyStroke({ "shift", "cmd" }, "Y")
			end,
			[singleKey("n", "navigator")] = function()
				hs.eventtap.keyStroke({ "alt", "shift" }, "B")
			end,
		},
		[singleKey("n", "navigator")] = {
			[singleKey("p", "projects")] = function()
				local xcode = hs.application.get("Xcode")
				hs.eventtap.keyStroke({ "cmd" }, "1", 200, xcode)
			end,
		},
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
