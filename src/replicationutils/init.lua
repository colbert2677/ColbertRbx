-- ReplicationUtils | colbert2677 | January 8th, 2023

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Promise)

--[=[
	Utility to help with replication assurances. Modified from tyridge77's
	[ReplicationUtils](https://devforum.roblox.com/t/replicationutils/2072172).

	Queue a replication change by setting an attribute on an object which the
	client can wait to receive. The server also additionally sets a global
	counter to allow some uniqueness between checks.

	This module is best used after a target instance enters a container that
	replicates to the client. The attribute set will effectively snapshot the
	instance at the time of the queued change as the attribute replication
	will arrive later.

	ReplicationUtils uses [Promise](https://eryn.io/roblox-lua-promise/) by
	evaera in [WaitForLoaded](/api/ReplicationUtils#WaitForLoaded). You can
	get the best use out of this module with familiarity to Promises.

	```lua
	-- Server:
	FrameworkRemotes.Parent = ReplicatedStorage
	ReplicationUtils:Replicate(FrameworkRemotes)

	-- Client:
	ReplicationUtils:WaitForLoaded(FrameworkRemotes):andThen(function ()
		BuildObjects(FrameworkRemotes)
	end):catch(function (exception)
		-- You can write your own error handler
	end)

	-- You can customise how the internals work on the client:
	ReplicationUtils.DefaultTimeout = 60
	ReplicationUtils.HandleExceptions = true
	```

	:::note ReplicationUtils uses attributes
	ReplicationUtils uses the attribute `ColbertRbx_ReplicationCounter` for its
	operation. The prefix helps prevent namespace collisions with any attributes
	you might set for instances. For developers forking the module that want to
	change the internal attribute, it is the `COUNTER_ATTRIBUTE` constant.
	:::

	@class ReplicationUtils
]=]
local ReplicationUtils = {}

local IS_SERVER = RunService:IsServer()
local COUNTER_ATTRIBUTE = "ColbertRbx_ReplicationCounter"

if IS_SERVER then
	local counter = 0

	--[=[
		Queue a replication change by setting an attribute on a given instance.

		The queued replication change will effectively provide a snapshot of
		the model at the time of the call. Best practice is to parent your
		instances to a container that replicates to clients first before
		calling Replicate so the attribute change can be queued after
		the replication of the instance's descendants.

		@server
	]=]
	function ReplicationUtils:Replicate(object: Instance)
		counter += 1

		ReplicatedStorage:SetAttribute(COUNTER_ATTRIBUTE, counter)
		object:SetAttribute(COUNTER_ATTRIBUTE, counter)
	end

	ReplicatedStorage:SetAttribute(COUNTER_ATTRIBUTE, counter)
else
	--[=[
		Provides the base timeout value for Promises created by
		[WaitForLoaded](/api/ReplicationUtils#WaitForLoaded). Defaults to `10`.

		This value can be overridden per call of WaitForLoaded with the second
		argument.

		:::tip Recommended to use a low number
		Although DefaultTimeout can be any value, it's recommended to use a
		low number or keep the default value of `10`. Chained Promises or
		subsequent code (in the case of using await, awaitStatus or expect)
		may delay up to this value before rejecting if incoming replication
		is heavily delayed.
		:::

		:::danger Property value not protected
		ReplicationUtils only enforces the parameter type; it does not perform
		any special checks against what you may assign to this property. It is
		your responsibility to use a reasonable value.
		:::

		@prop DefaultTimeout number
		@within ReplicationUtils
		@client
	]=]
	ReplicationUtils.DefaultTimeout = 10

	--[=[
		Determines if ReplicationUtils should catch rejected Promises itself,
		removing the burden from the developer to write error handlers for each
		[WaitForLoaded](/api/ReplicationUtils#WaitForLoaded) call. Defaults to
		`true`.

		This value can be overridden per call of WaitForLoaded with the third
		argument.

		:::danger Property value not protected
		ReplicationUtils only enforces the parameter type; it does not perform
		any special checks against what you may assign to this property. It is
		your responsibility to use a reasonable value.
		:::

		@prop HandleExceptions boolean
		@within ReplicationUtils
		@client
	]=]
	ReplicationUtils.HandleExceptions = true

	--[=[
		Set up a Promise that resolves when the client receives the replication
		change set by the server.

		:::caution Must use Replicate on the server first
		WaitForLoaded only works for instances that the server has first called
		Replicate on. The Promise may not resolve up to the maximum timeout if
		using WaitForLoaded without first calling Replicate.
		:::

		:::info nil arguments will default
		Any argument not provided will fall back to the default value. This is
		mostly only relevant for being able to use the third argument to
		control issue handling per WaitForLoaded call.

		```lua
		ReplicationUtils:WaitForLoaded(FoobarFolder, nil, false):catch(function (exception)
			-- Write your own catch here
		end)
		```
		:::

		@return Promise
		@client
	]=]
	function ReplicationUtils:WaitForLoaded(object: Instance, timeout: number, handleExceptions: boolean)
		if not object then
			return
		end

		if typeof(timeout) ~= "number" then
			timeout = self.DefaultTimeout
		end

		if typeof(handleExceptions) ~= "boolean" then
			handleExceptions = self.HandleExceptions
		end

		local promise = Promise.new(function(resolve)
			local counter = object:GetAttribute(COUNTER_ATTRIBUTE)

			if not counter then
				object:GetAttributeChangedSignal(COUNTER_ATTRIBUTE):Wait()
				counter = object:GetAttribute(COUNTER_ATTRIBUTE)
			end

			resolve(counter)
		end):andThen(function(counter)
			return Promise.any({
				Promise.new(function(resolve)
					local replicatedCounter = ReplicatedStorage:GetAttribute(COUNTER_ATTRIBUTE) or 0
					if replicatedCounter >= counter then
						resolve()
					end
				end),
				Promise.fromEvent(ReplicatedStorage:GetAttributeChangedSignal(COUNTER_ATTRIBUTE), function()
					local replicatedCounter = ReplicatedStorage:GetAttribute(COUNTER_ATTRIBUTE) or 0
					return replicatedCounter >= counter
				end)
			})
		end):timeout(timeout)

		if handleExceptions == true then
			promise:catch(function(exception)
				warn(string.format(
					"WaitForLoaded could not resolve for %s: %s",
					object:GetFullName(),
					tostring(exception)
				))
			end)
		end

		return promise
	end
end

return ReplicationUtils
