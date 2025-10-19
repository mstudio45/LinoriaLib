-- New example script written by wally
-- You can suggest changes with a pull request or something

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)
Library.ShowCustomCursor = true -- Toggles the Linoria cursor globaly (Default value = true)
Library.NotifySide = "Left" -- Changes the side of the notifications globaly (Left, Right) (Default value = Left)

local Window = Library:CreateWindow({
	-- Set Center to true if you want the menu to appear in the center
	-- Set AutoShow to true if you want the menu to appear when it is created
	-- Set Resizable to true if you want to have in-game resizable Window
	-- Set ShowCustomCursor to false if you don't want to use the Linoria cursor
	-- Set UnlockMouseWhileOpen to false if you don't want to unlock the mouse when the UI is toggled
	-- NotifySide = Changes the side of the notifications (Left, Right) (Default value = Left)
	-- Position and Size are also valid options here
	-- but you do not need to define them unless you are changing them :)

	Title = 'Example menu',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	UnlockMouseWhileOpen = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

-- You do not have to set your tabs & groups up this way, just a prefrence.
local Tabs = {
	-- Creates a new tab titled Main
	Main = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Groupbox')

-- We can also get our Main tab via the following code:
-- local LeftGroupBox = Window.Tabs.Main:AddLeftGroupbox('Groupbox')

-- Tabboxes are a tiny bit different, but here's a basic example:
--[[

local TabBox = Tabs.Main:AddLeftTabbox() -- Add Tabbox on left side

local Tab1 = TabBox:AddTab('Tab 1')
local Tab2 = TabBox:AddTab('Tab 2')

-- You can now call AddToggle, etc on the tabs you added to the Tabbox
]]

-- Groupbox:AddToggle
-- Arguments: Index, Options
LeftGroupBox:AddToggle('MyToggle', {
	Text = 'This is a toggle',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the toggle while it's disabled

	Default = true, -- Default value (true / false)
	Disabled = false, -- Will disable the toggle (true / false)
	Visible = true, -- Will make the toggle invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)

	Callback = function(Value)
		print('[cb] MyToggle changed to:', Value)
	end
}):AddColorPicker('ColorPicker1', {
	Default = Color3.new(1, 0, 0),
	Title = 'Some color1', -- Optional. Allows you to have a custom color picker title (when you open it)
	Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

	Callback = function(Value, Transparency)
		print('[cb] Color changed!', Value, '| Transparency changed to:', Transparency)
	end
}):AddColorPicker('ColorPicker2', {
	Default = Color3.new(0, 1, 0),
	Title = 'Some color2',
	Transparency = 0,

	Callback = function(Value, Transparency)
		print('[cb] Color changed!', Value, '| Transparency changed to:', Transparency)
	end
}):AddColorPicker('ColorPicker3', {
	Default = Color3.new(0, 0, 1),
	Title = 'Some color3',
	Transparency = 0,

	Callback = function(Value, Transparency)
		print('[cb] Color changed!', Value, '| Transparency changed to:', Transparency)
	end
})


-- Fetching a toggle object for later use:
-- Toggles.MyToggle.Value

-- Toggles is a table added to getgenv() by the library
-- You index Toggles with the specified index, in this case it is 'MyToggle'
-- To get the state of the toggle you do toggle.Value

-- Calls the passed function when the toggle is updated
Toggles.MyToggle:OnChanged(function()
	-- here we get our toggle object & then get its value
	print('MyToggle changed to:', Toggles.MyToggle.Value)
end)

-- This should print to the console: "My toggle state changed! New value: false"
Toggles.MyToggle:SetValue(false)

-- 1/15/23
-- Deprecated old way of creating buttons in favor of using a table
-- Added DoubleClick button functionality

--[[
	Groupbox:AddButton
	Arguments: {
		Text = string,
		Func = function,
		DoubleClick = boolean
		Tooltip = string,
	}

	You can call :AddButton on a button to add a SubButton!
]]

local MyButton = LeftGroupBox:AddButton({
	Text = 'Button',
	Func = function()
		print('You clicked a button!')
		Library:Notify("This is a notification")
	end,
	DoubleClick = false,

	Tooltip = 'This is the main button',
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the button while it's disabled

	Disabled = false, -- Will disable the button (true / false)
	Visible = true -- Will make the button invisible (true / false)
})

local MyButton2 = MyButton:AddButton({
	Text = 'Sub button',
	Func = function()
		print('You clicked a sub button!')
		Library:Notify("This is a notification with sound", nil, 4590657391)
	end,
	DoubleClick = true, -- You will have to click this button twice to trigger the callback
	Tooltip = 'This is the sub button (double click me!)'
})

local MyDisabledButton = LeftGroupBox:AddButton({
	Text = 'Disabled Button',
	Func = function()
		print('You somehow clicked a disabled button!')
	end,
	DoubleClick = false,
	Tooltip = 'This is a disabled button',
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the button while it's disabled
	Disabled = true
})

--[[
	NOTE: You can chain the button methods!
	EXAMPLE:

	LeftGroupBox:AddButton({ Text = 'Kill all', Func = Functions.KillAll, Tooltip = 'This will kill everyone in the game!' })
		:AddButton({ Text = 'Kick all', Func = Functions.KickAll, Tooltip = 'This will kick everyone in the game!' })
]]



-- Groupbox:AddLabel
-- Arguments: Text, DoesWrap, Idx
-- Arguments: Idx, Options
LeftGroupBox:AddLabel('This is a label')
LeftGroupBox:AddLabel('This is a label\n\nwhich wraps its text!', true)
LeftGroupBox:AddLabel('This is a label exposed to Labels', true, 'TestLabel')
LeftGroupBox:AddLabel('SecondTestLabel', {
	Text = 'This is a label made with table options and an index',
	DoesWrap = true -- Defaults to false
})

LeftGroupBox:AddLabel('SecondTestLabel', {
	Text = 'This is a label that doesn\'t wrap it\'s own text',
	DoesWrap = false -- Defaults to false
})

-- Labels is a table inside Library that is added to getgenv()
-- You index Library.Labels with the specified index, in this case it is 'SecondTestLabel' & 'TestLabel'
-- To set the text of the label you do label:SetText

-- Library.Labels.TestLabel:SetText("first changed!")
-- Library.Labels.SecondTestLabel:SetText("second changed!")


-- Groupbox:AddDivider
-- Arguments: None
LeftGroupBox:AddDivider()

--[[
	Groupbox:AddSlider
	Arguments: Idx, SliderOptions

	SliderOptions: {
		Text = string,
		Default = number,
		Min = number,
		Max = number,
		Suffix = string,
		Rounding = number,
		Compact = boolean,
		HideMax = boolean,
	}

	Text, Default, Min, Max, Rounding must be specified.
	Suffix is optional.
	Rounding is the number of decimal places for precision.

	Compact will hide the title label of the Slider

	HideMax will only display the value instead of the value & max value of the slider
	Compact will do the same thing
]]
LeftGroupBox:AddSlider('MySlider', {
	Text = 'This is my slider!',
	Default = 0,
	Min = 0,
	Max = 5,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		print('[cb] MySlider was changed! New value:', Value)
	end,

	Tooltip = 'I am a slider!', -- Information shown when you hover over the slider
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the slider while it's disabled

	Disabled = false, -- Will disable the slider (true / false)
	Visible = true, -- Will make the slider invisible (true / false)
})

-- Options is a table added to getgenv() by the library
-- You index Options with the specified index, in this case it is 'MySlider'
-- To get the value of the slider you do slider.Value

local Number = Options.MySlider.Value
Options.MySlider:OnChanged(function()
	print('MySlider was changed! New value:', Options.MySlider.Value)
end)

-- This should print to the console: "MySlider was changed! New value: 3"
Options.MySlider:SetValue(3)

LeftGroupBox:AddSlider('MySlider2', {
	Text = 'This is my custom display slider!',
	Default = 0,
	Min = 0,
	Max = 5,
	Rounding = 1,
	Compact = false,

	FormatDisplayValue = function(slider, value)
		if value == slider.Max then return 'Everything' end
		if value == slider.Min then return 'Nothing' end
		-- If you return nil, the default formatting will be applied
	end,

	Tooltip = 'I am a slider!', -- Information shown when you hover over the slider
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the slider while it's disabled

	Disabled = false, -- Will disable the slider (true / false)
	Visible = true, -- Will make the slider invisible (true / false)
})

-- Groupbox:AddInput
-- Arguments: Idx, Info
LeftGroupBox:AddInput('MyTextbox', {
	Default = 'My textbox!',
	Numeric = false, -- true / false, only allows numbers
	Finished = false, -- true / false, only calls callback when you press enter
	ClearTextOnFocus = true, -- true / false, if false the text will not clear when textbox focused
		
	Text = 'This is a textbox',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the textbox

	Placeholder = 'Placeholder text', -- placeholder text when the box is empty
	-- MaxLength is also an option which is the max length of the text

	Callback = function(Value)
		print('[cb] Text updated. New text:', Value)
	end
})

Options.MyTextbox:OnChanged(function()
	print('Text updated. New text:', Options.MyTextbox.Value)
end)

-- Groupbox:AddDropdown
-- Arguments: Idx, Info

local DropdownGroupBox = Tabs.Main:AddRightGroupbox('Dropdowns')

DropdownGroupBox:AddDropdown('MyDropdown', {
	Values = { 'This', 'is', 'a', 'dropdown' },
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	Text = 'A dropdown',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the dropdown while it's disabled

	Searchable = false, -- true / false, makes the dropdown searchable (great for a long list of values)

	Callback = function(Value)
		print('[cb] Dropdown got changed. New value:', Value)
	end,

	Disabled = false, -- Will disable the dropdown (true / false)
	Visible = true, -- Will make the dropdown invisible (true / false)
})

Options.MyDropdown:OnChanged(function()
	print('Dropdown got changed. New value:', Options.MyDropdown.Value)
end)

Options.MyDropdown:SetValue('This')

DropdownGroupBox:AddDropdown('MySearchableDropdown', {
	Values = { 'This', 'is', 'a', 'searchable', 'dropdown' },
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	Text = 'A searchable dropdown',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the dropdown while it's disabled

	Searchable = true, -- true / false, makes the dropdown searchable (great for a long list of values)

	Callback = function(Value)
		print('[cb] Dropdown got changed. New value:', Value)
	end,

	Disabled = false, -- Will disable the dropdown (true / false)
	Visible = true, -- Will make the dropdown invisible (true / false)
})

DropdownGroupBox:AddDropdown('MyDisplayFormattedDropdown', {
	Values = { 'This', 'is', 'a', 'formatted', 'dropdown' },
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	Text = 'A display formatted dropdown',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the dropdown while it's disabled

	FormatDisplayValue = function(Value) -- You can change the display value for any values. The value will be still same, only the UI changes.
		if Value == 'formatted' then
			return 'display formatted' -- formatted -> display formatted but in Options.MyDisplayFormattedDropdown.Value it will still return formatted if its selected.
		end;

		return Value
	end,

	Searchable = false, -- true / false, makes the dropdown searchable (great for a long list of values)

	Callback = function(Value)
		print('[cb] Display formatted dropdown got changed. New value:', Value)
	end,

	Disabled = false, -- Will disable the dropdown (true / false)
	Visible = true, -- Will make the dropdown invisible (true / false)
})

-- Multi dropdowns
DropdownGroupBox:AddDropdown('MyMultiDropdown', {
	-- Default is the numeric index (e.g. "This" would be 1 since it if first in the values list)
	-- Default also accepts a string as well

	-- Currently you can not set multiple values with a dropdown

	Values = { 'This', 'is', 'a', 'dropdown' },
	Default = 1,
	Multi = true, -- true / false, allows multiple choices to be selected

	Text = 'A multi dropdown',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

	Callback = function(Value)
		print('[cb] Multi dropdown got changed:')
		for key, value in next, Options.MyMultiDropdown.Value do
			print(key, value) -- should print something like This, true
		end
	end
})

Options.MyMultiDropdown:SetValue({
	This = true,
	is = true,
})

DropdownGroupBox:AddDropdown('MyDisabledDropdown', {
    Values = { 'This', 'is', 'a', 'dropdown' },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'A disabled dropdown',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
    DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the dropdown while it's disabled

    Callback = function(Value)
        print('[cb] Disabled dropdown got changed. New value:', Value)
    end,

    Disabled = true, -- Will disable the dropdown (true / false)
    Visible = true, -- Will make the dropdown invisible (true / false)
})

DropdownGroupBox:AddDropdown('MyDisabledValueDropdown', {
    Values = { 'This', 'is', 'a', 'dropdown', 'with', 'disabled', 'value' },
    DisabledValues = { 'disabled' }, -- Disabled Values that are unclickable
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'A dropdown with disabled value',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
    DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the dropdown while it's disabled

    Callback = function(Value)
        print('[cb] Dropdown with disabled value got changed. New value:', Value)
    end,

    Disabled = false, -- Will disable the dropdown (true / false)
    Visible = true, -- Will make the dropdown invisible (true / false)
})

DropdownGroupBox:AddDropdown('MyVeryLongDropdown', {
	Values = { 'This', 'is', 'a', 'very', 'long', 'dropdown', 'with', 'a', 'lot', 'of', 'values', 'but', 'you', 'can', 'see', 'more', 'than', '8', 'values' },
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	MaxVisibleDropdownItems = 12, -- Default: 8, allows you to change the size of the dropdown list

	Text = 'A very long dropdown',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the dropdown while it's disabled

	Searchable = false, -- true / false, makes the dropdown searchable (great for a long list of values)

	Callback = function(Value)
		print('[cb] Very long dropdown got changed. New value:', Value)
	end,

	Disabled = false, -- Will disable the dropdown (true / false)
	Visible = true, -- Will make the dropdown invisible (true / false)
})

DropdownGroupBox:AddDropdown('MyPlayerDropdown', {
	SpecialType = 'Player',
	ExcludeLocalPlayer = true, -- true / false, excludes the localplayer from the Player type
	Text = 'A player dropdown',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

	Callback = function(Value)
		print('[cb] Player dropdown got changed:', Value)
	end
})

DropdownGroupBox:AddDropdown('MyTeamDropdown', {
	SpecialType = 'Team',
	Text = 'A team dropdown',
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

	Callback = function(Value)
		print('[cb] Team dropdown got changed:', Value)
	end
})

-- Label:AddColorPicker
-- Arguments: Idx, Info

-- You can also ColorPicker & KeyPicker to a Toggle as well

LeftGroupBox:AddLabel('Color'):AddColorPicker('ColorPicker', {
	Default = Color3.new(0, 1, 0), -- Bright green
	Title = 'Some color', -- Optional. Allows you to have a custom color picker title (when you open it)
	Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

	Callback = function(Value)
		print('[cb] Color changed!', Value)
	end
})

Options.ColorPicker:OnChanged(function()
	print('Color changed!', Options.ColorPicker.Value)
	print('Transparency changed!', Options.ColorPicker.Transparency)
end)

Options.ColorPicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

-- Label:AddKeyPicker
-- Arguments: Idx, Info

LeftGroupBox:AddLabel('Keybind'):AddKeyPicker('KeyPicker', {
	-- SyncToggleState only works with toggles.
	-- It allows you to make a keybind which has its state synced with its parent toggle

	-- Example: Keybind which you use to toggle flyhack, etc.
	-- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

	Default = 'MB2', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
	SyncToggleState = false,

	-- You can define custom Modes but I have never had a use for it.
	Mode = 'Toggle', -- Modes: Always, Toggle, Hold, Press (example down below)

	Text = 'Auto lockpick safes', -- Text to display in the keybind menu
	NoUI = false, -- Set to true if you want to hide from the Keybind menu,

	-- Occurs when the keybind is clicked, Value is `true`/`false`
	Callback = function(Value)
		print('[cb] Keybind clicked!', Value)
	end,

	-- Occurs when the keybind itself is changed, `NewKey` is a KeyCode Enum OR a UserInputType Enum, `NewModifiers` is a table with KeyCode Enum(s) or nil
	ChangedCallback = function(NewKey, NewModifiers)
		print("[cb] Keybind changed!", NewKey, table.unpack(NewModifiers or {}))
	end,
})

-- OnClick is only fired when you press the keybind and the mode is Toggle
-- Otherwise, you will have to use Keybind:GetState()
Options.KeyPicker:OnClick(function()
	print('Keybind clicked!', Options.KeyPicker:GetState())
end)

Options.KeyPicker:OnChanged(function()
	print("Keybind changed!", Options.KeyPicker.Value, table.unpack(Options.KeyPicker.Modifiers or {}))
end)

task.spawn(function()
	while task.wait(1) do
		-- example for checking if a keybind is being pressed
		local state = Options.KeyPicker:GetState()
		if state then
			print('KeyPicker is being held down')
		end

		if Library.Unloaded then break end
	end
end)

Options.KeyPicker:SetValue({ 'MB2', 'Hold' }) -- Sets keybind to MB2, mode to Hold

-- Label:KeyPicker (Press Mode)

local KeybindNumber = 0

LeftGroupBox:AddLabel("Press Keybind"):AddKeyPicker("KeyPicker2", {
	-- Example: Press Keybind which you use to run a callback when the key was pressed.

	Default = "X", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

	Mode = "Press",
	WaitForCallback = false, -- Locks the keybind during the execution of Callback and OnChanged.

	Text = "Increase Number", -- Text to display in the keybind menu

	-- Occurs when the keybind is clicked, Value is always `true` for Press keybind.
	Callback = function()
		KeybindNumber = KeybindNumber + 1
		print("[cb] Keybind clicked! Number increased to:", KeybindNumber)
	end
})

-- Label:AddDropdown
-- Arguments: Idx, Info

-- Info table is the same as the default Dropdowns
-- These dropdowns are very compacted

LeftGroupBox:AddLabel('Dropdown'):AddDropdown('MyDropdown', {
	Values = { 'Addon', 'Dropdown' },
	Default = 1, -- number index of the value / string
	Multi = false, -- true / false, allows multiple choices to be selected

	-- Text is not required for this Dropdown --
	Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the dropdown while it's disabled

	Searchable = false, -- true / false, makes the dropdown searchable (great for a long list of values)

	Callback = function(Value)
		print('[cb] Dropdown got changed. New value:', Value)
	end,

	Disabled = false, -- Will disable the dropdown (true / false)
	Visible = true, -- Will make the dropdown invisible (true / false)
})

-- Long text label to demonstrate UI scrolling behaviour.
local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox('Groupbox #2');
LeftGroupBox2:AddLabel('Oh no...\nThis label spans multiple lines!\n\nWe\'re gonna run out of UI space...\nJust kidding! Scroll down!\n\n\nHello from below!', true)

local TabBox = Tabs.Main:AddRightTabbox() -- Add Tabbox on right side

-- Anything we can do in a Groupbox, we can do in a Tabbox tab (AddToggle, AddSlider, AddLabel, etc etc...)
local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Tab1 Toggle' });

local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Tab2 Toggle' });

-- Dependency boxes let us control the visibility of UI elements depending on another UI elements state.
-- e.g. we have a 'Feature Enabled' toggle, and we only want to show that features sliders, dropdowns etc when it's enabled!
-- Dependency box example:
local RightGroupbox = Tabs.Main:AddRightGroupbox('Groupbox #3');
RightGroupbox:AddToggle('ControlToggle', { Text = 'Dependency box toggle' });

local Depbox = RightGroupbox:AddDependencyBox();
Depbox:AddToggle('DepboxToggle', { Text = 'Sub-dependency box toggle' });

-- We can also nest dependency boxes!
-- When we do this, our SupDepbox automatically relies on the visiblity of the Depbox - on top of whatever additional dependencies we set
local SubDepbox = Depbox:AddDependencyBox();
SubDepbox:AddSlider('DepboxSlider', { Text = 'Slider', Default = 50, Min = 0, Max = 100, Rounding = 0 });
SubDepbox:AddDropdown('DepboxDropdown', { Text = 'Dropdown', Default = 1, Values = {'a', 'b', 'c'} });

local SecretDepbox = SubDepbox:AddDependencyBox();
SecretDepbox:AddLabel('You found a seĉret!')

Depbox:SetupDependencies({
	{ Toggles.ControlToggle, true } -- We can also pass `false` if we only want our features to show when the toggle is off!
});

SubDepbox:SetupDependencies({
	{ Toggles.DepboxToggle, true }
});

SecretDepbox:SetupDependencies({
	{ Options.DepboxDropdown, 'ĉ'} -- In the case of dropdowns, it will automatically check if the specified dropdown value is selected
})

-- Library functions
-- Sets the watermark visibility
Library:SetWatermarkVisibility(true)

-- Example of dynamically-updating watermark with common traits (fps and ping)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;
local GetPing = (function() return math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()) end)
local CanDoPing = pcall(function() return GetPing(); end)

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;

	if CanDoPing then
		Library:SetWatermark(('LinoriaLib demo | %d fps | %d ms'):format(
			math.floor(FPS),
			GetPing()
		));
	else
		Library:SetWatermark(('LinoriaLib demo | %d fps'):format(
			math.floor(FPS)
		));
	end
end);

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print('Unloaded!')
	Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddToggle("KeybindMenuOpen", { Default = Library.KeybindFrame.Visible, Text = "Open Keybind Menu", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:SetSubFolder('specific-place') -- if the game has multiple places inside of it (for example: DOORS) 
					   -- you can use this to save configs for those places separately
					   -- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
					   -- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
