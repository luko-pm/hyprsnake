return {
    setup = function(game, controls)

        hl.define_submap("snake_game", function()
            hl.bind(controls.turn_r,function() game.turn_snake('r') end)
            hl.bind(controls.turn_l,function()  game.turn_snake('l') end)
            hl.bind(controls.exit, function() game.terminate() end)
            hl.bind("Escape", function() game.terminate() end) -- always bind escape to exit, just in case
        end)
    end,

    enable_controls = function()
        hl.dispatch(hl.dsp.submap("snake_game"))
    end,

    disable_controls = function()
        hl.dispatch(hl.dsp.submap("reset"))
    end,
}

