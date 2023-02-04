if game:IsLoaded() == false then
	game.Loaded:Wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Loader = require(Packages.Loader)

for _, screenGui in ipairs(ReplicatedStorage.Guis.Replicated:GetChildren()) do
	screenGui:Clone().Parent = Players.LocalPlayer.PlayerGui
end

Loader.SpawnAll(
	Loader.LoadDescendants(script.Controllers, Loader.MatchesName("Controller$")),
	"OnStart"
)

Loader.LoadDescendants(script.Components)