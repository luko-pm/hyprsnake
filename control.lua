return {
    setup = function(game, maps)

        hl.define_submap("snake_game", function()
            hl.bind(maps.turn_r,function() game.turn_snake('r') end)
            hl.bind(maps.turn_l,function()  game.turn_snake('l') end)
            hl.bind(maps.exit, function() game.terminate() end)
            hl.bind("Escape", function() game.terminate() end) -- always bind escape to exit, just in case
        end)
    end,

    enable_maps = function()
        hl.dispatch(hl.dsp.submap("snake_game"))
    end,

    disable_maps = function()
        hl.dispatch(hl.dsp.submap("reset"))
    end,
}

