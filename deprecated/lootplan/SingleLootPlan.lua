-- SingleLootPlan | colbert2677 | January 10th, 2023

--[=[
	SingleLootPlan is designed for cases where you only want to generate one
	piece of loot. A common example for Roblox developers is paid random
	virtual items (loot crates).

	SingleLootPlan is based in a weighted approach: when generating loot from a
	SingleLootPlan, chance is calculated relative to the total weights of all
	loot. Say for example you have these items and their weights:

	- Diamond: 0.01
	- Gold: 2
	- Iron: 10
	- Stone: 100

	The combined chance is 112.01 (100 + 10 + 2 + 0.01). This means that
	the chance of rolling Iron is 8.927% (10/112.01).

	To explain this weighted approach for SingleLootPlan's randomisation even
	further, imagine lazy chance where you fill a table a certain number of
	times, randomise over the aggregate table and return the result.

	```lua
	local items = {
		-- ["LootName"] = Number of times to be added
		["Diamond"] = 1,
		["Jade"] = 5,
		["Phosphophyllite"] = 10
	}
	local aggregate = {}

	for name, times in items do
		for i = 1, times do
			table.insert(aggregate, name)
		end
	end

	local pickedItem = aggregate[Random.new():NextInteger(1, #aggregate)]
	print(pickedItem)
	```

	The items table forms ranges for each item that will become the result if
	the number from the randomisation falls in that range. A weighted system
	effectively does this same thing but mathematically so that you aren't
	left with a giant table that's been reallocated and resized to try and fit
	all your items.

	@class SingleLootPlan
	@__index prototype
]=]
--[=[
	@prop Single SingleLootPlan
	@within LootPlan
]=]
--[=[
	Loot information. Weight is used in chance calculation.

	@type WeightedLoot {Name: string, Weight: number}
	@within SingleLootPlan
]=]
local SingleLootPlan = {}
SingleLootPlan.prototype = {}
SingleLootPlan.__index = SingleLootPlan.prototype

--[=[
	Constructs a SingleLootPlan. The optional parameters `seed` and `step` can
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

	Therefore, equivalently, with SingleLootPlan:

	```lua
	local gemBatch = {
		["Diamond"] = 0.5,
		["Jade"] = 3,
		["Phosphophyllite"] = 10
	}

	local planA = LootPlan.Single.new(1, 3)
	local planB = LootPlan.Single.new(1, 3)

	planA:BatchAdd(gemBatch)
	planB:BatchAdd(gemBatch)

	print(planA:GetRandomLoot() == planB:GetRandomLoot()) --> true
	```
	:::

	@return SingleLootPlan
]=]
--[=[
	SingleLootPlan object.

	:::danger Not recommended to directly access properties
	None of the properties of a SingleLootPlan object are considered private
	access or read only but developers are encouraged to use object methods
	instead for any reading and writing purposes over directly accessing them.

	In the case of reading, a method may have additional steps involved before
	it returns a value. In the case of writing, unexpected behaviour may be
	produced by changing properties on your own. This is especially the case
	with changing the random number generator after constructing an object:
	results may be tampered if advancing generation or reassigning the
	generator.
	:::

	@interface SingleLootPlan
	.Randomiser Random -- Random number generator specific to this SingleLootPlan.
	.Loot {{[string]: WeightedLoot}} -- Loot dictionary (used in modifying loot table)
	.LootList {WeightedLoot} -- Loot array (used in randomisation).
	.LootCount number -- Total loot (used in randomisation).
	.TotalChance number -- Weight aggregate (used in randomisation).
	._ListUpdated boolean -- If UpdateLootList calls should pass (used internally).
	@within SingleLootPlan
]=]
function SingleLootPlan.new(seed: number, step: number)
	local canStep = typeof(seed) == "number"

	if typeof(step) ~= "number" or step < 0 then
		-- Avoid runtime type check when stepping
		step = 0
	end

	local plan = {}

	plan.Randomiser = if typeof(seed) == "number" then Random.new(seed) else Random.new()
	plan.Loot = {}
	plan.LootList = {}
	plan.LootCount = 0
	plan.TotalChance = 0
	plan._ListUpdated = true

	while canStep == true and step > 0 do
		plan.Randomiser:NextNumber()
		step -= 1
	end

	setmetatable(plan, SingleLootPlan)

	return plan
end

--[=[
	Updates the loot array of a SingleLootPlan. This takes the existing
	loot dictionary and converts it into an array sorted by weight in
	ascending order as rarer loots need to be checked first for winning
	results.

	@private
]=]
function SingleLootPlan.prototype:_UpdateLootList()
	if self._ListUpdated == true then
		return
	end

	self._ListUpdated = true

	table.clear(self.LootList)

	for _, loot in self.Loot do
		table.insert(self.LootList, loot)
	end

	table.sort(self.LootList, function(a, b)
		return a.Weight < b.Weight
	end)
end

--[=[
	Get the weight of a loot.
]=]
function SingleLootPlan.prototype:GetWeight(name: string): number
	local loot = self.Loot[name]

	if not loot then
		error("No loot with name \"" .. name .. "\"")
	end

	return loot.Weight
end

--[=[
	Get the percentage chance of a loot. This is calculated as a simple
	division to find percentage `(x/total) * 100`.

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
	:::
]=]
function SingleLootPlan.prototype:GetChance(name: string): number
	local loot = self.Loot[name]

	if not loot then
		error("No loot with name \"" .. name .. "\"")
	end

	return (loot.Weight/self.TotalChance) * 100
end

--[=[
	Adds a piece of loot to the loot table.

	:::danger tostring required for non-strings
	If for example you use numbers to id your loot, you will need to call
	tostring on the number. Add will error at runtime if a non-string is
	submitted.
	:::
]=]
function SingleLootPlan.prototype:Add(name: string, weight: number)
	assert(typeof(name) == "string", "A string is expected for Add arg #1")

	local newLoot = {
		Name = name,
		Weight = weight,
	}

	self.Loot[name] = newLoot
	self.LootCount += 1
	self.TotalChance += weight

	self._ListUpdated = false
end

--[=[
	Batch version of [Add](/api/SingleLootPlan#Add). Sugar for
	individual calls on each piece of loot.

	```lua
	plan:BatchAdd({
		["Jade"] = 0.02,
		["Ghost Quartz"] = 6
	})
	```

	@param batch NumericalBatch
]=]
function SingleLootPlan.prototype:BatchAdd(batch)
	for name, weight in batch do
		self:Add(name, weight)
	end
end

--[=[
	Removes a piece of loot from the loot table.
]=]
function SingleLootPlan.prototype:Remove(name: string)
	local loot = self.Loot[name]
	if not loot then return end

	self.TotalChance -= loot.Weight
	self.LootCount -= 1
	self.Loot[name] = nil

	self._ListUpdated = false
end

--[=[
	Batch version of [Remove](/api/SingleLootPlan#Remove). Sugar for
	individual calls on each piece of loot.

	```lua
	plan:BatchRemove({"Diamond", "Jade"})
	```
]=]
function SingleLootPlan.prototype:BatchRemove(batch: {string})
	for _, name in batch do
		self:Remove(name)
	end
end

--[=[
	Changes the weight of a loot.
]=]
function SingleLootPlan.prototype:ChangeWeight(name: string, weight: number)
	local loot = self.Loot[name]

	if not loot then
		error("No loot with name \"" .. name .. "\"")
	end

	self.TotalChance += weight - loot.Weight
	loot.Weight = weight

	self._ListUpdated = false
end

--[=[
	Batch version of [ChangeWeight](/api/SingleLootPlan#ChangeWeight).
	Sugar for individual calls on each piece of loot.

	@param batch NumericalBatch
]=]
function SingleLootPlan.prototype:BatchChangeWeight(batch)
	for name, newWeight in batch do
		self:ChangeWeight(name, newWeight)
	end
end

--[=[
	Adds to the weight of an existing loot. This is sugar for passing a
	number added to the result of
	[GetWeight](/api/SingleLootPlan#GetWeight) to
	[ChangeWeight](/api/SingleLootPlan#ChangeWeight).
]=]
function SingleLootPlan.prototype:IncreaseWeight(name: string, weight: number)
	if weight <= 0 then return end

	self:ChangeWeight(name, self:GetWeight(name) + weight)
end

--[=[
	Batch version of
	[IncreaseWeight](/api/SingleLootPlan#IncreaseWeight). Sugar for
	individual calls on each piece of loot.

	@param batch NumericalBatch
]=]
function SingleLootPlan.prototype:BatchIncreaseWeight(batch)
	for name, addedWeight in batch do
		self:IncreaseWeight(name, addedWeight)
	end
end

--[=[
	Subtracts from the weight of an existing loot. This is sugar for passing
	a number subtracted from the result of
	[GetWeight](/api/SingleLootPlan#GetWeight) to
	[ChangeWeight](/api/SingleLootPlan#ChangeWeight).
]=]
function SingleLootPlan.prototype:DecreaseWeight(name: string, weight: number)
	if weight <= 0 then return end

	self:ChangeWeight(name, self:GetWeight(name) - weight)
end

--[=[
	Batch version of
	[DecreaseWeight](/api/SingleLootPlan#DecreaseWeight). Sugar for
	individual calls on each piece of loot.

	@param batch NumericalBatch
]=]
function SingleLootPlan.prototype:BatchDecreaseWeight(batch)
	for name, subtractedWeight in batch do
		self:DecreaseWeight(name, subtractedWeight)
	end
end

--[=[
	Rolls for a random piece of loot from the loot table. Can optionally be
	called with `luck` which modifies the winning randomisation range for
	each piece of loot rolled. `luck` defaults to 1.

	:::tip "Nothing" counts as a valid loot
	If you want one of the results of a loot roll to be that the player doesn't
	earn a reward, you should add "Nothing" to the loot table. You can then
	have your reward code not grant any items if "Nothing" is rolled. Without
	a "Nothing" loot, there is no losing result and rolls will always have at
	least one item from the loot table becoming the result.
	:::

	```lua
	local result = plan:Roll()

	if result ~= "Nothing" then
		-- Handle a positive result
	end
	```
]=]
function SingleLootPlan.prototype:Roll(luck: number): string
	if typeof(luck) ~= "number" or luck <= 0 then
		luck = 1
	end

	self:_UpdateLootList()

	if luck >= 1 then
		local result = self.Randomiser:NextNumber()
		local aggregate = 0

		for _, loot in self.LootList do
			local chance = loot.Weight * luck

			if result < (chance + aggregate)/self.TotalChance then
				return loot.Name
			end

			aggregate += chance
		end
	else
		luck = 1/luck
		local result = self.Randomiser:NextNumber()
		local aggregate = 0

		for i = self.LootCount, 1, -1 do
			local loot = self.LootList[i]
			local chance = loot.Weight * luck

			if result < (chance + aggregate)/self.TotalChance then
				return loot.Name
			end

			aggregate += chance
		end
	end

	return "???"
end

--[=[
	Cleans up the SingleLootPlan object and locks the table from changes.

	:::tip Automatically cleans up without strong references
	SingleLootPlan objects are pure data. As long as you don't have any strong
	references to a SingleLootPlan object or its contents, you can safely
	discard them without calling Destroy and they will be cleaned up by the
	garbage collector.
	:::
]=]
function SingleLootPlan.prototype:Destroy()
	table.clear(self)
	table.freeze(self)
end

return SingleLootPlan
