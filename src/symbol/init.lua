-- Symbol | colbert2677 | January 8th, 2023

--[[
	Represents a unique object. Based on JavaScript Symbols.

	@author colbert2677
]]

--[=[
	Represents a unique object.

	:::info There are rules to this uniqueness

	- Local symbols will always be unique.
	- Global symbols with the same label are equal.
	- Local and global symbols are never equal.
	:::

	```lua
	local local_symbol_a = Symbol.new("foobar")
	local local_symbol_b = Symbol.new("foobar")

	local global_symbol_a = Symbol.of("foobar")
	local global_symbol_b = Symbol.of("foobar")

	print(local_symbol_a == local_symbol_b) --> false
	print(global_symbol_a == global_symbol_b) --> true
	print(local_symbol_a == global_symbol_a) --> false
	```

	@class Symbol
]=]
local Symbol = {}

local IS_SYMBOL = newproxy(false)

local globalRegistry = {}
local metatable = {}

function metatable:__tostring()
	return "Symbol(" .. self.Label .. ")"
end

--[=[
	Given an argument, check if its a Symbol.
]=]
function Symbol.is(symbol: any): boolean
	return typeof(symbol) == "table" and symbol[IS_SYMBOL] == true
end

--[=[
	Check if the label of the given symbol is in the global registry.

	```lua
	print(Symbol.keyOf(Symbol.of("foobar"))) --> foobar
	print(Symbol.keyOf(Symbol.new("foobar"))) --> nil
	```

	@tag Not Replicated
]=]
function Symbol.keyOf(symbol: Symbol): string?
	assert(
		Symbol.is(symbol),
		"A symbol is required for Symbol.keyOf"
	)

	local label = symbol.Label
	local sharedSymbol = globalRegistry[label]

	if sharedSymbol == symbol then
		return label
	end

	return nil
end

--[=[
	Create a local symbol with an optional label. Symbols will be created with
	a default label of `undefined` if not provided however will not lose their
	uniqueness.

	@tag Not Replicated
]=]
function Symbol.new(label: string?): Symbol
	if not label then
		label = "undefined"
	end

	local symbol = setmetatable({
		Label = label,

		[IS_SYMBOL] = true,
	}, metatable)

	return symbol
end

--[=[
	Find and return or create a new Symbol in the global registry.

	:::caution Label required
	Global symbol labels require at least one alphanumerical to be valid.
	:::

	@tag Not Replicated
]=]
function Symbol.of(label: string): Symbol
	-- Match requires labels have at least one alphanumerical
	assert(
		label and string.match(label, "%w"),
		"A label with alphanumericals is required for Symbol.of"
	)

	local sharedSymbol = globalRegistry[label]
	if sharedSymbol then
		return sharedSymbol
	end

	sharedSymbol = Symbol.new(label)

	globalRegistry[label] = sharedSymbol

	return sharedSymbol
end

--[=[
	@type Symbol Symbol
	@within Symbol
]=]
--[=[
	@interface Symbol
	.Label string -- The label of the symbol
	.[IS_SYMBOL] userdata -- A special userdata to identify symbol tables
	@within Symbol
]=]
--[=[
	A string containing the label of the symbol.

	@prop Label string
	@within Symbol
	@tag Object-Level
]=]
export type Symbol = typeof(Symbol.new())

return Symbol
