---
sidebar_position: 1
---

# Getting Started

ColbertRbx is a repository of open source modules for Roblox designed specifically with [Wally](https://wally.run) (and therefore also [Rojo](https://rojo.space)) in mind. All of these modules are best acquired by adding the relevant dependency line in your project's Wally dependencies file (wally.toml). You may also visit the repository and grab the source code directly.

## Installing Wally and Rojo

My personal recommendation for installing Wally and Rojo is to first install [Aftman](https://github.com/lpghatguy/aftman). Aftman is a toolchain manager for project-specific command line tools. Having Aftman installed is great for quickly pulling in the relevant tools you need, like Wally and Rojo.

Once you have Aftman, you can add Wally and Rojo as tools in your Aftman configuration file (aftman.toml).

```toml
[tools]
rojo = "rojo-rbx/rojo@7.2.1"
wally = "UpliftGames/wally@0.3.1"
```

### Rojo Visual Studio Code Extension

If you're using Visual Studio Code (VSC) (I sure hope so!), you may find it helpful to install the Rojo VSC extension. You can find it in the marketplace as `evaera.vscode-rojo` (just searching Rojo will also produce the result). Note that if you don't have Rojo installed already, the extension will ask if you want it to install Rojo automatically for you which it also does through Aftman.

## Wally Configuration

Once you have Wally installed, run `wally init` on the root of your project's directory through a terminal. You can do this in Visual Studio Code itself by opening a new terminal (`F1` or `Ctrl + Shift + P` -> `Terminal: Create New Terminal`) or using another command line program available on your machine. This will create a new unpublished Wally package for your project which you can configure in the `wally.toml` file. You will only need to modify below the `dependencies` line.

:::danger Do not publish the package for game development
If you're only using Wally to get packages for a game codebase, do not publish the created package. Publishing is for developers who are writing open source modules for the Wally registry, not for publishing your game to Roblox. Don't make the mistake of uploading your entire game's codebase to the registry.
:::

To grab any package in ColbertRbx, add its dependency line under your package's dependencies section. Dependency lines can be found on the home page or in the [Wally registry](https://wally.run) (type `colbert2677/` to see packages I've uploaded and click the desired package to find the line on the package page).

As an example, your Wally package may look like this if you want to install **ReplicationUtils**:

```toml
[package]
name = "your_computer_account_name/your_project_name"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
ReplicationUtils = "colbert2677/ReplicationUtils@0.1.0"
```

:::tip Use PascalCase on the left side
If you grabbed the dependency line from the Wally registry, the left side of the equals sign will be lowercase. It's recommended that you change it to PascalCase. When syncing packages into Roblox Studio as will be explained later, the left side is what the instance name will be.

```lua
-- Using PascalCase
local ReplicationUtils = require(Packages.ReplicationUtils)

-- Using lowercase
local ReplicationUtils = require(Packages.replicationutils)
```
:::

Once you've picked out the packages you want for your project, pull up your terminal of choice again and run `wally install` on the project's root folder. This will create a Packages folder in your project directory where all the packages you've picked out will be installed. This command also creates a Wally lockfile (wally.lock): see [Wally Lockfile Format](https://github.com/upliftgames/wally#lockfile-format) for more information on its importance. *In other words, don't delete it.*

:::caution Do not commit the Packages folder
Make sure to add `/Packages` to your `.gitignore` file (or create one if you don't have one). The Packages folder contains the actual Luau code as well as require redirects of each Wally package.

If you do not have the Packages folder in your ignore folder, you will generate unstaged changes for version control each time you run `wally install` whether to add, remove or update packages. This is not behaviour you want; you only want to commit changes for `wally.toml` and `wally.lock`.
:::

## Rojo Configuration

After installing the packages with Wally, you should add the Packages folder to your Rojo project file so that the packages can be synced into Studio. It's strongly recommended that you have them install to their own folder in ReplicatedStorage so they can be accessed by all peers (server and clients) and so they can remain independent of other code in your project folder. Leave the automatically managed files to their own container.

Here's an example of what you may expect to write for your Rojo project:

```json
{
	"name": "colbertrbx-example",
	"tree": {
		"$className": "DataModel",

		"ReplicatedStorage": {
			"$className": "ReplicatedStorage",

			"Packages": {
				"$path": "Packages"
			}
		}
	}
}
```

## Using Packages in Roblox

Now that you've completed the Wally and Rojo portions of installing packages, you're ready to use them right away just like any other modules. Unless you're doing anything special, Packages are considered static files in your Roblox place so you can access them directly from the server or client without any WaitForChild.

```lua
-- Declare your services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Reference the folder containing the packages:
local Packages = ReplicatedStorage.Packages

-- Require the packages you want to use:
local ReplicationUtils = require(Packages.ReplicationUtils)

-- Use the modules:
local function playerAdded(player)
	local function characterAdded()
		ReplicationUtils:Replicate(player.Character)
	end

	player.CharacterAdded:Connect(characterAdded)
	if player.Character then
		characterAdded()
	end
end

Players.PlayerAdded:Connect(playerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	playerAdded(player)
end
```

## Next Steps

Go have a look around at some of the packages offered by ColbertRbx and their API [here](/api/).
