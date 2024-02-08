-- MADE BY MRK

ConfigJob                     = {}
ConfigJob.debug               = false                                                -- Set to true if you want to see the debug messages in console.
ConfigJob.NpcPosition         = { x = -1925.89, y = 553.83, z = 115.19, h = 250.77 } -- The position of the NPC.
ConfigJob.NpcName             = 'g_m_m_armboss_01'                                   -- The model for the NPC.
ConfigJob.NpcBlipSprite       = 84                                                   -- The sprite for the blip.
ConfigJob.NpcBlipColor        = 6                                                    -- The color for the blip.
ConfigJob.NpcBlipSize         = 0.8                                                  -- The size for the blip.
ConfigJob.NpcBlipName         = "Cleanse Ops"                                        -- The name for the blip.
ConfigJob.SetBlipAsShortRange = true                                                 -- Display the blip on the minimap only if the player is close to it.
ConfigJob.useTarget           = true                                                 -- Set to true if you're using QB-Target.
ConfigJob.MissionsCost        = 200                                                  -- The cost for buying a mission.

ConfigJob.Missions            = {
    [1] = {
        name = 'Kill the target', -- The name of the mission.
        reward = 1000,            -- The reward for the mission.
        PedPosition = {           -- The position of the target.
            x = -1923.5,
            y = 558.84,
            z = 114.83,
            h = 250.77,
        },
        IsPedAggressive = true,                   -- Set to true if the target has to be aggressive, otherwise he'll run away.
        PedName = 'g_m_y_famfor_01',              -- The model for the target.
        playingScenario = 'WORLD_HUMAN_PUSH_UPS', -- Optional. The animation to play for the target. IF THE PED NEEDS TO DRIVE A VEHICLE, THIS WILL BE IGNORED
        pedWeapon = 'WEAPON_PISTOL',              -- Optional. Weapon for the target.
        pedDrivingVehicle = '',                   -- The vehicle name the target needs to drive.
        pedNeedsToDriveFast = false               -- Set to true if the target needs to drive fast. False by default & false if not set.
    },
    [2] = {
        name = 'Elimination Protocol',
        reward = 1500,
        PedPosition = {
            x = 145.41,
            y = -1698.95,
            z = 29.29,
            h = 6.26,
        },
        IsPedAggressive = true,
        PedName = 'g_m_y_azteca_01',
        playingScenario = 'WORLD_HUMAN_SMOKING',
        pedWeapon = '',
        pedDrivingVehicle = '',
        pedNeedsToDriveFast = false
    },
    [3] = {
        name = 'Sorry, who are you again ?',
        reward = 1500,
        PedPosition = {
            x = 161.05,
            y = -556.81,
            z = 43.87,
            h = 358.65,
        },
        IsPedAggressive = false,
        PedName = 'a_m_y_business_02',
        playingScenario = 'WORLD_HUMAN_STAND_MOBILE_UPRIGHT',
        pedWeapon = '',
        pedDrivingVehicle = '',
        pedNeedsToDriveFast = false
    },
    [4] = {
        name = 'Operation Shadow Sweep',
        reward = 1500,
        PedPosition = {
            x = -440.59,
            y = 1103.03,
            z = 332.54,
            h = 74.31,
        },
        IsPedAggressive = true,
        PedName = 'a_m_m_eastsa_01',
        playingScenario = 'WORLD_HUMAN_LEANING',
        pedWeapon = '',
        pedDrivingVehicle = '',
        pedNeedsToDriveFast = false
    },
    [5] = {
        name = 'Rest in peace, buddy.',
        reward = 1500,
        PedPosition = {
            x = -956.06,
            y = 63.85,
            z = 50.61,
            h = 217.91,
        },
        IsPedAggressive = false,
        PedName = 'a_f_y_beach_01',
        playingScenario = 'WORLD_HUMAN_YOGA',
        pedWeapon = '',
        pedDrivingVehicle = '',
        pedNeedsToDriveFast = false
    },
    [6] = {
        name = 'Stop looking for me.',
        reward = 1500,
        PedPosition = {
            x = 966.86,
            y = -1629.91,
            z = 30.11,
            h = 66.28,
        },
        IsPedAggressive = false,
        PedName = 'a_m_m_prolhost_01',
        playingScenario = 'WORLD_HUMAN_CLIPBOARD',
        pedWeapon = '',
        pedDrivingVehicle = '',
        pedNeedsToDriveFast = false
    },
    [7] = {
        name = 'Drive carefully.',
        reward = 1500,
        PedPosition = {
            x = 825.82,
            y = 1273.53,
            z = 360.41,
            h = 281.25,
        },
        IsPedAggressive = false,
        PedName = 'a_m_m_prolhost_01',
        playingScenario = '',
        pedWeapon = '',
        pedDrivingVehicle = 'futo',
        pedNeedsToDriveFast = false
    },
}

ConfigJob.Lang                = {
    ['buy_mission'] = 'Buy a mission for $',
    ['not_enough_money'] = 'You don\'t have enough cash.',
    ['mission_bought'] = 'You have purchased a mission.',
    ['gps_set'] = '"I put the address on your GPS. Go kick his ass."',
    ['already_have_mission'] = 'You already have a mission.',
    ['reward_message_1'] = 'You received $',
    ['reward_message_2'] = ' for doing the job.',
}
