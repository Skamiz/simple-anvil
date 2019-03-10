local MODNAME = minetest.get_current_modname()
local mod_path = minetest.get_modpath(MODNAME)

dofile(mod_path.."/anvil.lua")
dofile(mod_path.."/craftitems.lua")
dofile(mod_path.."/recipes.lua")