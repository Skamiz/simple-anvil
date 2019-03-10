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
local MN_PREFIX = MODNAME .. ":"

minetest.register_node(MN_PREFIX .. "anvil",{
	description = "Anvil",
	drawtype = "mesh",
	mesh = "anvil.obj",
	paramtype = 'light',
	selection_box = {
		type = "fixed",
		fixed = {-0.19, -0.5, -0.33, 0.19, -0.09, 0.33},
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.19, -0.5, -0.33, 0.19, -0.09, 0.33},
	},
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_metal_defaults(),
	on_metadata_inventory_move = function(...)
		anvil.update_formspec(...)
	end,
	on_metadata_inventory_put = function(...)
		anvil.update_formspec(...)
	end,
	on_metadata_inventory_take = function(...)
		anvil.update_formspec(...)
	end,
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		
		inv:set_size("input", 1)
		inv:set_size("output", 1)
		
		meta:set_string("formspec", [[
			size[8,7]
			list[current_player;main;0,3.25;8,4;]
			list[context;input;2.5,1.5;1,1;]
			list[context;output;4.5,1.5;1,1;]
		]])
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		for k, v in pairs(fields) do
			if(fields.quit) then return end
			if v then
				local recipe = anvil.registered_recipes[tonumber(k)]
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				
				if inv:contains_item("input", recipe.input) and inv:room_for_item("output", recipe.output) then
					inv:remove_item("input", recipe.input)
					inv:add_item("output", recipe.output)
				end
				
			end
		end
	end
})

--Just a check that the recipe doesn't contain unexisting items.
local function sanitize_ItemStack(itemstack)
	if not minetest.registered_items[itemstack:get_name()] then
		error("Trying to register a recipe using '" .. itemstack:get_name() .. "', which doesn't exist.")
		return
	end
	if itemstack:get_count() < 1 then
		itemstack:set_count(1)
	end
	return true
end


anvil = {}
anvil.registered_recipes = {}
--[[Takes a recipe in the form:
	{
	input = itemstack,
	output = itemstack,
	}
itemstack should work for any of the three formats they come in.
]]
local recipe_id = 0
anvil.register_recipe = function(recipe)
	recipe.input = ItemStack(recipe.input)
	recipe.output = ItemStack(recipe.output)
	
	if sanitize_ItemStack(recipe.input) and	sanitize_ItemStack(recipe.output) then
		recipe.id = recipe_id
		anvil.registered_recipes[recipe_id] = recipe
		recipe_id = recipe_id + 1
	end
end



--Returns a table containing all anvil recipes which v=can be crafted from the given input.
anvil.get_craftable_recipes = function(aviable)
	aviable = ItemStack(aviable)
	local recipes = {}
	for _, r in pairs(anvil.registered_recipes) do
		if r.input:get_name() == aviable:get_name() and r.input:get_count() <= aviable:get_count() then
			recipes[#recipes + 1] = r
		end
	end
	return recipes
end

anvil.get_formspec = function (itemstack)
	local formspec  = {}
	local recipes = anvil.get_craftable_recipes(itemstack)
	
	formspec[#formspec + 1] = [[
			size[8,7]
			list[current_player;main;0,3.25;8,4;]
			list[context;input;2.5,1.5;1,1;]
			listring[]
			list[context;output;4.5,1.5;1,1;]
		]]
		
	local x = 4 - (#recipes / 2)
	for _, v in pairs(recipes) do
		formspec[#formspec + 1] = "item_image_button["
		formspec[#formspec + 1] = tostring(x)
		formspec[#formspec + 1] = ",0.125;1,1;"
		formspec[#formspec + 1] = v.output:get_name()
		formspec[#formspec + 1] = ";"
		formspec[#formspec + 1] = tostring(v.id)
		formspec[#formspec + 1] = ";]"
		x = x + 1
	end
	return table.concat(formspec)
end

anvil.update_formspec = function(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", anvil.get_formspec(meta:get_inventory():get_stack("input", 1)))
end