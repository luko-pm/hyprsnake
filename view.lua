local View = {}

local ws_name = 'special:snake'
--local ws_name = 'snake'
local cell_size = {}
local cell_color

---@type HL.WindowRule
local winRule = nil

---@type HL.Monitor
local monitor

local function setup_rules()
    hl.workspace_rule({
        --name = "snake-wsRule",
        workspace = ws_name,
        gaps_in = 0, gaps_out = 0, border_size = 0, no_border = true, no_rounding = true, decorate = false, animation = 'disabled',
        --no_shadow = true,
    })

    winRule = hl.window_rule({
        name = "snake-winRule",
        match = { workspace = ws_name},
        float = true,
        size = tostring(cell_size[1]) .. " " .. tostring(cell_size[2]),
        workspace = ws_name,
        suppress_event =  "fullscreen maximize activate activatefocus fullscreenoutput",
        no_initial_focus = true, border_size = 0, rounding = 0, decorate = false, no_anim = true, no_blur = true, no_dim = true, no_shadow = true, enabled = false,
    })
end


local function gen_pixel_cmd(title, color)
    local bg_color = color or cell_color
    local c_bg_color = bg_color
    local c_txt_color = c_bg_color == "ffffff" and "000000" or "ffffff" -- foot doesn't allow this to be the same
    return string.format("foot --title=%s --override=colors-dark.background=%s --override=colors-dark.cursor=%s\\ %s --override=scrollback.lines=0 sh -c 'exec sleep infinity'", title, bg_color, c_txt_color, c_bg_color)
end

local function game_pos_to_relative(pos)
    local coords = {
        ((pos.x - 1) * cell_size[1]),
        ((pos.y - 1) * cell_size[2])
    }
    return coords
end

local function game_pos_to_absolute(pos)
    local coords = game_pos_to_relative(pos)
    coords[1] = coords[1] + monitor.position.x
    coords[2] = coords[2] + monitor.position.y
    return coords
end

local function init_ws()
    winRule:set_enabled(true)
    hl.dispatch(hl.dsp.focus({workspace = ws_name}))
end

local function clear_ws()
    local windows = hl.get_workspace_windows(ws_name)
    for _,window in ipairs(windows) do
        hl.dispatch(hl.dsp.window.close({window = "pid:" .. window.pid}))
    end
end

View.setup = function(grid_size, snake_color)
    monitor = hl.get_active_monitor()
    cell_size = {(monitor.width/grid_size[1])/monitor.scale, (monitor.height/grid_size[2])/monitor.scale}
    cell_color = snake_color
    setup_rules()
    init_ws()
end

View.start = function()
    init_ws()
end

View.draw_cell = function(cell)
    local title = "snakeGame_"..cell.id
    local relative_pos = game_pos_to_relative(cell.pos)
    local abs_pos_string = tostring(relative_pos[1]) .. " " .. tostring(relative_pos[2])
    hl.exec_cmd(gen_pixel_cmd(title,nil), {
        move = abs_pos_string,
        tag = "snake_game",
    })
end

View.update_cell_pos = function(cell)
    local coords = game_pos_to_absolute(cell.pos)
    local title = "initialtitle:snakeGame_"..cell.id
    hl.dispatch(hl.dsp.focus({window = title}))
    hl.dispatch(hl.dsp.window.move({x = coords[1], y = coords[2]}))
end

View.notify = function(text, timeout, notif_color)
    timeout = timeout or 5000
    notif_color = notif_color or nil
    hl.notification.create({text = text, color = notif_color, timeout = timeout})
end

View.clear = function()
    clear_ws()
end

return View
