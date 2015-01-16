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
		ep = {		
			onlineCutoffPeriod = 3600,
			onlineEP = 1000,			
			punctualCutoffPeriod = 30,
			punctualEP = 200,
		},
		output = {
			enabled = true,
			channel = 'OFFICER',
			target = nil,
		},
		raids = {},
		reset = {
			enabled = true,
			rank = "F&F Raider",
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
			desc = 'Start or stop a raid - /kl raid [keyword] - start, begin, stop, end, revert, reverse',
			func = function(...) 
				kEPGP:Manual_Raid(...)
			end,
			guiHidden = true,			
		},
		ep = {
			name = 'Effort Points',
			type = 'group',
			args = {
				onlineEP = {
					name = 'Online EP',
					type = 'input',
					desc = 'Amount of EP awarded for Online EP bonus',
					pattern = '%d+',
					width = 'full',
					set = function(info,value) kEPGP.db.profile.ep.onlineEP = value end,
					get = function(info) return tostring(kEPGP.db.profile.ep.onlineEP) end,
					order = 1,
				},
				punctualEP = {
					name = 'Punctual EP',
					type = 'input',
					desc = 'Amount of EP awarded for Punctual EP bonus',
					pattern = '%d+',
					width = 'full',
					set = function(info,value) kEPGP.db.profile.ep.punctualEP = value end,
					get = function(info) return tostring(kEPGP.db.profile.ep.punctualEP) end,
					order = 2,
				},
				onlineCutoffPeriod = {
					name = 'Online Cutoff Seconds',
					type = 'input',
					desc = 'Seconds after raid start to earn Online EP',
					pattern = '%d+',
					width = 'full',
					set = function(info,value) kEPGP.db.profile.ep.onlineCutoffPeriod = value end,
					get = function(info) return tostring(kEPGP.db.profile.ep.onlineCutoffPeriod) end,
					order = 5,
				},					
				punctualCutoffPeriod = {
					name = 'Punctual Cutoff Seconds',
					type = 'input',
					desc = 'Seconds after raid start to earn Punctual EP',
					pattern = '%d+',
					width = 'full',
					set = function(info,value) kEPGP.db.profile.ep.punctualCutoffPeriod = value end,
					get = function(info) return tostring(kEPGP.db.profile.ep.punctualCutoffPeriod) end,
					order = 6,
				},				
			},
			cmdHidden = true,
		},
		output = {
			name = 'Output',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Toggle display of Output messages',
					set = function(info,value) kEPGP.db.profile.output.enabled = value end,
					get = function(info) return kEPGP.db.profile.output.enabled end,
					width = 'full',					
					order = 1,
				},
				channel = {
					name = 'Channel',
					desc = 'Channel to display Output Messages',
					type = 'select',
					values = {
						SAY = 'SAY',
						EMOTE = 'EMOTE',
						YELL = 'YELL',
						PARTY = 'PARTY',
						GUILD = 'GUILD',
						OFFICER = 'OFFICER',
						RAID = 'RAID',
						RAID_WARNING = 'RAID_WARNING',
						INSTANCE_CHAT = 'INSTANCE_CHAT',
						WHISPER = 'WHISPER',
						CHANNEL = 'CHANNEL',
					},
					style = 'dropdown',
					set = function(info,value) kEPGP.db.profile.output.channel = value end,
					get = function(info) return kEPGP.db.profile.output.channel end,
					order = 3,
				},
				target = {
					name = 'Target',
					desc = 'Whisper Target or Custom Channel Name',
					type = 'input',
					set = function(info,value) kEPGP.db.profile.output.target = value end,
					get = function(info) return kEPGP.db.profile.output.target end,					
					disabled = function(i) return (kEPGP.db.profile.output.channel ~= 'CHANNEL' and kEPGP.db.profile.output.channel ~= 'WHISPER') end,
					order = 4,
				},
			},
			cmdHidden = true,
		},
		reset = {
			name = 'Reset',
			type = 'group',
			args = {
				enabled = {
					name = 'Enabled',
					type = 'toggle',
					desc = 'Activate auto-reset of EP/GP upon raid creation.',
					set = function(info,value) kEPGP.db.profile.reset.enabled = value end,
					get = function(info) return kEPGP.db.profile.reset.enabled end,
					width = 'full',					
					order = 1,
				},
				rank = {
					name = 'Guild Rank Name',
					desc = 'Name of Guild Rank of players to be reset (also searches Guild Notes for matching string).',
					type = 'input',
					set = function(info,value) kEPGP.db.profile.reset.rank = value end,
					get = function(info) return kEPGP.db.profile.reset.rank end,					
					disabled = function(i) return not kEPGP.db.profile.reset.enabled end,
					width = 'full',
					order = 4,
				},
			},
			cmdHidden = true,
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