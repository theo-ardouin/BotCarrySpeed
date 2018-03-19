local _init = CriminalActionWalk.init
local _get_max_walk_speed = CriminalActionWalk._get_max_walk_speed
local _get_current_max_walk_speed = CriminalActionWalk._get_current_max_walk_speed

function CriminalActionWalk:init(action_desc, common_data)
  if not BotHelpers:IsCarryEnabled() then
    return _init(self, action_desc, common_data)
  end

	if common_data.ext_movement:carrying_bag() then
		local can_run = tweak_data.carry.types[BotHelpers:Carry()].can_run

		if not can_run and action_desc.variant == "run" then
			action_desc.variant = "walk"
		end
	end

	return CriminalActionWalk.super.init(self, action_desc, common_data)
end

function CriminalActionWalk:_get_max_walk_speed()
  if not BotHelpers:IsCarryEnabled() then
    return _get_max_walk_speed(self)
  end

	local speed = deep_clone(CriminalActionWalk.super._get_max_walk_speed(self))

	if self._ext_movement:carrying_bag() then
		local speed_modifier = tweak_data.carry.types[BotHelpers:Carry()].move_speed_modifier

		for k, v in pairs(speed) do
			speed[k] = v * speed_modifier
		end
	end
	return speed
end

function CriminalActionWalk:_get_current_max_walk_speed(move_dir)
  if not BotHelpers:IsCarryEnabled() then
    return _get_current_max_walk_speed(self, move_dir)
  end

	local speed = CriminalActionWalk.super._get_current_max_walk_speed(self, move_dir)

	if self._ext_movement:carrying_bag() then
		local speed_modifier = tweak_data.carry.types[BotHelpers:Carry()].move_speed_modifier
		speed = speed * speed_modifier
	end

	return speed
end
