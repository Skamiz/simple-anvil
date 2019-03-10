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
local MN_U = MODNAME .. "_"

local tool_types = {"pick", "shovel", "axe", "sword"}
local tool_grades = {"bronze", "steel"}

for _, g in pairs(tool_grades) do
	for _, t in pairs(tool_types) do
		minetest.register_craftitem(MN_C..t.."_"..g.."_head", {
			description = g.." "..t.." head",
			inventory_image = MN_U..t.."_"..g.."_head.png",
			stack_max = 1,
		})
	end
end