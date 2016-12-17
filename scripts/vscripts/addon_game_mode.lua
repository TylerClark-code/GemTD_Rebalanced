-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  --PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  --PrecacheResource("particle_folder", "particles/test_particle", context)

  --PrecacheResource("particle","particles/units/heroes/hero_lion/lion_spell_mana_drain.vpcf",context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  --PrecacheResource("model_folder", "particles/heroes/antimage", context)
  --PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  --PrecacheModel("models/heroes/viper/viper.vmdl", context)
  --PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

  -- Sounds can precached here like anything else
  --PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  --PrecacheItemByNameSync("example_ability", context)
  --PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  --PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
  PrecacheUnitByNameSync("npc_dota_building_homebase", context)
  PrecacheUnitByNameSync("gemtd_stone", context)
  PrecacheUnitByNameSync("gemtd_b1", context)

  local gemlistinit = {
  [1] = "gemtd_b",
  [2] = "gemtd_d",
  [3] = "gemtd_q",
  [4] = "gemtd_e",
  [5] = "gemtd_g",
  [6] = "gemtd_y",
  [7] = "gemtd_r",
  [8] = "gemtd_p" }

  local gemlength=#gemlistinit;
  for i=1,gemlength do
    for j=1,1 do
    PrecacheUnitByNameSync(gemlistinit[i]..j,context)
  end
  end
    print("Tower Precache OK")   


  PrecacheUnitByNameSync("npc_dota_chipped_ruby", context)
    local zr={
    "models/courier/mighty_boar/mighty_boar.vmdl",
    "models/props_stone/stone_column001a.vmdl",
    "models/props_gameplay/heart001.vmdl",
    "models/props_structures/good_barracks_melee002.vmdl",
    "models/courier/frog/frog.vmdl",
    "models/courier/yak/yak.vmdl",
    "models/props_debris/riveredge_rocks_small001_snow.vmdl",
    "particles/econ/events/snowball/snowball_projectile.vpcf",
    "models/particle/ice_shards.vmdl",
    "models/props_debris/candles003.vmdl",
    "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf",
    "models/props_destruction/lava_flow_clump.vmdl",
    "particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf",
    "particles/units/heroes/hero_lina/lina_base_attack.vpcf",
    "models/particle/green_rocks.vmdl",
    "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf",
    "particles/base_attacks/ranged_goodguy_trail.vpcf",
    "models/particle/snowball.vmdl",
    "models/particle/skull.vmdl",
    "models/particle/sealife.vmdl",
    "models/particle/tormented_spike.vmdl",
    "models/props_mines/mine_tool_plate001.vmdl",
    "models/props_magic/bad_crystals002.vmdl",
    "models/props_nature/lily_flower00.vmdl",
    "models/buildings/building_racks_melee_reference.vmdl",
    "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf",
    "particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf",
    "particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf",
    "models/props_winter/egg.vmdl",
    "models/items/wards/tide_bottom_watcher/tide_bottom_watcher.vmdl",
    "models/items/wards/skywrath_sentinel/skywrath_sentinel.vmdl",
    "models/items/wards/fairy_dragon/fairy_dragon.vmdl",
    "models/items/wards/echo_bat_ward/echo_bat_ward.vmdl",
    "models/items/wards/esl_wardchest_four_armed_observer/esl_wardchest_four_armed_observer.vmdl",
    "models/items/wards/crystal_maiden_ward/crystal_maiden_ward.vmdl",
    "models/items/wards/esl_wardchest_jungleworm_sentinel/esl_wardchest_jungleworm_sentinel.vmdl",
    "models/items/wards/jinnie_v2/jinnie_v2.vmdl",
    "models/items/wards/venomancer_ward/venomancer_ward.vmdl",
    "models/items/wards/frozen_formation/frozen_formation.vmdl",
    "models/items/wards/deep_observer/deep_observer.vmdl",
    "models/items/wards/eyeofforesight/eyeofforesight.vmdl",
    "models/courier/courier_mech/courier_mech.vmdl",
    "models/courier/badger/courier_badger_flying.vmdl",
    "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_white_b_arcana1.vpcf",
    "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf",
    "models/items/wards/esl_wardchest_ward_of_foresight/esl_wardchest_ward_of_foresight.vmdl",
    "models/items/wards/esl_wardchest_rockshell_terrapin/esl_wardchest_rockshell_terrapin.vmdl",
    "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf",
    "models/courier/tegu/tegu.vmdl",
    "models/courier/stump/stump.vmdl",
    "models/items/courier/itsy/itsy.vmdl",
    "models/items/courier/duskie/duskie.vmdl",
    "models/courier/juggernaut_dog/juggernaut_dog.vmdl",
    "models/items/wards/deadwatch_ward/deadwatch_ward.vmdl",
    "models/items/wards/enchantedvision_ward/enchantedvision_ward.vmdl",
    "models/items/wards/esl_wardchest_sibling_spotter/esl_wardchest_sibling_spotter.vmdl",
    "models/courier/defense3_sheep/defense3_sheep.vmdl",
    "models/items/courier/livery_llama_courier/livery_llama_courier.vmdl",
    "models/items/courier/gnomepig/gnomepig.vmdl",
    "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl",
    "models/items/courier/captain_bamboo/captain_bamboo_flying.vmdl",
    "models/courier/imp/imp.vmdl",
    "models/items/courier/mighty_chicken/mighty_chicken.vmdl",
    "models/items/courier/bajie_pig/bajie_pig.vmdl",
    "models/items/courier/arneyb_rabbit/arneyb_rabbit.vmdl",
    "models/items/courier/shagbark/shagbark.vmdl",
    "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf",
    "models/items/wards/d2lp_4_ward/d2lp_4_ward.vmdl",
    "models/items/wards/jakiro_pyrexae_ward/jakiro_pyrexae_ward.vmdl",
    "models/items/wards/esl_wardchest_radling_ward/esl_wardchest_radling_ward.vmdl",
    "models/items/wards/dragon_ward/dragon_ward.vmdl",
    "particles/units/heroes/hero_enchantress/enchantress_base_attack.vpcf",
    "particles/base_attacks/ranged_tower_good_glow_b.vpcf",
    "models/items/wards/gazing_idol_ward/gazing_idol_ward.vmdl",
    "models/items/wards/chinese_ward/chinese_ward.vmdl",
    "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf",
    "particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold_model.vpcf",
    "particles/showcase_fx/showcase_fx_base_3_b.vpcf",
    "particles/items_fx/aura_shivas_ring.vpcf",
    "particles/hw_fx/gravehands_grab_1_ground.vpcf",
    "particles/econ/courier/courier_trail_winter_2012/courier_trail_winter_2012_drifts.vpcf",
    "particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_ground_soil_cauldron.vpcf",
    "particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_ground_b_gravelmaw.vpcf",
    "particles/units/heroes/hero_tusk/tusk_ice_shards_ground_burst.vpcf",
    "particles/units/heroes/hero_omniknight/omniknight_degen_aura_b.vpcf",
    "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff_circle.vpcf",
    "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf",
    "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_status_ice.vpcf",
    "models/items/courier/deathripper/deathripper.vmdl",
    "models/courier/lockjaw/lockjaw.vmdl",
    "models/courier/trapjaw/trapjaw.vmdl",
    "models/courier/mechjaw/mechjaw.vmdl",
    "models/items/courier/corsair_ship/corsair_ship.vmdl",
    "models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
    "models/items/courier/lgd_golden_skipper/lgd_golden_skipper_flying.vmdl",
    "models/items/courier/ig_dragon/ig_dragon_flying.vmdl",
    "models/items/courier/vigilante_fox_red/vigilante_fox_red_flying.vmdl",
    "models/courier/drodo/drodo_flying.vmdl",
    "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf",
    "models/items/wards/augurys_guardian/augurys_guardian.vmdl",
    "particles/neutral_fx/skeleton_spawn.vpcf",
    "particles/units/heroes/hero_earth_spirit/espirit_spawn_ground.vpcf",
    "particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf",
    "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_impact_moonfall_gold.vpcf",
    "particles/radiant_fx/tower_good3_dest_beam.vpcf",
    "particles/units/unit_greevil/loot_greevil_death_spark_pnt.vpcf",
    "particles/units/unit_greevil/loot_greevil_death_spark_pnt.vpcf",
    "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf",
    "models/items/wards/blood_seeker_ward/bloodseeker_ward.vmdl",
    "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf",
    "models/items/wards/alliance_ward/alliance_ward.vmdl",
    "particles/units/heroes/hero_razor/razor_static_link_projectile_a.vpcf",
    "particles/econ/items/natures_prophet/natures_prophet_weapon_scythe_of_ice/natures_prophet_scythe_of_ice.vpcf",
    "particles/units/heroes/hero_tinker/tinker_laser.vpcf",
    --"particles/gem/team_0.vpcf",
    --[[
    "particles/unit_team/unit_team_player1.vpcf",
    "particles/unit_team/unit_team_player2.vpcf",
    "particles/unit_team/unit_team_player3.vpcf",
    "particles/unit_team/unit_team_player4.vpcf",
    "particles/unit_team/unit_team_player0_a.vpcf",
    "particles/unit_team/unit_team_player1_a.vpcf",
    "particles/unit_team/unit_team_player2_a.vpcf",
    "particles/unit_team/unit_team_player3_a.vpcf",
    "particles/unit_team/unit_team_player4_a.vpcf",
    ]]
    "models/items/wards/esl_wardchest_living_overgrowth/esl_wardchest_living_overgrowth.vmdl",
    "models/items/wards/mothers_eye/mothers_eye.vmdl",
    "models/items/wards/esl_one_jagged_vision/esl_one_jagged_vision.vmdl",
    "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt_birds.vpcf",
    "particles/units/heroes/hero_phoenix/phoenix_sunray_tgt.vpcf",
    "models/items/wards/jakiro_pyrexae_ward/jakiro_pyrexae_ward.vmdl",
    "particles/units/heroes/hero_phoenix/phoenix_supernova_scepter_f.vpcf",
    --"particles/tinker_laser2.vpcf",
    "models/items/wards/jimoward_omij/jimoward_omij.vmdl",
    "models/items/courier/corsair_ship/corsair_ship_flying.vmdl",
    "particles/items3_fx/star_emblem_brokenshield_caster.vpcf",
    "models/props_gameplay/heart001.vmdl",
    --"soundevents/hehe.vsndevts",
    "models/items/wards/tink/tink.vmdl",
    "models/items/wards/warding_guise/warding_guise.vmdl",
    "models/courier/smeevil_magic_carpet/smeevil_magic_carpet_flying.vmdl",
    "models/items/courier/bookwyrm/bookwyrm.vmdl",
    "models/items/courier/kanyu_shark/kanyu_shark.vmdl",
    "models/items/courier/pw_zombie/pw_zombie.vmdl",
    "models/courier/huntling/huntling_flying.vmdl",
    --"particles/kunkka_hehe.vpcf",
    "models/items/courier/jin_yin_black_fox/jin_yin_black_fox_flying.vmdl",
    "models/items/courier/jin_yin_white_fox/jin_yin_white_fox_flying.vmdl",
    "particles/units/heroes/hero_lion/lion_spell_mana_drain.vpcf",
    "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf",
    "particles/units/heroes/hero_wisp/wisp_tether.vpcf",
    "models/items/courier/mei_nei_rabbit/mei_nei_rabbit_flying.vmdl",
    "models/items/courier/gama_brothers/gama_brothers_flying.vmdl",
    "models/courier/smeevil_mammoth/smeevil_mammoth_flying.vmdl",
    "models/items/courier/baekho/baekho.vmdl", 
    "models/items/courier/green_jade_dragon/green_jade_dragon_flying.vmdl", --翠玉小龙
    "models/items/courier/jumo/jumo.vmdl", 
    "models/items/courier/jumo_dire/jumo_dire.vmdl", 
    "models/items/courier/lilnova/lilnova.vmdl", 
    "models/items/courier/blue_lightning_horse/blue_lightning_horse.vmdl",  --蔚蓝之霆
    "models/items/courier/amphibian_kid/amphibian_kid_flying.vmdl",   --两栖鱼孩
    "models/items/wards/chicken_hut_ward/chicken_hut_ward.vmdl",
    "models/courier/greevil/gold_greevil_flying.vmdl",
    "models/items/courier/g1_courier/g1_courier_flying.vmdl",
    "models/items/courier/boooofus_courier/boooofus_courier_flying.vmdl",
    "models/items/courier/mlg_courier_wraith/mlg_courier_wraith_flying.vmdl",
    "particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf",
    "soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts",
    "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf",
    "particles/items_fx/desolator_projectile.vpcf",
    "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf",
    "models/items/wards/knightstatue_ward/knightstatue_ward.vmdl",
    "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf",
    "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts",
    "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost_explosion.vpcf",
    "models/props_structures/pumpkin003.vmdl",
    "models/props_gameplay/pumpkin_bucket.vmdl",
    "models/items/courier/pumpkin_courier/pumpkin_courier_flying.vmdl",
    "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf",
    "sounds/weapons/hero/abaddon/borrowed_time.vsnd",
    "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf",
    "models/items/wards/f2p_ward/f2p_ward.vmdl",
    "models/items/wards/fairy_dragon/fairy_dragon.vmdl",
    "particles/econ/items/puck/puck_alliance_set/puck_base_attack_aproset.vpcf",
    "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_casterribbons_arcana1.vpcf",
    "models/props_teams/logo_dire_fall_medium.vmdl",
    "models/props_teams/logo_radiant_medium.vmdl",
    "models/props/traps/spiketrap/spiketrap.vmdl",
    "models/items/courier/azuremircourierfinal/azuremircourierfinal.vmdl",
    "models/items/courier/kupu_courier/kupu_courier_flying.vmdl",
    "models/items/wards/esl_wardchest_jungleworm/esl_wardchest_jungleworm.vmdl",
    "models/items/wards/esl_wardchest_direling_ward/esl_wardchest_direling_ward.vmdl",
    "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf",
    "particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_ambient_crystal_chorus_magic.vpcf",
    "models/items/courier/basim/basim_flying.vmdl",
    "models/props_teams/logo_radiant_winter_medium.vmdl",
    "models/creeps/nian/nian_creep.vmdl",
    "models/items/courier/mok/mok_flying.vmdl",
    "particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf",
    "particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast_ring_fire.vpcf",
    "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf",
    --[[
      "particles/gem/screen_arcane_drop.vpcf",
      "particles/gem/immunity_sphere_buff.vpcf",
      "particles/gem/immunity_sphere.vpcf",
      "particles/gem/omniknight_guardian_angel_wings_buff.vpcf",
      ]]
      "particles/generic_gameplay/screen_damage_indicator.vpcf",
      "particles/generic_gameplay/screen_arcane_drop.vpcf",
      "particles/items2_fx/refresher.vpcf",
      "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf",
      "particles/units/heroes/hero_medusa/medusa_base_attack.vpcf",
      "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf",
      "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf",
      "models/props_debris/shop_set_seat001.vmdl",
      "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf",
      "particles/units/heroes/hero_siren/naga_siren_portrait.vpcf",
      "particles/units/heroes/hero_chen/chen_teleport.vpcf",
      "particles/units/heroes/hero_chen/chen_teleport_flash_main.vpcf",
      "particles/radiant_fx/radiant_tower002_destruction_a2.vpcf",
      "particles/generic_gameplay/screen_damage_indicator.vpcf",
      "models/items/wards/sea_dogs_watcher/sea_dogs_watcher.vmdl",
      "models/items/wards/portal_ward/portal_ward.vmdl",
      "particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex_debuff.vpcf",
      "models/items/courier/coral_furryfish/coral_furryfish.vmdl",
      "models/items/courier/shroomy/shroomy.vmdl",
      "models/items/courier/bts_chirpy/bts_chirpy_flying.vmdl",
      "models/items/courier/boris_baumhauer/boris_baumhauer_flying.vmdl",
      "models/items/courier/green_jade_dragon/green_jade_dragon.vmdl",
      "models/courier/mech_donkey/mech_donkey.vmdl",
      "models/items/wards/esl_wardchest_toadstool/esl_wardchest_toadstool.vmdl",
      "models/courier/flopjaw/flopjaw.vmdl",
      "models/courier/donkey_trio/mesh/donkey_trio.vmdl",
      "models/items/courier/carty/carty_flying.vmdl",
      "models/items/courier/axolotl/axolotl_flying.vmdl",
      --"models/courier/seekling/seekling_flying.vmdl",
      "models/items/courier/shibe_dog_cat/shibe_dog_cat_flying.vmdl",
      "models/items/courier/krobeling/krobeling.vmdl",
      "models/items/courier/snaggletooth_red_panda/snaggletooth_red_panda_flying.vmdl",
      "particles/items2_fx/refresher.vpcf",
      "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf",
      "models/items/wards/phoenix_ward/phoenix_ward.vmdl",
      "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf",
      --"sm/2014.vpcf",
      "particles/econ/courier/courier_trail_divine/courier_divine_ambient.vpcf",
      --"sm/ruby.vpcf",
      "particles/econ/courier/courier_trail_fireworks/courier_trail_fireworks.vpcf",
      "particles/econ/courier/courier_crystal_rift/courier_ambient_crystal_rift.vpcf",
      "particles/econ/courier/courier_trail_cursed/courier_cursed_ambient.vpcf",
      "particles/econ/courier/courier_trail_04/courier_trail_04.vpcf",
      "particles/econ/courier/courier_trail_hw_2012/courier_trail_hw_2012.vpcf",
      "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf",
      "particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf",
      "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf",
      "particles/econ/courier/courier_polycount_01/courier_trail_polycount_01.vpcf",
      "particles/econ/wards/bane/bane_ward/bane_ward_ambient.vpcf",
      --[[m/mogu.vpcf",
      "sm/2012trail_international_2012.vpcf",
      "sm/2013.vpcf",
      "particles/econ/courier/courier_trail_05/courier_trail_05.vpcf",
      "sm/ambient.vpcf",
      "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_arcana_ground_ambient.vpcf",
      "sm/grass/03.vpcf",
      "sm/lianhua.vpcf",
      "sm/bingxueecon/courier/courier_trail_winter_2012/courier_trail_winter_2012.vpcf",
      "particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf",
      "sm/rongyanroushan.vpcf",
      "sm/bingroushan.vpcf",
      "sm/jinroushanambient.vpcf",
      "sm/lizizhiqiambient.vpcf",
      "particles/econ/courier/courier_trail_earth/courier_trail_earth.vpcf",
      "sm/hapi.vpcf",
      "sm/baoshiguangze.vpcf",
      "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_b_arcana1.vpcf",
      "sm/nihonghudieblue.vpcf",
      "particles/econ/events/ti6/radiance_owner_ti6.vpcf",
      "particles/econ/events/ti6/fountain_regen_ribbon_lvl3_a.vpcf",
      "sm/xianqichanrao.vpcf",
      "sm/ziyuanpurple/courier_greevil_purple_ambient_3.vpcf",
      "sm/xuehua.vpcf",
      "sm/xiehuodefault.vpcf",
      "sm/jinbijinbigold.vpcf",
      "sm/guanghuisuiyue.vpcf",
      "sm/zisexingyunsecondary.vpcf",
      "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6.vpcf",
      "sm/xingxingold.vpcf",
      ]]
      "particles/generic_gameplay/dropped_item_rapier.vpcf",
      "models/items/courier/boooofus_courier/boooofus_courier.vmdl",
      "models/courier/donkey_crummy_wizard_2014/donkey_crummy_wizard_2014.vmdl",
      "models/items/courier/bts_chirpy/bts_chirpy_flying.vmdl",
      "models/courier/drodo/drodo.vmdl",
      "models/courier/baby_rosh/babyroshan_flying.vmdl",
      "models/items/courier/little_fraid_the_courier_of_simons_retribution/little_fraid_the_courier_of_simons_retribution.vmdl",
      "models/items/wards/monty_ward/monty_ward.vmdl",
      "models/items/courier/wabbit_the_mighty_courier_of_heroes/wabbit_the_mighty_courier_of_heroes_flying.vmdl",
      "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts",
      "models/items/wards/stonebound_ward/stonebound_ward.vmdl",
      "particles/units/heroes/hero_visage/visage_base_attack.vpcf",
    }
     
    print("Precache...")
  local t=#zr;
  for i=1,t do
    if string.find(zr[i], "vpcf") then
      PrecacheResource( "particle",  zr[i], context)
    end
    if string.find(zr[i], "vmdl") then  
      PrecacheResource( "model",  zr[i], context)
    end
    if string.find(zr[i], "vsndevts") then
      PrecacheResource( "soundfile",  zr[i], context)
    end
    end
    print("Precache OK")    
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
  GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )
end