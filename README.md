Tiny little snake game to play when you get bored of porting your config to lua.

![thats a long link](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNnJsOTdkZjU3bnF6MnplM2F2MWt4dDhlem45ZmhxdDVheWxjZjVhdSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/uzXrenA2gVP6UTDR2B/giphy.gif)

# Disclaimer
It is not finished at all. I will improve and fully anotate the code but the idea is there and it does work (for me at least).
But yeah I am not exactly Mr.Engeneer just yet so if you take a moment to read the code and give me some pointers or even make a PR that would be awesome.

# Requirements
## Foot
I wanted the pixels to be real windows to ebrace the config as an engine. This does mean you need foot, which is a very lightweight terminal, to render the pixels.
I dont like it either but it is what it is for now.

# "Instalation"
Clone the repo into your config.

Alternativeley you can clone the repo elsewhere and have this in your config:

``` lua
local snake_dir = os.getenv("HOME") .. "/whatever/hyprsnake"

package.path = table.concat({
  package.path,
  snake_dir .. "/?.lua",
}, ";")

Hyprsnake = require("hyprsnake")
```

# Usage and Configuration
You can configure the speed of the snake, the mapings and the size of the grid.
You dont need to call set_opts if you want to keep the defaults.
If you call set_opts you dont need to specify all the options, just the ones you want to change.

``` lua
-- require the module
Hyprsnake = require('hyprsnake')

-- Default options
Hyprsnake.set_opts({
     tick_speed = 200, -- less means faster
    maps = {    -- sintax for keys is the same as hyprland keybinds
        turn_r = 'right',
        turn_l = 'left',
        exit = 'Escape'
    },
    grid_size = {32, 18}, -- explanation below
}

-- Set a bind to launch the game
hl.bind(MainMod .. " + S", function() Hyprsnake.launch() end)
```

## grid_size
The dimensions of the playing grid, this means your screen will be split into "pixels" using this dimentions.
If the ratio of yout grid_size doesnt match the ratio of your monitor you will be playing with rectangles, be aware (unless you are into that short of thing, I dont judge)
