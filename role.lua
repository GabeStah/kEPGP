local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

--[[ Determine if a Player is assigned Administrator Role
@[player] string (Default: 'player') - Player name
return boolean - Result of role match
]]
function kEPGP:Role_IsAdmin(player)
  player = player or UnitName('player')
  if not UnitExists(player) then return end
  return (GetNumGroupMembers() and CanEditOfficerNote()) or (GetNumGroupMembers() == 0 and player == UnitName('player') and CanEditOfficerNote())
end