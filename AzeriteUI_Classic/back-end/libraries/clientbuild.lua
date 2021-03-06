local LibClientBuild = Wheel:Set("LibClientBuild", 34)
if (not LibClientBuild) then
	return
end

-- Lua API
local _G = _G
local pairs = pairs
local select = select
local string_match = string.match
local tonumber = tonumber
local tostring = tostring

LibClientBuild.embeds = LibClientBuild.embeds or {}

local currentClientPatch, currentClientBuild = GetBuildInfo() 
currentClientBuild = tonumber(currentClientBuild)

local builds = {
	["Classic"] = 33526,
		["1.13.2"] = 31446,
		["1.13.3"] = 33526,
		["1.13.4"] = 33598
}
local clientPatchRequirements = {
	["1.13.2"] = "1.13.2",
	["1.13.3"] = "1.13.3",
	["1.13.4"] = "1.13.4"
}
local clientIsAtLeast = {}
for version, build in pairs(builds) do
	if (currentClientBuild >= build) then
		clientIsAtLeast[version] = true 
		clientIsAtLeast[build] = true 
		clientIsAtLeast[tostring(build)] = true 
	end
end

-- Return the build number for a given patch.
-- Return current build if the given patch is the current. EXPERIMENTAL! 
LibClientBuild.GetBuildForPatch = function(self, version)
	return (currentClientPatch == version) and currentClientBuild or builds[version]
end 

-- Return the current WoW client build
LibClientBuild.GetBuild = function(self)
	return currentClientBuild
end 

-- Check if the current client is 
-- at least the requested version.
LibClientBuild.IsBuild = function(self, version)
	local clientPatchRequirement = clientPatchRequirements[version]
	if clientPatchRequirement then 
		return (clientPatchRequirement == currentClientPatch) and clientIsAtLeast[version]
	else 
		return clientIsAtLeast[version]
	end 
end

-- Module embedding
local embedMethods = {
	IsBuild = true,
	GetBuild = true, 
	GetBuildForPatch = true
}

LibClientBuild.Embed = function(self, target)
	for method in pairs(embedMethods) do
		target[method] = self[method]
	end
	self.embeds[target] = true
	return target
end

-- Upgrade existing embeds, if any
for target in pairs(LibClientBuild.embeds) do
	LibClientBuild:Embed(target)
end
