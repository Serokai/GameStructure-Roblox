local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Component = require(Packages.Component)
local Trove = require(Packages.Trove)

local ExampleComponent = Component.new({
    Tag = "ExampleComponent",
})

function ExampleComponent:Construct()
    self._trove = Trove.new()
end

function ExampleComponent:Start()
    
end

function ExampleComponent:Stop()
    self._trove:Destroy()
end

return ExampleComponent