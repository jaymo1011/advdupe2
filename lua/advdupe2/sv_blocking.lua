--[[
	Title: Adv. Duplicator 2 Blocking
	
	Desc: Allows blocking of entitys based off the player's rank
	
	Author: Jaymo
	
	Version: 1.1
]]

require "duplicator"

if not file.Exists("advdupe2/EntBlacklist.txt", "DATA") then file.Write("advdupe2/EntBlacklist.txt", util.TableToJSON({["prop_physics"] = "user"})) end
local ENTITY = FindMetaTable("Entity")
local OnTheSafeSide = true

local function UpdateBlacklistFile(todo, ent, rank)

	local blacklistFile = util.JSONToTable(file.Read("advdupe2/EntBlacklist.txt", "DATA"))
	if OnTheSafeSide then Msg("Adv Dupe 2 Blacklist Table Modification\nBefore:\n") PrintTable(blacklistFile) Msg("\n") end
	
	local entGroup = {} if rank == "all" or rank == nil then entGroup.Name = "all" else entGroup = CAMI.GetUsergroup(rank) end
	local entClass = "" if IsEntity(ent) then entClass = ent:GetClass() elseif tostring(ent) then entClass = ent else return false end

	if todo == "add" or todo == true then

		blacklistFile[string.lower(tostring(entClass))] = string.lower(tostring(entGroup.Name))
		file.Write("advdupe2/EntBlacklist.txt", util.TableToJSON(blacklistFile))

		if OnTheSafeSide then Msg("After:\n") PrintTable(blacklistFile) Msg("\n") end
		
		return

	elseif todo == "remove" or todo == false then

		blacklistFile[string.lower(tostring(entClass))] = nil
		file.Write("advdupe2/EntBlacklist.txt", util.TableToJSON(blacklistFile))

		if OnTheSafeSide then Msg("After:\n") PrintTable(blacklistFile) Msg("\n") end
		
		return

	elseif todo == nil then
	
		if OnTheSafeSide then Msg("After:\n") PrintTable(blacklistFile) Msg("\n") end
		
		return
	
	end
	
end

--[[
	Name:	Ent:AdvDupe2SetCanDupe
	Desc:	Sets if an entity can be duped or not.
	Params:	<string/boolean> todo, <string> rank
	Return:	<boolean> success
]]
function ENTITY:AdvDupe2DupeAllowed(todo, rank)

	local lrank = rank or nil
	UpdateBlacklistFile(todo, self, lrank)

end

--[[
	Name:	AdvDupe2DupeAllowed
	Desc:	Sets if an entity can be duped or not.
	Params:	<string/boolean> todo, <entity> ent, <string> rank
	Return:	<boolean> success
]]
function AdvDupe2.SetDupeAllowed(todo, ent, rank)

	local lrank = rank or nil
	UpdateBlacklistFile(todo, ent, rank)

end

--[[
	Name:	AdvDupe2CanDupe
	Desc:	Returns if a player can dupe an entity based on it their current rank
	Params:	<player> ply, <string> entclass
	Return:	<boolean> success
]]
function AdvDupe2.CanDupe(ply, entclass)

	if not SERVER then return end
	local blacklistFile = util.JSONToTable(file.Read("advdupe2/EntBlacklist.txt", "DATA"))

	if blacklistFile[entclass] then
		if blacklistFile[entclass] == "all" then return false end
		local entNeededGroup = CAMI.GetUsergroup(blacklistFile[entclass])
		if ply:CheckGroup(entNeededGroup.Name) then return true else return false end
	end

end