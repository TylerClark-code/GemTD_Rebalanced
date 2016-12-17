-- Constant placed up here so its easy to see
PLACED_BUILDING_RADIUS = 20.0;
function placeBuilding(keys)
    -- We need a few variables. They should be self-explanatory
    blocking_counter = 0

    attempt_place_location = keys.target_points[1]
    -- Hoooooly complicated! Basically, this line finds all entities within PLACED_BUILDING_RADIUS of where we want to put the tower
    -- The for loop then counts them
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        -- is this a valid blocker?
        if thing:GetClassname() == "npc_dota_creature" then
            blocking_counter = blocking_counter + 1
            print("blocking creature")
        end
    end
    print(blocking_counter .. " blockers")

    -- If there are any entities to block us placing the tower, don't place it, otherwise: do!
    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_dota_building_homebase", keys.target_points[1], false, nil, nil,keys.caster:GetPlayerOwner():GetTeam() ) 
        -- Rotate it as we want
        --tower:SetAngles(0.0,0.0,0.0)
        --tower:SetSize(Vector(0.1,0.1,0.1),Vector(0.1,-0.1,0.1))
    end
end

function removeBuilding(keys)
    -- We need a few variables. They should be self-explanatory
    blocking_counter = 0

    attempt_place_location = keys.target_points[1]
    -- Hoooooly complicated! Basically, this line finds all entities within PLACED_BUILDING_RADIUS of where we want to put the tower
    -- The for loop then counts them
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        -- is this a valid blocker?
        if thing:GetClassname() == "npc_dota_creature" then
            blocking_counter = blocking_counter + 1
            print("blocking creature")
        end
    end
    print(blocking_counter .. " blockers")

    if( blocking_counter == 1) then
        for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
            -- is this a valid blocker?
            if thing:GetClassname() == "npc_dota_creature" then
                print("removing wall")
                UTIL_Remove(thing)
            end
        end
    end

    -- If there are any entities to block us placing the tower, don't place it, otherwise: do!

end 

function placeRuby(keys)
    -- We need a few variables. They should be self-explanatory
  local  blocking_counter = 0
  local p = keys.target_points[1]
  local  attempt_place_location = keys.target_points[1]
    -- Hoooooly complicated! Basically, this line finds all entities within PLACED_BUILDING_RADIUS of where we want to put the tower
    -- The for loop then counts them
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS+20) )  do
        -- is this a valid blocker?
        if thing:GetClassname() == "npc_dota_creature" then
            blocking_counter = blocking_counter + 1
            print("blocking creature")
        end
    end
    print(blocking_counter .. " blockers")

    -- If there are any entities to block us placing the tower, don't place it, otherwise: do!
    if( blocking_counter < 1) then
--        tower = CreateUnitByName("npc_dota_chipped_ruby", keys.target_points[1], false, nil, nil,keys.caster:GetPlayerOwner():GetTeam() )
        local ran = RandomInt(1,8)
        local stone_level = "1"
 
        local create_stone_name = GameRules.gem_tower_basic[ran]..stone_level

        if GameRules.crab ~= nil then
            create_stone_name = "gemtd_"..GameRules.crab
            GameRules.crab = nil
        end
        print(create_stone_name)
        u = CreateUnitByName(create_stone_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS)
    end
end

function gemtd_build_stone(keys)
  local caster = keys.caster
  local owner =  caster:GetOwner()
  local player_id = owner:GetPlayerID()
  local p = keys.target_points[1]

  local hero_level = caster:GetLevel()

  -- if GameRules.game_status ~= 1 then
  --  return
  -- end

  -- find_all_path()

  --play_particle("particles/generic_gameplay/screen_arcane_drop.vpcf",PATTACH_EYES_FOLLOW,caster,2)

  -- print("GameRules:GetGameModeEntity().hero:")
  -- for iii,jjj in pairs(GameRules:GetGameModeEntity().hero) do
  --  print(iii..">>>"..jjj:GetUnitName())
  -- end
  
--  CustomNetTables:SetTableValue( "game_state", "disable_repick", { heroindex = caster:GetEntityIndex(), hehe = RandomInt(1,10000) } );

  --网格化坐标
  local xxx = math.floor((p.x+64)/128)+19
  local yyy = math.floor((p.y+64)/128)+19
  p.x = math.floor((p.x+64)/128)*128
  p.y = math.floor((p.y+64)/128)*128

  --GameRules:SendCustomMessage("x="..xxx..",y="..yyy, 0, 0)

  --path1和path7附近 不能造
  if xxx>=29 and yyy<=9 then
    EmitGlobalSound("ui.crafting_gem_drop")
    --caster:DestroyAllSpeechBubbles()
    --caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
    createHintBubble(caster,"#text_cannot_build_here")
    return
  end

  if xxx<=10 and yyy>=31 then
    EmitGlobalSound("ui.crafting_gem_drop")
    --caster:DestroyAllSpeechBubbles()
    --caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
    createHintBubble(caster,"#text_cannot_build_here")
    return
  end




  --附近有怪，不能造
  local uu = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              p,
                              nil,
                              192,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
  if table.getn(uu) > 0 then
    EmitGlobalSound("ui.crafting_gem_drop")
    --caster:DestroyAllSpeechBubbles()
    --caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
    createHintBubble(caster,"#text_cannot_build_here")
    --GameRules:SendCustomMessage("附近有怪，不能造", 0, 0)
    return
  end

  --附近有友军单位了，不能造
  local uuu = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              p,
                              nil,
                              50,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
  if table.getn(uuu) > 0 then
    EmitGlobalSound("ui.crafting_gem_drop")
    --caster:DestroyAllSpeechBubbles()
    --caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
    createHintBubble(caster,"#text_cannot_build_here")
    --GameRules:SendCustomMessage("附近有友军单位了，不能造", 0, 0)
    return
  end

  
  if GetMapName() == "gemtd_coop" then
    --路径点，不能造
    for i=1,7 do
      local p1 = Entities:FindByName(nil,"path"..i):GetAbsOrigin()
      local xxx1 = math.floor((p1.x+64)/128)+19
      local yyy1 = math.floor((p1.y+64)/128)+19
      if xxx==xxx1 and yyy==yyy1 then
        EmitGlobalSound("ui.crafting_gem_drop")
        --caster:DestroyAllSpeechBubbles()
        --caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
        createHintBubble(caster,"#text_cannot_build_here")
        --GameRules:SendCustomMessage("路径点，不能造", 0, 0)
        return
      end
    end
    
  else
    for c=1,4 do
      for i=1,7 do
        local p1 = Entities:FindByName(nil,"path"..c..i):GetAbsOrigin()
        local xxx1 = math.floor((p1.x+64)/128)+19
        local yyy1 = math.floor((p1.y+64)/128)+19
        if xxx==xxx1 and yyy==yyy1 then
          EmitGlobalSound("ui.crafting_gem_drop")
          --caster:DestroyAllSpeechBubbles()
          --caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
          createHintBubble(caster,"#text_cannot_build_here")
          --GameRules:SendCustomMessage("路径点，不能造", 0, 0)
          return
        end
      end
      
    end
  end

  --地图范围外，不能造
  if xxx<1 or xxx>37 or yyy<1 or yyy>37 then
    EmitGlobalSound("ui.crafting_gem_drop")
    --caster:DestroyAllSpeechBubbles()
    --caster:AddSpeechBubble(1,"#text_cannot_build_here",2,0,30)
    createHintBubble(caster,"#text_cannot_build_here")
    --GameRules:SendCustomMessage("地图范围外，不能造", 0, 0)
    return
  end

  if (GameRules:GetGameModeEntity().gem_map == nil) then
    GameRules:GetGameModeEntity().gem_map ={}
    for i=1,37 do
        GameRules:GetGameModeEntity().gem_map[i] = {}   
        for j=1,37 do
           GameRules:GetGameModeEntity().gem_map[i][j] = 0
        end
    end
  end
  GameRules:GetGameModeEntity().gem_map[yyy][xxx]=1
  --尝试寻找路径
  find_all_path()

  if GetMapName() == "gemtd_coop" then
    --路完全堵死了，不能造
    for i=1,6 do
      if table.maxn(GameRules.gem_path[i])<1 then
        EmitGlobalSound("ui.crafting_gem_drop")
        --caster:DestroyAllSpeechBubbles()
        --caster:AddSpeechBubble(1,"#text_donnot_block_the_path",2,0,30)
        createHintBubble(caster,"#text_donnot_block_the_path")
        --回退地图，重新寻路
        GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

        find_all_path()
        return
      end
    end
  else
    for c=1,4 do
      for i=1,6 do
        if table.maxn(GameRules.gem_path_speed[c][i])<1 then
          EmitGlobalSound("ui.crafting_gem_drop")
          --caster:DestroyAllSpeechBubbles()
          --caster:AddSpeechBubble(1,"#text_donnot_block_the_path",2,0,30)
          createHintBubble(caster,"#text_donnot_block_the_path")
          --回退地图，重新寻路
          GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

          find_all_path()
          return
        end
      end
    end
  end

  ---------------------------------------------------------------------
  --至此验证ok了，可以正式开始建造石头了
  --------------------------------------------------------------------

  -- --概率用百分比来表示，所以有一百种选择
  -- --石头种类有table.maxn(GameRules.gem_tower_basic)种
  -- --所以模这两个数的乘积，下面出现的所有100 都表示百分比
  -- local hero_name = PlayerResource:GetSelectedHeroName(player_id)
  -- local conflict_solver = 0
  -- for i = 1,player_id-1 do
  --  if (PlayerResource:IsValidPlayer(i) and PlayerResource:GetSelectedHeroName(i) == hero_name) then
  --    conflict_solver = conflict_solver + 1
  --  end
  -- end
  -- if (conflict_solver ~= 0) then
  --  hero_name = hero_name .. conflict_solver
  -- end

  -- local m = 100*table.maxn(GameRules.gem_tower_basic)
  -- --local d = RandomInt(1, 100)
  -- --local ran32_modulo_m = RandomInt(1, m)
  -- --if (d < GameRules.map_similarity[hero_level]) then -- 用预设值，而不是纯随机
  --  -- tostring(...) 给了每一轮不同位置的点一个不同的值
  --  -- +offset 防御差分攻击
  --  -- idx 确保每次生成的格子都是唯一的
  --  local idx = GameRules.level * GameRules.max_grids + xxx * GameRules.max_xy + yyy + GameRules:GetGameModeEntity().rng.offset
  --  local ran32 = hash32( tostring(idx) ..  hero_name .. GameRules:GetGameModeEntity().rng.build_count)
  --  GameRules:GetGameModeEntity().rng.build_count = GameRules:GetGameModeEntity().rng.build_count + 1
  --  ran32 = bit.bxor(ran32, GameRules:GetGameModeEntity().rng[GameRules.level])
  --  ran32 = ran32 % 0x80000000
  --  ran32_modulo_m = ran32 % m
  -- --end




  local ran = RandomInt(1,100)
  local stone_level = "1"
  local curr_per = 0
  if GameRules.gem_gailv[hero_level] ~= nil then
    --Say(owner,"level:"..hero_level,false)
    for per,lv in pairs(GameRules.gem_gailv[hero_level]) do
      --Say(owner,ran..">"..per.."--"..lv,false)
      if ran>=per and curr_per<per then
        curr_per = per
        stone_level = lv
      end
    end
  end
  if caster.pray_level ~= nil and caster.perfected ~= true then
    if RandomInt(1,100) <= tonumber(caster.pray_l) then
      stone_level = tonumber(caster.pray_level)
      createHintBubble(caster,"#renpinbaofa")
      if stone_level == "11111" then
        caster.perfected = true
      end
    end
  end
  caster.pray_level = nil
  caster.pray_l = nil

  --随机决定石头种类
  -- local ran = math.floor(ran32_modulo_m / 100) + 1

  --随机决定石头种类
  local ran = RandomInt(1,table.maxn(GameRules.gem_tower_basic))
  if caster.pray ~= nil then
    if RandomInt(1,100) <= tonumber(caster.pray) then
      ran = tonumber(caster.pray_color)
      createHintBubble(caster,"#renpinbaofa")
    end
  end
  caster.pray_color = nil
  caster.pray = nil
  
  local create_stone_name = GameRules.gem_tower_basic[ran]..stone_level

  -- if GameRules.build_index[player_id] == 0 then
  --  create_stone_name = "gemtd_palayibabixi"
  -- end
  -- if GameRules.build_index[player_id] == 1 then
  --  create_stone_name = "gemtd_heianfeicui"
  -- end
  -- if GameRules.build_index[player_id] == 2 then
  --  create_stone_name = "gemtd_g11"
  -- end
  -- -- if GameRules.build_index[player_id] == 3 then
  -- --   create_stone_name = "gemtd_y1111"
  -- -- end
  -- -- if GameRules.build_index[player_id] == 4 then
  -- --   create_stone_name = "gemtd_y11111"
  -- -- end

  if GameRules.crab ~= nil then
    create_stone_name = "gemtd_"..GameRules.crab
    GameRules.crab = nil
  end

  --创建石头
  print(create_stone_name)
  u = CreateUnitByName(create_stone_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS)
  u.ftd = 2009
    --u = AMHC:CreateUnit( create_stone_name,p,270,caster,caster:GetTeamNumber())
  u:SetOwner(caster)
  --u:SetParent(caster,caster:GetUnitName())
  u:SetControllableByPlayer(player_id, true)
  u:SetForwardVector(Vector(0,-1,0))
  u:AddAbility("no_hp_bar")
  u:FindAbilityByName("no_hp_bar"):SetLevel(1)

  u:AddAbility("gemtd_tower_new")
  u:FindAbilityByName("gemtd_tower_new"):SetLevel(1)

  EmitGlobalSound("Item.DropWorld")

  -- u:AddAbility("tower_mofa10")
  -- u:FindAbilityByName("tower_mofa10"):SetLevel(1)

--添加玩家颜色底盘
--  local particle = ParticleManager:CreateParticle("particles/gem/team_"..(player_id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
--  u.ppp = particle


  u:RemoveModifierByName("modifier_invulnerable")
  u:SetHullRadius(64)
--change comments
--  GameRules.build_curr[player_id][GameRules.build_index[player_id]]                = u
--  GameRules.build_index[player_id] = GameRules.build_index[player_id] +1
--  --GameRules:SendCustomMessage("玩家"..player_id.."建造了"..GameRules.build_index[player_id].."个石头", 0, 0)

  --发送merge_board_curr
  local send_pool = {}

  for c,c_unit in pairs(GameRules.build_curr[0]) do
    table.insert (send_pool, c_unit:GetUnitName())
  end
  for c,c_unit in pairs(GameRules.build_curr[1]) do
    table.insert (send_pool, c_unit:GetUnitName())
  end
  for c,c_unit in pairs(GameRules.build_curr[2]) do
    table.insert (send_pool, c_unit:GetUnitName())
  end
  for c,c_unit in pairs(GameRules.build_curr[3]) do
    table.insert (send_pool, c_unit:GetUnitName())
  end
  CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

  if GameRules.build_index[player_id]>=5 then
    GameRules.build_index[player_id] = 0
    --GameRules:SendCustomMessage("玩家"..player_id.."选择石头", 0, 0)
    --给英雄去掉建造和拆除的技能
    --local h = PlayerResource:GetPlayer(player_id):GetAssignedHero()
    --caster:RemoveAbility("gemtd_build_stone")
    --caster:RemoveAbility("gemtd_remove")
    caster:FindAbilityByName("gemtd_build_stone"):SetLevel(0)
    caster:FindAbilityByName("gemtd_remove"):SetLevel(0)

    --caster:DestroyAllSpeechBubbles()
    --caster:AddSpeechBubble(1,"#text_please_select_a_stone",3,0,30)
    createHintBubble(caster,"#text_please_select_a_stone")

    --给石头增加选择技能

    -- GameRules.build_curr[player_id][1]:AddAbility("gemtd_choose_stone")
    -- GameRules.build_curr[player_id][1]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)
    -- GameRules.build_curr[player_id][2]:AddAbility("gemtd_choose_stone")
    -- GameRules.build_curr[player_id][2]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)
    -- GameRules.build_curr[player_id][3]:AddAbility("gemtd_choose_stone")
    -- GameRules.build_curr[player_id][3]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)
    -- GameRules.build_curr[player_id][4]:AddAbility("gemtd_choose_stone")
    -- GameRules.build_curr[player_id][4]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)

    --判断能不能合并成+1 +2级的
    for i=0,4 do
      local curr_name = GameRules.build_curr[player_id][i]:GetUnitName()
      local repeat_count = 0
      for j=0,4 do
        local curr_name2 = GameRules.build_curr[player_id][j]:GetUnitName()
        if curr_name == curr_name2 then
          repeat_count = repeat_count + 1
        end
      end


      local unit_name = GameRules.build_curr[player_id][i]:GetUnitName()
      local string_length = string.len(unit_name)
      local count_1  = 0
      for i=1,string_length do
        local index = string_length+1-i
        if string.sub(unit_name,index,index) == "1" then
          count_1 = count_1 + 1
        end
      end
      if count_1 >=2 then
        GameRules.build_curr[player_id][i]:AddAbility("gemtd_downgrade_stone")
        GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_downgrade_stone"):SetLevel(1)
        --风暴之锤
        if caster:FindAbilityByName("gemtd_hero_fengbaozhichui") ~= nil then
          local fengbaozhichui_level = caster:FindAbilityByName("gemtd_hero_fengbaozhichui"):GetLevel()
          GameRules.build_curr[player_id][i]:AddAbility("gemtd_downgrade_stone_fengbaozhichui")
          GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_downgrade_stone_fengbaozhichui"):SetLevel(fengbaozhichui_level)
        end
      end

      GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_stone")
      GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_stone"):SetLevel(1)

      if repeat_count>=4 then
        GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_stone")
        GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_stone"):SetLevel(1)
        GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_update_stone")
        GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_update_stone"):SetLevel(1)

        if caster.effect ~= nil and caster.effect ~= "" then
          GameRules.build_curr[player_id][i]:AddAbility(caster.effect)
          GameRules.build_curr[player_id][i]:FindAbilityByName(caster.effect):SetLevel(1) 
          GameRules.build_curr[player_id][i].effect = caster.effect
        end

      elseif repeat_count>=2 then
        GameRules.build_curr[player_id][i]:AddAbility("gemtd_choose_update_stone")
        GameRules.build_curr[player_id][i]:FindAbilityByName("gemtd_choose_update_stone"):SetLevel(1)

        -- if caster.effect ~= nil and caster.effect ~= "" then
        --  GameRules.build_curr[player_id][i]:AddAbility(caster.effect)
        --  GameRules.build_curr[player_id][i]:FindAbilityByName(caster.effect):SetLevel(1) 
        --  GameRules.build_curr[player_id][i].effect = caster.effect
        -- end
      end

    end

    
    --检查能否一回合合成高级塔
    for h,h_merge in pairs(GameRules.gemtd_merge) do
      local can_merge = true
      local merge_pool = {}

      for k,k_unitname in pairs(h_merge) do
        local have_merge = false
        for c,c_unit in pairs(GameRules.build_curr[player_id]) do
          if c_unit:GetUnitName()==k_unitname then
            --有这个合成配方
            have_merge =true
            table.insert (merge_pool, c_unit)
          end
        end
        if have_merge==false then
          can_merge = false
        end
      end

      if can_merge == true then
        --可以合成，给它们增加技能
        GameRules.gemtd_pool_can_merge_1[h] = {}

        for a,a_unit in pairs(merge_pool) do
          a_unit:AddAbility(h.."1")
          a_unit:FindAbilityByName(h.."1"):SetLevel(1)
          --GameRules:SendCustomMessage("可以合成"..h, 0, 0)

          if caster.effect ~= nil and caster.effect ~= "" then
            a_unit:AddAbility(caster.effect)
            a_unit:FindAbilityByName(caster.effect):SetLevel(1) 
            a_unit.effect = caster.effect
          end

          table.insert (GameRules.gemtd_pool_can_merge_1[player_id], a_unit) 
        end
      end
    end

    --检查能否一回合合成隐藏塔
    for h,h_merge in pairs(GameRules.gemtd_merge_secret) do
      local can_merge = true
      local merge_pool = {}

      for k,k_unitname in pairs(h_merge) do
        local have_merge = false
        for c,c_unit in pairs(GameRules.build_curr[player_id]) do
          if c_unit:GetUnitName()==k_unitname then
            --有这个合成配方
            have_merge =true
            table.insert (merge_pool, c_unit)
          end
        end
        if have_merge==false then
          can_merge = false
        end
      end

      if can_merge == true then
        --可以合成，给它们增加技能
        GameRules.gemtd_pool_can_merge_1[h] = {}

        for a,a_unit in pairs(merge_pool) do
          a_unit:AddAbility(h.."1")
          a_unit:FindAbilityByName(h.."1"):SetLevel(1)
          --GameRules:SendCustomMessage("可以合成"..h, 0, 0)

          if caster.effect ~= nil and caster.effect ~= "" then
            a_unit:AddAbility(caster.effect)
            a_unit:FindAbilityByName(caster.effect):SetLevel(1) 
            a_unit.effect = caster.effect
          end

          table.insert (GameRules.gemtd_pool_can_merge_1[player_id], a_unit) 
        end
      end
    end

  end
  
end

--移除石头
function gemtd_remove(keys)
  local caster = keys.caster
  local target = keys.target
  local owner =  caster:GetOwner()

  if target:GetUnitName() ~= "gemtd_stone" then
    --caster:DestroyAllSpeechBubbles()
    --caster:AddSpeechBubble(2,"#text_cannot_remove_it",3,0,30)
    createHintBubble(caster,"#text_cannot_remove_it")

    return
  end

  local xxx = math.floor((target:GetAbsOrigin().x+64)/128)+19
  local yyy = math.floor((target:GetAbsOrigin().y+64)/128)+19

  GameRules:GetGameModeEntity().gem_map[yyy][xxx]=0

  if target.ppp then
    ParticleManager:DestroyParticle(target.ppp,true)
  end
  target:Destroy()

  EmitGlobalSound("ui.browser_click_right")


  find_all_path()

end


function choose_stone(keys)
    local caster = keys.caster
    local owner =  caster:GetOwner()
    local player_id = owner:GetPlayerID()

    caster:RemoveAbility("gemtd_choose_stone")
    caster:RemoveAbility("gemtd_choose_update_stone")
    caster:RemoveAbility("gemtd_choose_update_update_stone")

    for i=0,4 do
        if GameRules.build_curr[player_id][i]~=caster then
            --移除其他的石头
            local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
            --删除玩家颜色底盘
            if GameRules.build_curr[player_id][i].ppp then
                ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
            end
            GameRules.build_curr[player_id][i]:Destroy()
            --用普通石头代替
            p.z=1400
            local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
            u.ftd = 2009

            u:SetOwner(owner)
            u:SetControllableByPlayer(player_id, true)
            u:SetForwardVector(Vector(-1,0,0))

            u:AddAbility("no_hp_bar")
            u:FindAbilityByName("no_hp_bar"):SetLevel(1)

            u:RemoveModifierByName("modifier_invulnerable")
            u:SetHullRadius(64)
        end
    end

    --移除caster，用同级的代替
    local unit_name = caster:GetUnitName()
    local p = caster:GetAbsOrigin()
    local caster_died = caster
    --删除玩家颜色底盘
    if caster.ppp then
        ParticleManager:DestroyParticle(caster.ppp,true)
    end
    caster:Destroy()

    EmitGlobalSound("ui.npe_objective_given")

    stone_quest(unit_name)

    local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
    u.ftd = 2009

    --u:DestroyAllSpeechBubbles()
    --u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
    createHintBubble(u,"#"..unit_name)

    u:SetOwner(owner)
    u:SetControllableByPlayer(player_id, true)
    u:SetForwardVector(Vector(0,-1,0))

    u:AddAbility("no_hp_bar")
    u:FindAbilityByName("no_hp_bar"):SetLevel(1)
    u:AddAbility("gemtd_tower_base")
    u:FindAbilityByName("gemtd_tower_base"):SetLevel(1)
    u:AddAbility("gemtd_tower_select")
    u:FindAbilityByName("gemtd_tower_select"):SetLevel(1)

    -- 特效测试
    -- local blood_pfx = ParticleManager:CreateParticle("particles/gem/screen_arcane_drop.vpcf", PATTACH_EYES_FOLLOW, u)
    
    -- 添加玩家颜色底盘
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
    u.ppp = particle

    u:RemoveModifierByName("modifier_invulnerable")
    u:SetHullRadius(64)

    table.insert (GameRules.gemtd_pool, u)

    GameRules.build_curr[player_id] = {}
    GameRules:GetGameModeEntity().is_build_ready[player_id] = true

    --发送merge_board
    local send_pool = {}
    for c,c_unit in pairs(GameRules.gemtd_pool) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

    --发送merge_board_curr
    local send_pool = {}

    for c,c_unit in pairs(GameRules.build_curr[0]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[1]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[2]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[3]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

    finish_build()

end

function choose_update_stone(keys)
    local caster = keys.caster
    local owner =  caster:GetOwner()
    local player_id = owner:GetPlayerID()

    --GameRules:SendCustomMessage("选择了石头", 0, 0)
    caster:RemoveAbility("gemtd_choose_stone")
    caster:RemoveAbility("gemtd_choose_update_stone")
    caster:RemoveAbility("gemtd_choose_update_update_stone")

    for i=0,4 do
        if GameRules.build_curr[player_id][i]~=caster then
            --移除其他的石头
            local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
            --删除玩家颜色底盘
            if GameRules.build_curr[player_id][i].ppp then
                ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
            end
            GameRules.build_curr[player_id][i]:Destroy()
            --用普通石头代替
            p.z=1400
            local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
            u.ftd = 2009

            u:SetOwner(owner)
            u:SetControllableByPlayer(player_id, true)
            u:SetForwardVector(Vector(-1,0,0))

            u:AddAbility("no_hp_bar")
            u:FindAbilityByName("no_hp_bar"):SetLevel(1)
            u:RemoveModifierByName("modifier_invulnerable")
            u:SetHullRadius(64)
        end
    end

    --移除caster，用高一级的代替
    local unit_name = caster:GetUnitName().."1"
    local p = caster:GetAbsOrigin()
    local caster_died = caster
    --删除玩家颜色底盘
    if caster.ppp then
        ParticleManager:DestroyParticle(caster.ppp,true)
    end
    caster:Destroy()

    EmitGlobalSound("ui.npe_objective_given")

    stone_quest(unit_name)

    local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
    u.ftd = 2009
    --u:DestroyAllSpeechBubbles()
    --u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
    createHintBubble(u,"#"..unit_name)

    u:SetOwner(owner)
    u:SetControllableByPlayer(player_id, true)
    u:SetForwardVector(Vector(0,-1,0))

    u:AddAbility("no_hp_bar")
    u:FindAbilityByName("no_hp_bar"):SetLevel(1)
    u:AddAbility("gemtd_tower_select")
    u:FindAbilityByName("gemtd_tower_select"):SetLevel(1)

    --添加玩家颜色底盘
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
    u.ppp = particle
    
    
    u:RemoveModifierByName("modifier_invulnerable")

    u:SetHullRadius(64)

    table.insert (GameRules.gemtd_pool, u)

    --AMHC:CreateNumberEffect(u,1,2,AMHC.MSG_DAMAGE,"yellow",0)


    GameRules.build_curr[player_id] = {}
    GameRules:GetGameModeEntity().is_build_ready[player_id] = true

    --发送merge_board
    local send_pool = {}
    for c,c_unit in pairs(GameRules.gemtd_pool) do
        if (not c_unit:IsNull()) then
            table.insert (send_pool, c_unit:GetUnitName())
        end
    end
    CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

    --发送merge_board_curr
    local send_pool = {}

    for c,c_unit in pairs(GameRules.build_curr[0]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[1]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[2]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[3]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

    finish_build()
end

function choose_update_update_stone(keys)
    --print("------------------------")
    --DeepPrintTable(keys)

    local caster = keys.caster
    local owner =  caster:GetOwner()
    local player_id = owner:GetPlayerID()

    --GameRules:SendCustomMessage("选择了石头", 0, 0)
    caster:RemoveAbility("gemtd_choose_stone")
    caster:RemoveAbility("gemtd_choose_update_stone")
    caster:RemoveAbility("gemtd_choose_update_update_stone")

    for i=0,4 do
        if GameRules.build_curr[player_id][i]~=caster then
            --移除其他的石头
            local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
            --删除玩家颜色底盘
            if GameRules.build_curr[player_id][i].ppp then
                ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
            end
            GameRules.build_curr[player_id][i]:Destroy()
            --用普通石头代替
            p.z=1400
            local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
            u.ftd = 2009

            u:SetOwner(owner)
            u:SetControllableByPlayer(player_id, true)
            u:SetForwardVector(Vector(-1,0,0))

            u:AddAbility("no_hp_bar")
            u:FindAbilityByName("no_hp_bar"):SetLevel(1)
            u:RemoveModifierByName("modifier_invulnerable")
            u:SetHullRadius(64)
        end
    end

    --移除caster，用高两级的代替
    local unit_name = caster:GetUnitName()
    if unit_name=="gemtd_y11111" or 
        unit_name=="gemtd_p11111" or
        unit_name=="gemtd_b11111" or
        unit_name=="gemtd_r11111" or
        unit_name=="gemtd_g11111" or
        unit_name=="gemtd_d11111" or
        unit_name=="gemtd_q11111" or
        unit_name=="gemtd_e11111" 
    then
        unit_name = "gemtd_zhenjiazhishi"
    else
        unit_name = unit_name.."11"
    end
    local p = caster:GetAbsOrigin()
    local caster_died = caster
    --删除玩家颜色底盘
    if caster.ppp then
        ParticleManager:DestroyParticle(caster.ppp,true)
    end
    caster:Destroy()

    EmitGlobalSound("ui.npe_objective_given")

    stone_quest(unit_name)

    local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
    u.ftd = 2009
    --u:DestroyAllSpeechBubbles()
    --u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
    createHintBubble(u,"#"..unit_name)

    u:SetOwner(owner)
    u:SetControllableByPlayer(player_id, true)
    u:SetForwardVector(Vector(0,-1,0))

    u:AddAbility("no_hp_bar")
    u:FindAbilityByName("no_hp_bar"):SetLevel(1)
    u:AddAbility("gemtd_tower_merge")
    u:FindAbilityByName("gemtd_tower_merge"):SetLevel(1)
    
    --添加玩家颜色底盘
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
    u.ppp = particle
    
    u:RemoveModifierByName("modifier_invulnerable")
    u:SetHullRadius(64)

    table.insert (GameRules.gemtd_pool, u)

    --AMHC:CreateNumberEffect(u,1,2,AMHC.MSG_DAMAGE,"yellow",0)


    GameRules.build_curr[player_id] = {}
    GameRules:GetGameModeEntity().is_build_ready[player_id] = true

    --发送merge_board
    local send_pool = {}
    for c,c_unit in pairs(GameRules.gemtd_pool) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

    --发送merge_board_curr
    local send_pool = {}

    for c,c_unit in pairs(GameRules.build_curr[0]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[1]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[2]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[3]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

    finish_build()

end

function gemtd_downgrade_stone (keys)
    local caster = keys.caster
    local owner =  caster:GetOwner()
    local player_id = owner:GetPlayerID()

    caster:RemoveAbility("gemtd_choose_stone")
    caster:RemoveAbility("gemtd_choose_stone_fengbaozhichui")
    caster:RemoveAbility("gemtd_choose_update_stone")
    caster:RemoveAbility("gemtd_choose_update_update_stone")

    for i=0,4 do
        if GameRules.build_curr[player_id][i]~=caster then
            --移除其他的石头
            local p = GameRules.build_curr[player_id][i]:GetAbsOrigin()
            --删除玩家颜色底盘
            if GameRules.build_curr[player_id][i].ppp then
                ParticleManager:DestroyParticle(GameRules.build_curr[player_id][i].ppp,true)
            end
            GameRules.build_curr[player_id][i]:Destroy()
            --用普通石头代替
            p.z=1400
            local u = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
            u.ftd = 2009

            u:SetOwner(owner)
            u:SetControllableByPlayer(player_id, true)
            u:SetForwardVector(Vector(-1,0,0))

            u:AddAbility("no_hp_bar")
            u:FindAbilityByName("no_hp_bar"):SetLevel(1)

            u:RemoveModifierByName("modifier_invulnerable")
            u:SetHullRadius(64)
        end
    end

    --移除caster，用降级的代替
    local unit_name = caster:GetUnitName()

    --处理成 随机降级
    local string_length = string.len(unit_name)
    local count_1  = 0
    for i=1,string_length do
        local index = string_length+1-i
        if string.sub(unit_name,index,index) == "1" then
            count_1 = count_1 + 1
        end
    end

    --GameRules:SendCustomMessage("count_1:"..count_1, 0, 0)

    if count_1>=2 then
        local del_count = RandomInt(1,count_1-1)

        if count_1==2 then
            del_count = 1
        elseif count_1==3 then
            local r = RandomInt(1,100)
            if r > 66 then
                del_count = 2
            else
                del_count = 1
            end
        elseif count_1==4 then
            local r = RandomInt(1,100)
            if r > 80 then
                del_count = 3
            elseif r > 50 then
                del_count = 2
            else
                del_count = 1
            end

        elseif count_1==5 then
            local r = RandomInt(1,100)
            if r > 90 then
                del_count = 4
            elseif r > 75 then
                del_count = 3
            elseif r > 50 then
                del_count = 2
            else
                del_count = 1
            end

        end

        --GameRules:SendCustomMessage("del_count:"..del_count, 0, 0)
        unit_name = string.sub(unit_name,1,string_length-del_count)
    end

    --同步玩家金钱
    local gold_count = PlayerResource:GetGold(player_id)
    --GameRules:SendCustomMessage("玩家"..player_id.."= "..gold_count, 0, 0)

    local ii = 0
    for ii = 0, 20 do
        if ( PlayerResource:IsValidPlayer( ii ) ) then
            local player = PlayerResource:GetPlayer(ii)
            if player ~= nil then
                PlayerResource:SetGold(ii, gold_count, true)
                --GameRules:SendCustomMessage("玩家"..ii.."= "..gold_count, 0, 0)
            end
        end
    end
    GameRules.team_gold = gold_count
    CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = gold_count } );

    --GameRules:SendCustomMessage("unit_name:"..unit_name, 0, 0)




    local p = caster:GetAbsOrigin()
    local caster_died = caster
    --删除玩家颜色底盘
    if caster.ppp then
        ParticleManager:DestroyParticle(caster.ppp,true)
    end
    caster:Destroy()

    EmitGlobalSound("DOTA_Item.Buckler.Activate")

    stone_quest(unit_name)

    local u = CreateUnitByName(unit_name, p,false,nil,nil,DOTA_TEAM_GOODGUYS)
    u.ftd = 2009 
    --u:DestroyAllSpeechBubbles()
    --u:AddSpeechBubble(1,"#"..unit_name,3,0,-30)
    createHintBubble(u,"#"..unit_name)

    u:SetOwner(owner)
    u:SetControllableByPlayer(player_id, true)
    u:SetForwardVector(Vector(0,-1,0))

    u:AddAbility("no_hp_bar")
    u:FindAbilityByName("no_hp_bar"):SetLevel(1)
    u:AddAbility("gemtd_tower_base")
    u:FindAbilityByName("gemtd_tower_base"):SetLevel(1)
    u:AddAbility("gemtd_tower_select")
    u:FindAbilityByName("gemtd_tower_select"):SetLevel(1)
    
    --添加玩家颜色底盘
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport.vpcf", PATTACH_ABSORIGIN_FOLLOW, u) 
    u.ppp = particle

    u:RemoveModifierByName("modifier_invulnerable")
    u:SetHullRadius(64)

    table.insert (GameRules.gemtd_pool, u)

    GameRules.build_curr[player_id] = {}
    GameRules:GetGameModeEntity().is_build_ready[player_id] = true

    --发送merge_board
    local send_pool = {}
    for c,c_unit in pairs(GameRules.gemtd_pool) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    CustomNetTables:SetTableValue( "game_state", "gem_merge_board", send_pool )

    --发送merge_board_curr
    local send_pool = {}

    for c,c_unit in pairs(GameRules.build_curr[0]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[1]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[2]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    for c,c_unit in pairs(GameRules.build_curr[3]) do
        table.insert (send_pool, c_unit:GetUnitName())
    end
    CustomNetTables:SetTableValue( "game_state", "gem_merge_board_curr", send_pool )

    finish_build()
end