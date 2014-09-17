local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

function kEPGP:Test_Actor_UpdateOnline(actorName, online)
  self:Debug('Test_Actor_UpdateOnline started', 1)
  local count = GetNumGuildMembers()
  -- Pull basic data from GuildRosterInfo
  for i=1,count do
    local name,_, _, _, class, _, note, officerNote = GetGuildRosterInfo(i)   
    --self:Debug('Test_Actor_UpdateOnline', name, class, note, officerNote, 1)
    -- Get EPGP info
    ep, gp, main = EPGP:GetEPGP(self:Actor_Name(name))
    hasStanding = (ep and (not main)) and true or false
    if kEPGP:Actor_NameOnly(name) == actorName then
      -- Match
      self:Actor_Update(name, GetRealmName(), online, false, time(), note, officerNote, main, hasStanding)
      self:Debug('Test_Actor_UpdateOnline for', name, 1)
    end
  end
end