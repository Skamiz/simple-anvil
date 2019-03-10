Simple anvil
============
A small mod which adds a simple custom crafting station.
It changes the crafting recipes of metal tools from 'default' so that they require a tool head and a stick.
The tool heads can be crafted at the anvil from thier respective metal ingots.

Recipes
=======
anvil:
XXX
OXO
XOX
X = 'default:stell_ingot'

API
===
You can use 'anvil.register_recipe(recipe)' to add your own recipes in the form
recipe = {
	input = itemstack,
	output = itemstack,
	}
itemstack should work for any of the three formats they come in.