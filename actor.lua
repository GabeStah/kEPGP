local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

--[[ Create new Actor entry
]]
function kEPGP:Actor_Create(name, realm, class, online, inRaid, time, guildNote, officerNote, mainCharacter, hasStanding)
  if self:Actor_NameHasRealm(name) then realm = self:Actor_NameHasRealm(name) end
  local actor = {
    class = class,          
    events = {
      {
        inRaid = inRaid,
        online = online,
        time = time or time(),
      },
    },
    guildNote = guildNote,
    hasStanding = hasStanding,
    officerNote = officerNote,
    mainCharacter = mainCharacter,
    name = self:Actor_NameOnly(name), 
    objectType = 'actor',
    realm = realm or GetRealmName(),
  }
  existing = self:Actor_Get(name, realm)
  if existing then
    -- Update
    self:Actor_Update(name, realm, online, inRaid, time, guildNote, officerNote, mainCharacter, hasStanding)
    return existing
  else
    -- Add
    tinsert(self.actors, actor)
  end
  return actor
end

--[[ Get actor object
]]
function kEPGP:Actor_Get(name, realm)
  if not name then return end
  realm = realm or GetRealmName()
  if type(name) == 'string' then
    if self:Actor_NameHasRealm(name) then realm = self:Actor_NameHasRealm(name) end
    for i,v in pairs(self.actors) do
      if v.name == self:Actor_NameOnly(name) and v.realm == realm then
        return self.actors[i]
      end
    end
  elseif type(name) == 'table' then
    if name.objectType and name.objectType == 'actor' then return name end
  end
end

function kEPGP:Actor_IsOnline(actor, includeAlts)
  actor = self:Actor_Get(actor)
  if not actor then return end
  -- Find last event, check if online
  local event = actor.events[#actor.events]
  if event.online then return event.online end  
  if includeAlts then
    -- Scan for alts
    name = kEPGP:Actor_Name(actor)
    local altCount = EPGP:GetNumAlts(name)
    if altCount >= 0 then
       for count=1,altCount do
          alt = self:Actor_Get(EPGP:GetAlt(name, count))
          event = alt.events[#alt.events]
          if event.online then return event.online end
       end
    end
  end
  return false
end

function kEPGP:Actor_Name(actor, includeRealm)
  -- actor = self:Actor_Get(actor)
  -- if not actor then return end
  -- if includeRealm then
  --   return ('%s-%s'):format(actor.name, actor.realm)
  -- else
  --   return actor.name
  -- end  
  if not actor then return end
  local actor_object = self:Actor_Get(actor)
  local realm = GetRealmName()
  local name, index = gsub(actor_object and actor_object.name or actor, ('-%s'):format(realm), '')      
  if includeRealm then
    return index >= 0 and ('%s-%s'):format(name, actor_object and actor_object.realm or realm) or actor
  else
    return name
  end
end

function kEPGP:Actor_NameHasRealm(actor)
  if not actor then return end
  return strmatch(actor, '-(.+)')
end

function kEPGP:Actor_NameOnly(actor)
  if not actor then return end
  return strmatch(actor, '(.+)-.+') and strmatch(actor, '(.+)-.+') or actor
end

--[[ Update actor entry in raid table
]]
function kEPGP:Actor_Update(name, realm, online, inRaid, time, guildNote, officerNote, mainCharacter, hasStanding)
  if not name then 
    self:Debug('Actor_Update', 'No name found.', 1)
    return
  end
  local actor = self:Actor_Get(name, realm)
  if actor then
    --self:Debug('Actor_Update', 'Actor found:', actor, 1)
    -- Check if last event online status does not match current online status
    if actor.events and #actor.events >= 1 then
      --self:Debug('Actor_Update', 'Actor events found:', actor.events, 1)
      if (actor.events[#actor.events].online ~= online) or (actor.events[#actor.events].inRaid ~= inRaid) then
        --self:Debug('Actor_Update', 'Actor online or inRaid mismatch, updating.', 1)
        -- Create new event
        local event = {
          inRaid = inRaid,
          online = online,
          time = time or time(),
        }
        tinsert(actor.events, event)
      end
    end
    -- Update fields
    actor.guildNote = guildNote
    actor.officerNote = officerNote
    actor.mainCharacter = mainCharacter
    actor.hasStanding = hasStanding
    return true -- Found, return true
  end
end