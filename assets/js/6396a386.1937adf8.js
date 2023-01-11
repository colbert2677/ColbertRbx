"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[417],{11315:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Constructs a SingleLootPlan. The optional parameters `seed` and `step` can\\nbe used for consistent deterministic results.\\n\\n:::caution Seed is required to use step\\nThe `step` parameter determines how many times the random number generator\\nshould be called on construction. Combined with seed, this allows you to\\nmake deterministic results. This can be desired for cases where you don\'t\\nwant re-rolling (e.g. starting a new session to try for a better result).\\n\\nNo matter how many times you run the code below either in the Studio\\ncommand bar or the server console in a live session, the results will\\nalways be the exact same: 97, 95, 17, 7, 97. Step is designed to make\\nsure that when using a seed, the random number generator will always be\\nadvanced in such a way that the results become inescapable.\\n\\n```lua\\nfor i = 1, 5 do\\n\\tlocal rng = Random.new(1)\\n\\tlocal results = {}\\n\\n\\tfor i = 1, 5 do\\n\\t\\ttable.insert(results, rng:NextInteger(1, 100))\\n\\tend\\n\\n\\tprint(table.concat(results, \\", \\"))\\nend\\n```\\n\\nTherefore, equivalently, with SingleLootPlan:\\n\\n```lua\\nlocal gemBatch = {\\n\\t[\\"Diamond\\"] = 0.5,\\n\\t[\\"Jade\\"] = 3,\\n\\t[\\"Phosphophyllite\\"] = 10\\n}\\n\\nlocal planA = LootPlan.Single.new(1, 3)\\nlocal planB = LootPlan.Single.new(1, 3)\\n\\nplanA:BatchAdd(gemBatch)\\nplanB:BatchAdd(gemBatch)\\n\\nprint(planA:GetRandomLoot() == planB:GetRandomLoot()) --\x3e true\\n```\\n:::","params":[{"name":"seed","desc":"","lua_type":"number?"},{"name":"step","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"SingleLootPlan"}],"function_type":"static","source":{"line":116,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"_UpdateLootList","desc":"Updates the loot array of a SingleLootPlan. This takes the existing\\nloot dictionary and converts it into an array sorted by weight in\\nascending order as rarer loots need to be checked first for winning\\nresults.","params":[],"returns":[],"function_type":"method","private":true,"source":{"line":176,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"GetWeight","desc":"Get the weight of a loot.","params":[{"name":"name","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"number\\n"}],"function_type":"method","source":{"line":197,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"GetChance","desc":"Get the percentage chance of a loot. This is calculated as a simple\\ndivision to find percentage `(x/total) * 100`.\\n\\n:::danger Required for paid randomisation compliance\\nIt is imperative that you implement this method to comply with the\\n[Paid Random Virtual Items Policy](https://create.roblox.com/docs/production/monetization/randomized-virtual-items-policy)\\nwhich governs Roblox policy around random item generators that can be paid\\nfor either directly (with Robux) or indirectly (with an in-experience\\ncurrency that can be purchased with Robux).\\n\\nPolicy dictates that you must declare the actual numerical odds to the\\nplayer before they commit to their purchase. Using a LootPlan class puts\\nit as the source of truth for the numerical reward chance, so likewise\\nthe numbers returned from this method should be shown to players so they\\nknow exactly what they may receive.\\n:::","params":[{"name":"name","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"number\\n"}],"function_type":"method","source":{"line":225,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"Add","desc":"Adds a piece of loot to the loot table.\\n\\n:::danger tostring required for non-strings\\nIf for example you use numbers to id your loot, you will need to call\\ntostring on the number. Add will error at runtime if a non-string is\\nsubmitted.\\n:::","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"weight","desc":"","lua_type":"number"}],"returns":[],"function_type":"method","source":{"line":244,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"BatchAdd","desc":"Batch version of [Add](/api/SingleLootPlan#Add). Sugar for\\nindividual calls on each piece of loot.\\n\\n```lua\\nplan:BatchAdd({\\n\\t[\\"Jade\\"] = 0.02,\\n\\t[\\"Ghost Quartz\\"] = 6\\n})\\n```","params":[{"name":"batch","desc":"","lua_type":"NumericalBatch"}],"returns":[],"function_type":"method","source":{"line":272,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"Remove","desc":"Removes a piece of loot from the loot table.","params":[{"name":"name","desc":"","lua_type":"string"}],"returns":[],"function_type":"method","source":{"line":281,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"BatchRemove","desc":"Batch version of [Remove](/api/SingleLootPlan#Remove). Sugar for\\nindividual calls on each piece of loot.\\n\\n```lua\\nplan:BatchRemove({\\"Diamond\\", \\"Jade\\"})\\n```","params":[{"name":"batch","desc":"","lua_type":"{string}"}],"returns":[],"function_type":"method","source":{"line":300,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"ChangeWeight","desc":"Changes the weight of a loot.","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"weight","desc":"","lua_type":"number"}],"returns":[],"function_type":"method","source":{"line":309,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"BatchChangeWeight","desc":"Batch version of [ChangeWeight](/api/SingleLootPlan#ChangeWeight).\\nSugar for individual calls on each piece of loot.","params":[{"name":"batch","desc":"","lua_type":"NumericalBatch"}],"returns":[],"function_type":"method","source":{"line":328,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"IncreaseWeight","desc":"Adds to the weight of an existing loot. This is sugar for passing a\\nnumber added to the result of\\n[GetWeight](/api/SingleLootPlan#GetWeight) to\\n[ChangeWeight](/api/SingleLootPlan#ChangeWeight).","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"weight","desc":"","lua_type":"number"}],"returns":[],"function_type":"method","source":{"line":340,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"BatchIncreaseWeight","desc":"Batch version of\\n[IncreaseWeight](/api/SingleLootPlan#IncreaseWeight). Sugar for\\nindividual calls on each piece of loot.","params":[{"name":"batch","desc":"","lua_type":"NumericalBatch"}],"returns":[],"function_type":"method","source":{"line":353,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"DecreaseWeight","desc":"Subtracts from the weight of an existing loot. This is sugar for passing\\na number subtracted from the result of\\n[GetWeight](/api/SingleLootPlan#GetWeight) to\\n[ChangeWeight](/api/SingleLootPlan#ChangeWeight).","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"weight","desc":"","lua_type":"number"}],"returns":[],"function_type":"method","source":{"line":365,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"BatchDecreaseWeight","desc":"Batch version of\\n[DecreaseWeight](/api/SingleLootPlan#DecreaseWeight). Sugar for\\nindividual calls on each piece of loot.","params":[{"name":"batch","desc":"","lua_type":"NumericalBatch"}],"returns":[],"function_type":"method","source":{"line":378,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"Roll","desc":"Rolls for a random piece of loot from the loot table. Can optionally be\\ncalled with `luck` which modifies the winning randomisation range for\\neach piece of loot rolled. `luck` defaults to 1.\\n\\n:::tip \\"Nothing\\" counts as a valid loot\\nIf you want one of the results of a loot roll to be that the player doesn\'t\\nearn a reward, you should add \\"Nothing\\" to the loot table. You can then\\nhave your reward code not grant any items if \\"Nothing\\" is rolled. Without\\na \\"Nothing\\" loot, there is no losing result and rolls will always have at\\nleast one item from the loot table becoming the result.\\n:::\\n\\n```lua\\nlocal result = plan:Roll()\\n\\nif result ~= \\"Nothing\\" then\\n\\t-- Handle a positive result\\nend\\n```","params":[{"name":"luck","desc":"","lua_type":"number?"}],"returns":[{"desc":"","lua_type":"string\\n"}],"function_type":"method","source":{"line":405,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"Destroy","desc":"Cleans up the SingleLootPlan object and locks the table from changes.\\n\\n:::tip Automatically cleans up without strong references\\nSingleLootPlan objects are pure data. As long as you don\'t have any strong\\nreferences to a SingleLootPlan object or its contents, you can safely\\ndiscard them without calling Destroy and they will be cleaned up by the\\ngarbage collector.\\n:::","params":[],"returns":[],"function_type":"method","source":{"line":453,"path":"src/lootplan/SingleLootPlan.lua"}}],"properties":[],"types":[{"name":"WeightedLoot","desc":"Loot information. Weight is used in chance calculation.","lua_type":"{Name: string, Weight: number}","source":{"line":62,"path":"src/lootplan/SingleLootPlan.lua"}},{"name":"SingleLootPlan","desc":"SingleLootPlan object.\\n\\n:::danger Not recommended to directly access properties\\nNone of the properties of a SingleLootPlan object are considered private\\naccess or read only but developers are encouraged to use object methods\\ninstead for any reading and writing purposes over directly accessing them.\\n\\nIn the case of reading, a method may have additional steps involved before\\nit returns a value. In the case of writing, unexpected behaviour may be\\nproduced by changing properties on your own. This is especially the case\\nwith changing the random number generator after constructing an object:\\nresults may be tampered if advancing generation or reassigning the\\ngenerator.\\n:::","fields":[{"name":"Randomiser","lua_type":"Random","desc":"Random number generator specific to this SingleLootPlan."},{"name":"Loot","lua_type":"{{[string]: WeightedLoot}}","desc":"Loot dictionary (used in modifying loot table)"},{"name":"LootList","lua_type":"{WeightedLoot}","desc":"Loot array (used in randomisation)."},{"name":"LootCount","lua_type":"number","desc":"Total loot (used in randomisation)."},{"name":"TotalChance","lua_type":"number","desc":"Weight aggregate (used in randomisation)."},{"name":"_ListUpdated","lua_type":"boolean","desc":"If UpdateLootList calls should pass (used internally)."}],"source":{"line":141,"path":"src/lootplan/SingleLootPlan.lua"}}],"name":"SingleLootPlan","desc":"SingleLootPlan is designed for cases where you only want to generate one\\npiece of loot. A common example for Roblox developers is paid random\\nvirtual items (loot crates).\\n\\nSingleLootPlan is based in a weighted approach: when generating loot from a\\nSingleLootPlan, chance is calculated relative to the total weights of all\\nloot. Say for example you have these items and their weights:\\n\\n- Diamond: 0.01\\n- Gold: 2\\n- Iron: 10\\n- Stone: 100\\n\\nThe combined chance is 112.01 (100 + 10 + 2 + 0.01). This means that\\nthe chance of rolling Iron is 8.927% (10/112.01).\\n\\nTo explain this weighted approach for SingleLootPlan\'s randomisation even\\nfurther, imagine lazy chance where you fill a table a certain number of\\ntimes, randomise over the aggregate table and return the result.\\n\\n```lua\\nlocal items = {\\n\\t-- [\\"LootName\\"] = Number of times to be added\\n\\t[\\"Diamond\\"] = 1,\\n\\t[\\"Jade\\"] = 5,\\n\\t[\\"Phosphophyllite\\"] = 10\\n}\\nlocal aggregate = {}\\n\\nfor name, times in items do\\n\\tfor i = 1, times do\\n\\t\\ttable.insert(aggregate, name)\\n\\tend\\nend\\n\\nlocal pickedItem = aggregate[Random.new():NextInteger(1, #aggregate)]\\nprint(pickedItem)\\n```\\n\\nThe items table forms ranges for each item that will become the result if\\nthe number from the randomisation falls in that range. A weighted system\\neffectively does this same thing but mathematically so that you aren\'t\\nleft with a giant table that\'s been reallocated and resized to try and fit\\nall your items.","source":{"line":52,"path":"src/lootplan/SingleLootPlan.lua"}}')}}]);