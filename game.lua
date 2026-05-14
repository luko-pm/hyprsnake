local Game = {}

---@module 'view'
local v = nil

---@module 'timer'
local t = nil

---@module 'control'
local c = nil

---@type Pos
local initial_pos = {}

---@type Body
local head

---@type Cell
local food = nil

local dir = nil
local dir_changed = nil
local length = nil
local running = nil

---@type Grid
local grid = {size = {}, cells = {}}

local function init_grid()
    for x=1, grid.size.x do
        grid.cells[x] = {}
        for y=1, grid.size.x do
            grid.cells[x][y] = 0
        end
    end
    return grid
end

local function get_empy_cells()
    local res = {}
    local n = 0
    for x=1, grid.size.x do
        for y=1, grid.size.y do
            if grid.cells[x][y] == 0 then
                table.insert(res, {x = x, y = y})
                n = n + 1
            end
        end
    end
    return res, n
end

local function create_snake(init_pos, id)
    head = {pos = init_pos, id = id}
    head.next = head
    return head
end

local function get_next_food_pos()
    local free_cells, num = get_empy_cells()
    local res = free_cells[math.random(1, num)]
    return res
end

local function create_food(id)
    food = { id = id, pos = get_next_food_pos() }
    v.draw_cell(food)
    return food
end

local function food_move()
    food.pos = get_next_food_pos()
    v.update_cell_pos(food)
end

local function get_next_pos (current,d)
    local vec =
    (d == 'l') and {-1, 0} or
    (d == 'r') and { 1, 0} or
    (d == 'u') and { 0,-1} or
    (d == 'd') and { 0, 1} or
    {0,0}

    return {
        x = current.x + vec[1],
        y = current.y + vec[2]
    }
end

local function change_dir(from, to_the)
    if to_the =='l' then
        if from == 'l' then return 'd'
        elseif from == 'r' then return 'u'
        elseif from == 'u' then return 'l'
        elseif from == 'd' then return 'r'
        end
    elseif to_the =='r' then
        if from == 'l' then return 'u'
        elseif from == 'r' then return 'd'
        elseif from == 'u' then return 'r'
        elseif from == 'd' then return 'l'
        end
    end
    return from
end

---@param next_pos Pos
local function snake_move(next_pos)
    head = head.next
    grid.cells[head.pos.x][head.pos.y] = 0
    head.pos = next_pos
    v.update_cell_pos(head)
    grid.cells[head.pos.x][head.pos.y] = 1
end

local function snake_grow(next_pos)
    length = length + 1
    local new_head = { pos = next_pos, id = length, next = head.next}
    head.next = new_head
    head = new_head
    v.draw_cell(head)
    grid.cells[head.pos.x][head.pos.y] = 1
end

local function is_out_of_bounds(pos)
    if pos.x < 1 then return true
    elseif pos.y < 1 then return true
    elseif pos.x > grid.size.x then return true
    elseif pos.y > grid.size.y then return true
    else return false
    end
end

Game.tick = function()
    if running == false then
        t.stop()
        return
    end

    local next_pos = get_next_pos(head.pos, dir)
    local out_of_bounds = is_out_of_bounds(next_pos)

    local next_pos_state = not out_of_bounds and grid.cells[next_pos.x][next_pos.y] or nil

    if out_of_bounds or next_pos_state == 1 then
        running = false
        t.stop()
        v.notify("Game Over", 2000, "rgb(ff0000)")
    elseif next_pos_state == 0 then
        dir_changed = false
        if next_pos.x == food.pos.x and next_pos.y == food.pos.y then
            snake_grow(next_pos)
            food_move()
        else
            snake_move(next_pos)
        end
    end
end

Game.setup = function(grid_size, tick_speed, timer, view, control)
    grid.size.x = grid_size[1]
    grid.size.y = grid_size[2]
    initial_pos = {x = math.ceil(grid.size.x/2), y = math.ceil(grid.size.y/2)}
    t = timer
    t.setup(Game.tick, tick_speed)
    v = view
    c = control
end

Game.start_game = function()
    init_grid()
    v.start()

    length = 1
    create_snake(initial_pos, length)
    v.draw_cell(head)

    create_food(0)

    dir = 'r'
    dir_changed = false
    running = true
    t.start()
    c.enable_mapings()
end

Game.terminate = function()
    running = false
    c.disable_maps()
    t.stop()
    v.clear()
end

Game.turn_snake = function(direction)
    if not dir_changed then
        dir = change_dir(dir, direction)
        dir_changed = true
    end
end

return Game
