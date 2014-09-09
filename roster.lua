local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

--[[ Update full roster from raid/guild rosters
]]
function kEPGP:Roster_Update()
  -- from guild
  local count = GetNumGuildMembers()
  local currentTime = time()
  local realm = GetRealmName()
  local hasStanding, ep, gp, main
  for i=1,count do
    local name,_, _, _, class, _, note, officerNote, online = GetGuildRosterInfo(i)   
    -- Get EPGP info
    ep, gp, main = EPGP:GetEPGP(self:Actor_Name(name))
    hasStanding = (ep and (not main)) and true or false
    self:Actor_Create(name, realm, class, online and true or false, false, currentTime, note, officerNote, main, hasStanding)
  end 

  -- From raid
  local count, name, class, online = self:Utility_GetPlayerCount()
  if count == 1 then
    -- Get EPGP info
    ep, gp, main = EPGP:GetEPGP(self:Actor_Name(name))
    hasStanding = (ep and (not main)) and true or false    
    self:Actor_Create(UnitName('player'), realm, UnitClass('player'), true, true, currentTime, nil, nil, main, hasStanding)
  else
    for i=1,count do
      name, _, _, _, class, _, _, online = GetRaidRosterInfo(i)
      -- Get EPGP info
      ep, gp, main = EPGP:GetEPGP(self:Actor_Name(name))
      hasStanding = (ep and (not main)) and true or false
      self:Actor_Create(name, self:Actor_NameHasRealm(name) or realm, class, online and true or false, true, currentTime, nil, nil, main, hasStanding)
    end 
  end
end

--[[ Rebuild full roster from raid/guild rosters
]]
function kEPGP:Roster_Rebuild()
  self:Guild_RebuildRoster()
  self:Raid_RebuildRoster()
  self.roster.full = self:Roster_Generate()
end

--[[ Generate and return current guild roster
]]
function kEPGP:Guild_GenerateRoster()
  GuildRoster()
  local count = GetNumGuildMembers()
  local roster, currentTime = {}, time()
  local realm = GetRealmName()
  local hasStanding
  for i=1,count do
    local name,_, _, _, class, _, note, officerNote, online = GetGuildRosterInfo(i)   
    -- Get EPGP info
    ep, gp, main = EPGP:GetEPGP(self:Actor_Name(name))
    hasStanding = (ep and (not main)) and true or false
    roster[name] = self:Actor_Create(name, realm, class, online and true or false, false, currentTime, note, officerNote, main, hasStanding)
  end 
  return roster
end

--[[ Rebuild temporary guild roster
]]
function kEPGP:Guild_RebuildRoster()
  local roster = self:Guild_GenerateRoster()
  self.roster.guild = self.roster.guild or {}
  for i,v in pairs(roster) do
    self.roster.guild[i] = v
  end
  for i,v in pairs(self.roster.guild) do
    local found = false
    for iRoster,vRoster in pairs(roster) do
      if iRoster == i then found = true end
    end
    if not found then
      self:Debug('Guild_RebuildRoster', 'Offline detected:', i, 1)
      self.roster.guild[i].events[#self.roster.guild[i].events].online = false
    end
  end
end