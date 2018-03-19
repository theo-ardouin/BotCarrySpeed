_G.BotHelpers = _G.BotHelpers or {}
BotHelpers._path = ModPath
BotHelpers._data_path = SavePath .. "bot_helpers.json"
BotHelpers.settings = {
  carry = 1
}

BotHelpers._carry_types = {
  nil,
  "light",
  "medium",
  "heavy",
  "very_heavy"
}

function BotHelpers:Load()
  local file = io.open(self._data_path, "r")
  if file then
		self.settings = json.decode(file:read("*all"))
		file:close()
	end
end

function BotHelpers:Save()
	local file = io.open(self._data_path, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

-- https://bitbucket.org/TdlQ/payday-2-luajit/src/e62d9c50343880050358beb7c631534f42009442/lib/managers/playermanager.lua?at=default&fileviewer=file-view-default#playermanager.lua-1085
function BotHelpers:Respawn()
  local random_ai = nil
  local player = managers.player:player_unit()
  for _, ai in pairs(managers.groupai:state():all_AI_criminals()) do
		if ai and alive(ai.unit) then
      random_ai = ai
      break
		end
  end
  if random_ai then
    log("Respawning on AI")
    managers.player:warp_to(random_ai.unit:position(), player:rotation())
  end
end

function BotHelpers:IsCarryEnabled()
  log(tostring(self.settings["carry"]))
  return self.settings["carry"] ~= 1
end

function BotHelpers:Carry()
  return self._carry_types[self.settings["carry"]]
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_BotHelpers", function(loc)
  loc:load_localization_file(BotHelpers._path .. "loc/en.txt")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_BotHelpers", function(menu_manager)
  MenuCallbackHandler.OnSetCarry = function(self, item)
    BotHelpers.settings["carry"] = item:value()
    BotHelpers:Save()
  end

  MenuCallbackHandler.OnRespawn = function(self, item)
    if Utils:IsInHeist() then
      BotHelpers:Respawn()
    end
  end

  BotHelpers:Load()
  MenuHelper:LoadFromJsonFile(BotHelpers._path .. "menu/options.txt", BotHelpers, BotHelpers.settings)
end)

--managers.player:warp_to(closest_pos, player_unit:rotation())