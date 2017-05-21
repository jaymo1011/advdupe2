TOOL.Category = "Props Tool"
TOOL.Name = "Adv Dupe 2 Restriction"
TOOL.Command = nil
TOOL.ConfigName = "" 
 
TOOL.ClientConVar["rank"] = "all"

if(CLIENT) then
	TOOL.Information = {
		{name = "info", stage = 0},
		{name = "left"},
		{name = "right"},
		--{name = "reload"},
	}
end


function TOOL:LeftClick(trace)
	if game.SinglePlayer() and SERVER then self:GetOwner():GetActiveWeapon():CallOnClient("PrimaryAttack") end
	
	local ent,pos = trace.Entity, trace.HitPos
	if (!pos) then return false end
	if SERVER then 
		if IsValid(ent) then AdvDupe2.SetDupeAllowed("add", ent, self:GetOwner():GetInfo("advdupe2blacklister_rank")) end
	end
	return true
end
 
function TOOL:RightClick(trace)
	if game.SinglePlayer() and SERVER then self:GetOwner():GetActiveWeapon():CallOnClient("PrimaryAttack") end
	
	local ent,pos = trace.Entity, trace.HitPos
	if (!pos) then return false end
	if SERVER then 
		if IsValid(ent) then AdvDupe2.SetDupeAllowed("remove", ent) end
	end
	return true
end
 
function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", {Text = "Adv Dupe 2 Restriction"})
		
	local toolrank = vgui.Create("DTextEntry",panel)
		panel:AddPanel(toolrank)
		panel:ControlHelp("#tool.advdupe2blacklister.rank.help")
		toolrank:SetConVar("advdupe2blacklister_rank")
		toolrank:SetValue(GetConVarString("advdupe2blacklister_rank"))
	
	panel:AddControl("Header", {Description = [[This tool will restrict things from being duplicated by the Advanced Duplicator 2.
	
Set a rank in the above box then click on something
The rank will follow inheritence
To restrict an entity from everyone set the rank to "all"]]})

end


if CLIENT then
    language.Add("tool.advdupe2blacklister.name", "Adv Dupe 2 Restriction")
    language.Add("tool.advdupe2blacklister.desc", "Allows admins to blacklist and un-blacklist props")
	
	language.Add("tool.advdupe2blacklister.0", "By default this tool blacklists everyone from an entity. You can change this in the context menu")
    language.Add("tool.advdupe2blacklister.left", "Left Click on something to restrict it")
	language.Add("tool.advdupe2blacklister.right", "Right Click on something to un-restrict it")
	--language.Add("tool.advdupe2blacklister.reload", "Reload to ...")
	
	language.Add("tool.advdupe2blacklister.rank.help", "Rank to restrict entities from")
	language.Add("tool.advdupe2blacklister.help", "Set a rank in the above box then click on something!\nThe rank will follow inheritence\nTo restrict an entity from everyone set the rank to \"all\"")
end