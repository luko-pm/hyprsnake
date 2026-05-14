---@meta

---@alias Pos {x: number, y: number}
---@alias Cell {id: number, pos: Pos, color: string}
---@alias Body {id: number, pos: Pos, color: string, next: Body}
---@alias Grid {size: number[], cells: number[][]}
