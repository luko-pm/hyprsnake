---@meta

---@alias Pos {x: number, y: number}
---@alias Cell {id: number, pos: Pos}
---@alias Body {pos: Pos, id: number, next: Body}
---@alias Grid {size: {x: number, y: number}, cells: number[][]}
