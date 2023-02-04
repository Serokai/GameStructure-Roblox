local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local ProfileService = require(Packages.ProfileService)
local BridgeNet = require(Packages.BridgeNet)
local Signal = require(Packages.GoodSignal)

local ProfileStore = ProfileService.GetProfileStore(
    "PlayerData",
    {
		Coins = 0
    }
)

local DataService = {
    Profiles = {},
	ProfileLoad = Signal.new(),
    rev_ProfileLoad = BridgeNet.CreateBridge("ProfileLoad"),
}

function DataService:GetData(player, data)
	return self.Profiles[player].Data[data]
end

function DataService:SetData(player, data, value)
	self.Profiles[player].Data[data] = value
end

function DataService:OnStart()
	local function onPlayerAdded(player)
		local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
		if profile ~= nil then
			profile:AddUserId(player.UserId)
			profile:Reconcile()
			profile:ListenToRelease(function()
				self.Profiles[player] = nil
				player:Kick()
			end)
			if player:IsDescendantOf(Players) == true then
				self.Profiles[player] = profile
				self.ProfileLoad:Fire(player, profile.Data)
                self.rev_ProfileLoad:FireTo(player, profile.Data)
				--ProfileStore:WipeProfileAsync("Player_" .. player.UserId)
			else
				profile:Release()
			end
		else
			player:Kick()
		end
	end

	local function onPlayerRemoving(player)
		local profile = DataService.Profiles[player]
		if profile ~= nil then
			profile:Release()
		end
	end

	local function onClose()
		if RunService:IsStudio() then
			return
		end

		for _, player in pairs(Players:GetPlayers()) do
			task.spawn(onPlayerRemoving(player))
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		task.defer(onPlayerAdded, player)
	end

	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)
	game:BindToClose(onClose)
end

return DataService