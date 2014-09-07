local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random, tContains = table, table.insert, table.remove, wipe, sort, date, time, random, tContains
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

--[[ Prompt to resume active raid
]]
function kEPGP:View_PromptResumeRaid()
  local raid = self:Raid_Get()
  if not raid then return end
  local dialog = self:View_Dialog_Create('ResumeRaid',
    'Do you wish to resume the currently active raid?')
  self:View_DialogButton_Create('resume', 'Resume', dialog, function() 
    self:Raid_Resume()
    dialog.Close()
  end)
  self:View_DialogButton_Create('new', 'New Raid', dialog, function()
    self:Raid_End()
    self:Raid_Start()
    dialog.Close()
  end)
end