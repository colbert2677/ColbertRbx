-- MultiLootPlan | colbert2677 | January 11th, 2023

--[=[
	MultiLootPlan is designed for cases where you want to generate multiple
	pieces of loot in one roll. A common example is clear rewards in a
	dungeon crawling experience or from an open world chest.

	Unlike SingleLootPlan which uses a weight-based approach, MultiLootPlan
	works purely in direct percentages. You supply the percentage chance of
	an item being included in a roll as well as how many rolls should be
	performed. Each roll may yield more than one item.

	The random number generator is called for a winning threshold for each
	item in a roll that the item is then checked against. Say for example you
	have these items and their percentages (assume a luck multiplier of 1):

	- Diamond: 0.01 (0.0001)
	- Gold: 2 (0.02)
	- Iron: 10 (0.10)
	- Stone: 100 (1)

	The random number generates a number between 0 and 1, so the percentages
	that you give in the loot table are lowered to a value between 0 and 1
	by turning the percentage into a decimal (dividing by 100).

	Given this list, there is an 100% chance for Stone to be included in
	every roll (1 will always be higher or equal to any number produced
	by Random:NextNumber). The random number generator is then called three
	more times for the remaining items in the list to produce thresholds that
	each of the items must exceed to be counted as a winning result.

	@class MultiLootPlan
	@__index prototype
]=]
--[=[
	@prop Multi MultiLootPlan
	@within LootPlan
]=]
--[=[
	Loot information.

	@type MultiLoot {Name: string, Chance: number}
	@within MultiLootPlan
]=]
--[=[
	Roll results table.

	@type MultiResults {[string]: number}
	@within MultiLootPlan
]=]
local MultiLootPlan = {}
MultiLootPlan.prototype = {}
MultiLootPlan.__index = MultiLootPlan.prototype

--[=[
	Constructs a MultiLootPlan. The optional parameters `seed` and `step` can
	be used for consistent deterministic results.

	:::caution Seed is required to use step
	The `step` parameter determines how many times the random number generator
	should be called on construction. Combined with seed, this allows you to
	make deterministic results. This can be desired for cases where you don't
	want re-rolling (e.g. starting a new session to try for a better result).

	No matter how many times you run the code below either in the Studio
	command bar or the server console in a live session, the results will
	always be the exact same: 97, 95, 17, 7, 97. Step is designed to make
	sure that when using a seed, the random number generator will always be
	advanced in such a way that the results become inescapable.

	```lua
	for i = 1, 5 do
		local rng = Random.new(1)
		local results = {}

		for i = 1, 5 do
			table.insert(results, rng:NextInteger(1, 100))
		end

		print(table.concat(results, ", "))
	end
	```

	Therefore, equivalently, with MultiLootPlan:

	```lua
	local gemBatch = {
		["Diamond"] = 0.5,
		["Jade"] = 3,
		["Phosphophyllite"] = 100
	}

	local planA = LootPlan.Multi.new(1, 3)
	local planB = LootPlan.Multi.new(1, 3)

	planA:BatchAdd(gemBatch)
	planB:BatchAdd(gemBatch)

	local phosA = planA:GetRandomLoot(25)["Phosphophyllite"]
	local phosB = planB:GetRandomLoot(25)["Phosphophyllite"]

	print(phosA == phosB) --> true
	```
	:::

	@return MultiLootPlan
]=]
--[=[
	MultiLootPlan object.

	:::danger Not recommended to directly access properties
	None of the properties of a MultiLootPlan object are considered private
	access or read only but developers are encouraged to use object methods
	instead for any reading and writing purposes over directly accessing them.

	In the case of reading, a method may have additional steps involved before
	it returns a value. In the case of writing, unexpected behaviour may be
	produced by changing properties on your own. This is especially the case
	with changing the random number generator after constructing an object:
	results may be tampered if advancing generation or reassigning the
	generator.
	:::

	@interface MultiLootPlan
	.Randomiser Random -- Random number generator specific to this MultiLootPlan.
	.Loot {{[string]: MultiLoot}} -- Loot dictionary (used in modifying loot and randomisation).
	@within MultiLootPlan
]=]
function MultiLootPlan.new(seed: number?, step: number?)
	local canStep = typeof(seed) == "number"

	if typeof(step) ~= "number" or step < 0 then
		-- Avoid runtime type check when stepping
		step = 0
	end

	local plan = {}

	plan.Randomiser = if typeof(seed) == "number" then Random.new(seed) else Random.new()
	plan.Loot = {}

	while canStep == true and step > 0 do
		plan.Randomiser:NextNumber()
		step -= 1
	end

	setmetatable(plan, MultiLootPlan)

	return plan
end

--[=[
	Gets the percentage chance of a loot.

	:::danger Required for paid randomisation compliance
	It is imperative that you implement this method to comply with the
	[Paid Random Virtual Items Policy](https://create.roblox.com/docs/production/monetization/randomized-virtual-items-policy)
	which governs Roblox policy around random item generators that can be paid
	for either directly (with Robux) or indirectly (with an in-experience
	currency that can be purchased with Robux).

	Policy dictates that you must declare the actual numerical odds to the
	player before they commit to their purchase. Using a LootPlan class puts
	it as the source of truth for the numerical reward chance, so likewise
	the numbers returned from this method should be shown to players so they
	know exactly what they may receive.
]=]
function MultiLootPlan.prototype:GetChance(name: string): number
	local loot = self.Loot[name]

	if not loot then
		error("No loot with name \"" .. name .. "\"")
	end

	return loot.Chance
end

--[=[
	Adds a piece of loot to the loot table.

	:::danger tostring required for non-strings
	If for example you use numbers to id your loot, you will need to call
	tostring on the number. Add will error at runtime if a non-string is
	submitted.
	:::
]=]
function MultiLootPlan.prototype:Add(name: string, chance: number)
	assert(typeof(name) == "string", "A string is expected for Add arg #1")

	local newLoot = {
		Name = name,
		Chance = chance
	}

	self.Loot[name] = newLoot
end

--[=[
	Adds multiple pieces of loot to the loot table. This is sugar for calling
	[Add](/api/MultiLootPlan#Add) on every piece of loot you want to
	add to the loot table.

	@param batch NumericalBatch
]=]
function MultiLootPlan.prototype:BatchAdd(batch)
	for name, chance in batch do
		self:Add(name, chance)
	end
end

--[=[
	Removes a piece of loot from the loot table.
]=]
function MultiLootPlan.prototype:Remove(name: string)
	self.Loot[name] = nil
end

--[=[
	Remove multiple pieces of loot from the loot table. This is sugar for
	calling [Remove](/api/MultiLootPlan#Remove) on every piece of
	loot you want to remove from the loot table.
]=]
function MultiLootPlan.prototype:BatchRemove(batch: {string})
	for _, name in batch do
		self:Remove(name)
	end
end

--[=[
	Changes the chance of a loot.
]=]
function MultiLootPlan.prototype:ChangeChance(name: string, chance: number)
	local loot = self.Loot[name]

	if not loot then
		error("No loot with name \"" .. name .. "\"")
	end

	loot.Chance = chance
end

--[=[
	Batch version of [ChangeChance](/api/MultiLootPlan#ChangeChance).
	Sugar for individual calls on each piece of loot.

	@param batch NumericalBatch
]=]
function MultiLootPlan.prototype:BatchChangeChance(batch)
	for name, newChance in batch do
		self:ChangeChance(name, newChance)
	end
end

--[=[
	Adds to the chance of an existing loot. This is sugar for passing a number
	added to the result of [GetChance](/api/MultiLootPlan#GetChance) to
	[ChangeChance](/api/MultiLootPlan#ChangeChance).
]=]
function MultiLootPlan.prototype:IncreaseChance(name: string, chance: number)
	if chance <= 0 then return end

	local loot = self.Loot[name]
	
	if not loot then
		error("No loot with name \"" .. name .. "\"")
	end

	loot.Chance += chance
end

--[=[
	Batch version of
	[IncreaseChance](/api/MultiLootPlan#IncreaseChance). Sugar for
	individual calls on each piece of loot.

	@param batch NumericalBatch
]=]
function MultiLootPlan.prototype:BatchIncreaseChance(batch)
	for name, addedChance in batch do
		self:IncreaseChance(name, addedChance)
	end
end

--[=[
	Subtracts to the chance of an existing loot. This is sugar for passing a
	number added to the result of
	[GetChance](/api/MultiLootPlan#GetChance) to
	[ChangeChance](/api/MultiLootPlan#ChangeChance).
]=]
function MultiLootPlan.prototype:DecreaseChance(name: string, chance: number)
	if chance <= 0 then return end

	local loot = self.Loot[name]
	
	if not loot then
		error("No loot with name \"" .. name .. "\"")
	end

	loot.Chance -= chance
end

--[=[
	Batch version of
	[DecreaseChance](/api/MultiLootPlan#DecreaseChance). Sugar for
	individual calls on each piece of loot.

	@param batch NumericalBatch
]=]
function MultiLootPlan.prototype:BatchDecreaseChance(batch)
	for name, subtractedChance in batch do
		self:DecreaseChance(name, subtractedChance)
	end
end

--[=[
	Rolls for pieces of loot from the loot table. Can optionally be provided
	with `iterations` which determines how many rolls should be performed and
	`luck` which modifies the winning randomisation range for each piece
	of loot rolled. Both `iterations` and `luck` default to 1.

	:::note "Nothing" is not required
	Unlike SingleLootPlan, you do not need to explicitly add a "Nothing"
	loot to a MultiLootPlan table. If a randomisation falls outside the
	range of any of the items in the loot table, it is counted as a missed
	reward (as such, the number of items in the finalised table may be less
	than the number of declared iterations).
	:::

	```lua
	local results = plan:Roll(50)

	for name, quantity in results do
		-- Handle the results
	end
	```

	@return MultiResults
]=]

function MultiLootPlan.prototype:Roll(iterations: number?, luck: number?)
	if typeof(iterations) ~= "number" or iterations <= 0 then
		iterations = 1
	end

	if typeof(luck) ~= "number" or luck <= 0 then
		luck = 1
	end

	local results = {}

	while iterations > 0 do
		for name, loot in self.Loot do
			local result = self.Randomiser:NextNumber()
			local chance = (loot.Chance/100) * luck

			if result < chance then
				if not results[name] then
					results[name] = 0
				end

				results[name] += 1
			end
		end

		iterations -= 1
	end

	return results
end

--[=[
	Cleans up the MultiLootPlan object and locks the table from changes.

	:::tip Automatically cleans up without strong references
	MultiLootPlan objects are pure data. As long as you don't have any strong
	references to a MultiLootPlan object or its contents, you can safely
	discard them without calling Destroy and they will be cleaned up by the
	garbage collector.
	:::
]=]
function MultiLootPlan.prototype:Destroy()
	table.clear(self)
	table.freeze(self)
end

return MultiLootPlan
