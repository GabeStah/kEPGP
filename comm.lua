local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random, tContains = table, table.insert, table.remove, wipe, sort, date, time, random, tContains
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

--[[ Trigger when raid is created
]]
function kEPGP:Comm_RaidCreate(id)
  if not id or not self:Raid_Get(id) then return end
  self:Comm_Send('RaidCreate', 'c', 'RAID', id)
end

--[[ Trigger when raid is destroyed
]]
function kEPGP:Comm_RaidDestroy(id)
  if not id or not self:Raid_Get(id) then return end
  self:Comm_Send('RaidDestroy', 'c', 'RAID', id)
end

--[[ Trigger when raid is created
]]
function kEPGP:Comm_RoleAdd(role, player)
  if not role or not player then return end
  self:Comm_Send('RoleAdd', 'c', 'RAID', role, player)
end

--[[ Trigger when raid is created
]]
function kEPGP:Comm_RoleDelete(role, player)
  if not role or not player then return end
  self:Comm_Send('RoleDelete', 'c', 'RAID', role, player)
end

--[[ Trigger when role response is generated
]]
function kEPGP:Comm_RoleResponse()
  -- Create role>player list string
  local sync = self:Role_GetResponseString()
  if sync then
    self:Comm_Send('RoleResponse', 'c', 'RAID', sync)
  end
end