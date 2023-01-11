"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[661],{84051:e=>{e.exports=JSON.parse('{"functions":[],"properties":[{"name":"Multi","desc":"","lua_type":"MultiLootPlan","source":{"line":39,"path":"src/lootplan/MultiLootPlan.lua"}},{"name":"Single","desc":"","lua_type":"SingleLootPlan","source":{"line":56,"path":"src/lootplan/SingleLootPlan.lua"}}],"types":[{"name":"NumericalBatch","desc":"Any batch methods request a dictionary of key-value pairs to be passed;\\nthe key should be the name of a piece of loot in a loot table while the\\nvalue is the value to write in.\\n\\nRead the documentation of the non-batch version of the method to learn\\nhow the number given is used. For example, BatchAddLoot in either class\\nuses the key as the loot\'s name and the value as the weight or chance\\nrespectively.","lua_type":"{[string]: number}","source":{"line":60,"path":"src/lootplan/init.lua"}}],"name":"LootPlan","desc":"LootPlan is a lightweight utility library designed for use cases related to\\nrandom loot generation such as virtual random items and clear rewards in\\ndungeon crawlers. The code and documentation are modified from dogwarrior24\'s\\nwork on [LootPlan](https://devforum.roblox.com/t/lootplan/463702).\\n\\nLootPlan exposes two classes: [SingleLootPlan](/api/SingleLootPlan) and\\n[MultiLootPlan](/api/MultiLootPlan). As the names suggest, either class is\\ndesigned to roll for a set number of loot. The classes fundamentally differ\\nin how they randomise so it\'s important to pick one relevant to your case.\\n\\nLootPlan and its classes are purely abstract. The library handles the\\nmathematics, randomisation and results. This gives developers complete\\nflexibility over processing the results into tangible rewards in their own\\nsystems.\\n\\n:::caution Minimum one piece of loot\\nBoth LootPlan classes require at minimum one piece of loot added to their\\nloot tables to generate a result.\\n:::\\n\\n```lua\\n-- Create a SingleLootPlan\\nlocal gems = LootPlan.Single.new()\\n\\n-- Add our loot\\ngems:BatchAddLoot({\\n\\t[\\"Diamond\\"] = 1,\\n\\t[\\"Jade\\"] = 25,\\n\\t[\\"Phosphophyllite\\"] = 50,\\n})\\n\\n-- Generate a result\\nlocal gemName = gems:GetRandomLoot()\\n\\n-- Process the result\\nplayerInventory:AddMaterial({\\n\\tId = GetIdFromName(gemName),\\n\\tQuantity = 1\\n})\\n```","source":{"line":47,"path":"src/lootplan/init.lua"}}')}}]);