--[[
	Anvil - a simple crafting station mod.
	Copyright (C) 2019  Skamiz Kazzarch

	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
]]

local MODNAME = minetest.get_current_modname()
local MN_C = MODNAME .. ":"

local tool_types = {pick = 3, shovel = 1, axe = 1, sword = 2}
local tool_grades = {"bronze", "steel"}

for _, g in pairs(tool_grades) do
	for t, c in pairs(tool_types) do
		anvil.register_recipe({
			input = "default:"..g.."_ingot " .. c,
			output = MN_C..t.."_"..g.."_head",
		})
		
		minetest.clear_craft({output = "default:"..t.."_"..g})
		
		minetest.register_craft({
			output = "default:"..t.."_"..g,
			recipe = {{"", MN_C..t.."_"..g.."_head"},
						{"default:stick", ""},},
		})
	end
end

minetest.register_craft({
	output = MN_C.."anvil",
	recipe = {{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"", "default:steel_ingot", ""},
			{"default:steel_ingot", "", "default:steel_ingot"},}
})

--just a comment to test github
