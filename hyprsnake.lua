---@module "control"
local control = nil
---@module "game"
local game = nil
---@module "timer"
local timer = nil
---@module "view"
local view = nil

local setup_done = false
local opts_set = false

local opts = {}
local def_opts = {
    tick_speed = 200,
    maps = {
        turn_r = 'right',
        turn_l = 'left',
        exit = 'Escape'
    },
    grid_size = {32, 18},
    snake_color = "ffffff",
}

local function set_opts(usr_opts)
    usr_opts = usr_opts or {}
    opts.tick_speed = usr_opts.tick_speed or def_opts.tick_speed
    opts.grid_size = usr_opts.grid_size or def_opts.grid_size
    opts.snake_color = usr_opts.snake_color or def_opts.snake_color

    usr_opts.maps = usr_opts.maps or {}
    opts.maps = {}
    for k, v in pairs(def_opts.maps) do
        opts.maps[k] = usr_opts.maps[k] or v
    end
    opts_set = true
end

local function setup()
    if not opts_set then
        set_opts()
    end

    control = control or require('control')
    game = game or require('game')
    timer = timer or require('timer')
    view = view or require('view')

    view.setup(opts.grid_size, opts.snake_color)
    game.setup(opts.grid_size, opts.tick_speed, timer, view, control)
    control.setup(game,opts.maps)

    setup_done = true
end

return {

    set_opts = function(options)
        set_opts(options)
    end,

    launch = function()
        if not setup_done then
            setup()
        end
        game.start_game()
    end,
    terminate = function()
        timer.stop()
        game.terminate()
        view.clear()
        control.disable_maps()
    end,
}
