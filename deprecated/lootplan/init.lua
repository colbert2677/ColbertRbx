-- LootPlan | colbert2677 | January 10th, 2023

--[=[
	LootPlan is a lightweight utility library designed for use cases related to
	random loot generation such as virtual random items and clear rewards in
	dungeon crawlers. The code and documentation are modified from dogwarrior24's
	work on [LootPlan](https://devforum.roblox.com/t/lootplan/463702).

	LootPlan exposes two classes: [SingleLootPlan](/api/SingleLootPlan) and
	[MultiLootPlan](/api/MultiLootPlan). As the names suggest, either class is
	designed to roll for a set number of loot. The classes fundamentally differ
	in how they randomise so it's important to pick one relevant to your case.

	LootPlan and its classes are purely abstract. The library handles the
	mathematics, randomisation and results. This gives developers complete
	flexibility over processing the results into tangible rewards in their own
	systems.

	:::caution Minimum one piece of loot
	Both LootPlan classes require at minimum one piece of loot added to their
	loot tables to generate a result.
	:::

	```lua
	-- Create a SingleLootPlan
	local gems = LootPlan.Single.new()
	
	-- Add our loot
	gems:BatchAddLoot({
		["Diamond"] = 1,
		["Jade"] = 25,
		["Phosphophyllite"] = 50,
	})

	-- Generate a result
	local gemName = gems:GetRandomLoot()
	
	-- Process the result
	playerInventory:AddMaterial({
		Id = GetIdFromName(gemName),
		Quantity = 1
	})
	```

	@class LootPlan
]=]
--[=[
	Any batch methods request a dictionary of key-value pairs to be passed;
	the key should be the name of a piece of loot in a loot table while the
	value is the value to write in.

	Read the documentation of the non-batch version of the method to learn
	how the number given is used. For example, BatchAddLoot in either class
	uses the key as the loot's name and the value as the weight or chance
	respectively.

	@type NumericalBatch {[string]: number}
	@within LootPlan
]=]
local LootPlan = {
	Single = require(script.SingleLootPlan),
	Multi = require(script.MultiLootPlan)
}

return LootPlan
