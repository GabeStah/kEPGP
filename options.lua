local _G, _ = _G, _
local table, tinsert, tremove, wipe, sort, date, time, random = table, table.insert, table.remove, wipe, sort, date, time, random
local math, tostring, string, strjoin, strlen, strlower, strsplit, strsub, strtrim, strupper, floor, tonumber = math, tostring, string, string.join, string.len, string.lower, string.split, string.sub, string.trim, string.upper, math.floor, tonumber
local select, pairs, print, next, type, unpack = select, pairs, print, next, type, unpack
local loadstring, assert, error = loadstring, assert, error
local kEPGP = _G.kEPGP

kEPGP.defaults = {
	profile = {
		debug = {
			enabled = false,
			enableTimers = true,
			threshold = 1,
		},
		settings = {
			update = {
				auction = {
					interval = 1,
				},
				core = {
					interval = 1,
				},
			},
			raid = {
				active = nil,
			},
		},
		zones = {
			validZones = {
				"Baradin Hold",
				"Blackrock Mountain: Blackwing Descent",
				"Firelands",
				"The Bastion of Twilight",
				"Throne of the Four Winds",
				"Dragon Soul",
				"Throne of Thunder",
			},
			zoneSelected = 1,
		},
	},
};

-- Create Options Table
kEPGP.options = {
  name = "kEPGP",
  handler = kEPGP,
  type = 'group',
  args = {
		debug = {
			name = 'Debug',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle Debug mode',
					set = function(info,value) kEPGP.db.profile.debug.enabled = value end,
					get = function(info) return kEPGP.db.profile.debug.enabled end,
				},
				enableTimers = {
					name = 'Enable Timers',
					type = 'toggle',
					desc = 'Toggle timer enabling',
					set = function(info,value) kEPGP.db.profile.debug.enableTimers = value end,
					get = function(info) return kEPGP.db.profile.debug.enableTimers end,
				},
				threshold = {
					name = 'Threshold',
					desc = 'Description for Debug Threshold',
					type = 'select',
					values = {
						[1] = 'Low',
						[2] = 'Normal',
						[3] = 'High',
					},
					style = 'dropdown',
					set = function(info,value) kEPGP.db.profile.debug.threshold = value end,
					get = function(info) return kEPGP.db.profile.debug.threshold end,
				},
			},
			cmdHidden = true,
		},
		config = {
			type = 'execute',
			name = 'Config',
			desc = 'Open the Configuration Interface',
			func = function() 
				kEPGP.dialog:Open("kEPGP") 
			end,
			guiHidden = true,
        },    
        raid = {
			type = 'execute',
			name = 'raid',
			desc = 'Start or stop a raid - /kl raid [keyword] - start, begin, stop, end',
			func = function(...) 
				kEPGP:Manual_Raid(...)
			end,
			guiHidden = true,			
		},
		version = {
			type = 'execute',
			name = 'Version',
			desc = 'Check your kEPGP version',
			func = function() 
				kEPGP:Print("Version: |cFF"..kEPGP:Color_Get(0,255,0,nil,'hex')..kEPGP.version.."|r");
			end,
			guiHidden = true,
    },
	},
};

--[[ Implement default settings
]]
function kEPGP:Options_Default()
	-- self:Options_DefaultBidding()
	-- self:Options_DefaultRole()
end

-- --[[ Implement bidding default settings
-- ]]
-- function kEPGP:Options_DefaultBidding()
-- 	-- bidTypes
-- 	for i,v in pairs(self.bidTypes) do
-- 		if not self.db.profile.bidding.sets[i] then
-- 			self.db.profile.bidding.sets[i] = {
-- 				bidType = i,
-- 				selected = false,
-- 			}
-- 		end
-- 	end
-- 	self:Options_ResetSelected(self.db.profile.bidding.sets)
-- end

-- --[[ Implement Role default settings
-- ]]
-- function kEPGP:Options_DefaultRole()
-- 	local data
-- 	-- bidTypes
-- 	for i,v in pairs(self.db.profile.editors) do
-- 		-- Check if string type
-- 		if type(v) == 'string' then
-- 			data = data or {}
-- 			tinsert(data, {
-- 				player = v,
-- 				selected = false,
-- 			})
-- 		end
-- 	end
-- 	if data then
-- 		self.db.profile.editors = data
-- 		self:Options_ResetSelected(self.db.profile.editors)
-- 	end
-- end

--[[ Generate all custom options tables
]]
function kEPGP:Options_Generate()
	
end