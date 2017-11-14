_G.BotCarrySpeed = _G.BotCarrySpeed or {}
BotCarrySpeed._path = ModPath
BotCarrySpeed._data_path = SavePath .. "bot_carry_speed.json"
BotCarrySpeed.settings = {
  carry = 1
}

BotCarrySpeed._carry_types = {
  nil,
  "light",
  "medium",
  "heavy",
  "very_heavy"
}

function BotCarrySpeed:Load()
  local file = io.open(self._data_path, "r")
  if file then
		self.settings = json.decode(file:read("*all"))
		file:close()
	end
end

function BotCarrySpeed:Save()
	local file = io.open(self._data_path, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function BotCarrySpeed:IsEnabled()
  log(tostring(self.settings["carry"]))
  return self.settings["carry"] ~= 1
end

function BotCarrySpeed:Carry()
  return self._carry_types[self.settings["carry"]]
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_BotCarrySpeed", function(loc)
  loc:load_localization_file(BotCarrySpeed._path .. "loc/en.txt")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_BotCarrySpeed", function(menu_manager)
  MenuCallbackHandler.OnSetCarry = function(self, item)
    BotCarrySpeed.settings["carry"] = item:value()
    BotCarrySpeed:Save()
  end

  BotCarrySpeed:Load()
  MenuHelper:LoadFromJsonFile(BotCarrySpeed._path .. "menu/options.txt", BotCarrySpeed, BotCarrySpeed.settings)
end)
