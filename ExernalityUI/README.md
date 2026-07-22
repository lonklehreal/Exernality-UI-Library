# ExernalityUI

A modern, feature-rich UI library for Roblox, inspired by Rayfield.

## Features

- **Modular Architecture** — Clean source code separated into modules
- **Draggable Windows** — Click and drag the topbar
- **Tab System** — Organized navigation with icons and indicators
- **Sections** — Group controls under labeled sections
- **9 Control Types** — Button, Toggle, Slider, Dropdown, Keybind, Textbox, ColorPicker, Paragraph, Label
- **Notifications** — Slide-in notification system
- **Themes** — Dark and Light themes included (extensible)
- **Animations** — Smooth tweens on all interactions
- **Single-file Build** — Load the library with one HTTP request

## Usage

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YourName/ExernalityUI/main/build/ExernalityUI.lua"
))()

local Window = Library:CreateWindow({
    Name = "Exernality",
    Version = "v1.0"
})

local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://72206152389196"
})

local Section = Tab:CreateSection("Player")

Section:CreateButton({
    Name = "Fly",
    Description = "Toggle flight mode",
    Callback = function()
        print("Fly toggled")
    end
})
```

## API Reference

### Library

| Method | Description |
|--------|-------------|
| `Library:CreateWindow(data)` | Creates a new window |
| `Library:SetTheme(name)` | Switches theme ("Dark" or "Light") |
| `Library:GetTheme()` | Returns current theme name |
| `Library:GetThemes()` | Returns list of available theme names |

### Window

| Method | Description |
|--------|-------------|
| `Window:CreateTab(data)` | Creates a new tab |
| `Window:Notify(data)` | Shows a notification |
| `Window:Destroy()` | Removes the GUI |
| `Window:Toggle()` | Shows/hides the window |

#### Window Data

```lua
{
    Name = "Exernality",     -- Window title
    Version = "v1.0",        -- Version text
}
```

### Tab

| Method | Description |
|--------|-------------|
| `Tab:CreateSection(name)` | Creates a section |

#### Tab Data

```lua
{
    Name = "Main",           -- Tab name
    Icon = "",               -- Image asset ID (optional)
}
```

### Section

| Method | Description |
|--------|-------------|
| `Section:CreateButton(data)` | Creates a button |
| `Section:CreateToggle(data)` | Creates a toggle |
| `Section:CreateSlider(data)` | Creates a slider |
| `Section:CreateDropdown(data)` | Creates a dropdown |
| `Section:CreateKeybind(data)` | Creates a keybind |
| `Section:CreateTextbox(data)` | Creates a text input |
| `Section:CreateColorPicker(data)` | Creates a color picker |
| `Section:CreateParagraph(data)` | Creates a paragraph |
| `Section:CreateLabel(data)` | Creates a label |

### Notification Data

```lua
{
    Title = "Title",         -- Notification title
    Content = "Message",     -- Notification body
    Duration = 5,            -- Display time in seconds
}
```

## Building

The source is in `src/` as individual modules. The compiled single-file version is in `build/ExernalityUI.lua`. To rebuild:

1. Open the project in Roblox Studio
2. Insert all modules into a Model
3. Export as Lua source

## License

MIT License — see [LICENSE](LICENSE)
