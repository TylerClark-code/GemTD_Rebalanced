-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end
--[[
-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')
]]
-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

require('custom_abilities')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

require('pathfinder/core/bheap')
md5 = require('md5')
json = require('dkjson')

BASE_MODULES = {
  'pathfinder/core/heuristics',
  'pathfinder/core/node', 'pathfinder/core/path',
  'pathfinder/grid', 'pathfinder/pathfinder',

  'pathfinder/search/astar', 'pathfinder/search/bfs',
  'pathfinder/search/dfs', 'pathfinder/search/dijkstra',
  'pathfinder/search/jps',  'timer/Timers',
  'amhc_library/amhc',
  'randomlua'
}

local function load_module(mod_name)
  local status, err_msg = pcall(function()
    require(mod_name)
  end)
  if status then
    print('Load module <' .. mod_name .. '> OK')
  else
    print('Load module <' .. mod_name .. '> FAILED: '..err_msg)
  end
end

for i, mod_name in pairs(BASE_MODULES) do
  load_module(mod_name)
end

GameRules.crab=nil

GameRules.hero_sea = {
  h101 = "npc_dota_hero_enchantress",
  h102 = "npc_dota_hero_puck",
  h103 = "npc_dota_hero_omniknight",
  h104 = "npc_dota_hero_wisp",
  h105 = "npc_dota_hero_ogre_magi",
  h106 = "npc_dota_hero_lion",
  h107 = "npc_dota_hero_keeper_of_the_light",
  h108 = "npc_dota_hero_rubick",
  h109 = "npc_dota_hero_jakiro", --new

  h201 = "npc_dota_hero_crystal_maiden",
  h202 = "npc_dota_hero_death_prophet",
  h203 = "npc_dota_hero_templar_assassin",
  h204 = "npc_dota_hero_lina",
  h205 = "npc_dota_hero_tidehunter",
  h206 = "npc_dota_hero_naga_siren",
  h207 = "npc_dota_hero_phoenix",
  h208 = "npc_dota_hero_dazzle",
  h209 = "npc_dota_hero_warlock",
  h210 = "npc_dota_hero_necrolyte",
  h211 = "npc_dota_hero_lich",
  h212 = "npc_dota_hero_furion",
  h213 = "npc_dota_hero_venomancer",
  h214 = "npc_dota_hero_kunkka",
  h215 = "npc_dota_hero_axe",  --new
  h216 = "npc_dota_hero_slark",  --new

  h301 = "npc_dota_hero_windrunner",
  h302 = "npc_dota_hero_phantom_assassin",
  h303 = "npc_dota_hero_sniper",
  h304 = "npc_dota_hero_sven",
  h305 = "npc_dota_hero_luna",
  h306 = "npc_dota_hero_mirana",
  h307 = "npc_dota_hero_nevermore",
  h308 = "npc_dota_hero_queenofpain",
  h309 = "npc_dota_hero_juggernaut",
  h310 = "npc_dota_hero_pudge",
  h311 = "npc_dota_hero_shredder",
  h312 = "npc_dota_hero_slardar",  --new
  h313 = "npc_dota_hero_antimage",  --new

  h401 = "npc_dota_hero_vengefulspirit",
  h402 = "npc_dota_hero_invoker",
  h403 = "npc_dota_hero_alchemist",
  h404 = "npc_dota_hero_spectre",
  h405 = "npc_dota_hero_morphling",
  h406 = "npc_dota_hero_techies",  --new
  h407 = "npc_dota_hero_chaos_knight",  --new
  h408 = "npc_dota_hero_faceless_void",  --new
  h409 = "npc_dota_hero_legion_commander", --new
}

GameRules.ability_sea = {
    a101 = "gemtd_hero_huichun",
    a102 = "gemtd_hero_shanbi",
    a103 = "gemtd_hero_shouhu",
    a104 = "gemtd_hero_shitou",
    a105 = "gemtd_hero_beishuiyizhan",
    a106 = "gemtd_hero_suilie",  --new

    a201 = "gemtd_hero_lanse",
    a202 = "gemtd_hero_danbai",
    a203 = "gemtd_hero_baise",
    a204 = "gemtd_hero_hongse",
    a205 = "gemtd_hero_lvse",
    a206 = "gemtd_hero_fense",
    a207 = "gemtd_hero_huangse",
    a208 = "gemtd_hero_zise",
    a209 = "gemtd_hero_jingying",
    a210 = "gemtd_hero_putong",
    a211 = "gemtd_hero_qingyi",

    a301 = "gemtd_hero_kuaisusheji",
    a302 = "gemtd_hero_baoji",
    a303 = "gemtd_hero_miaozhun",
    a304 = "gemtd_hero_fengbaozhichui",
    a305 = "gemtd_hero_wuxia",
    a306 = "gemtd_hero_huidaoguoqu",
    a307 = "warlock_fatal_bonds",

    a401 = "gemtd_hero_yixinghuanwei",
    a402 = "gemtd_hero_wanmei",
    a403 = "gemtd_hero_yuansuzhaohuan",
}

GameRules.table_bubbles = {}
time_tick = 0
GameRules.gem_hero = {
  [0] = nil,
  [1] = nil,
  [2] = nil,
  [3] = nil
}
GameRules.gem_gailv = {
  [1] = { },
  [2] = { [80] = "11" },
  [3] = { [60] = "11", [90] = "111" },
  [4] = { [40] = "11", [70] = "111", [90] = "1111" },
  [5] = { [10] = "11", [40] = "111", [70] = "1111", [90] = "11111" }
}

GameRules.gem_tower_basic = {
  [1] = "gemtd_b",
  [2] = "gemtd_d",
  [3] = "gemtd_q",
  [4] = "gemtd_e",
  [5] = "gemtd_g",
  [6] = "gemtd_y",
  [7] = "gemtd_r",
  [8] = "gemtd_p"
}

GameRules.gemtd_merge = {
  gemtd_baiyin = { "gemtd_b1", "gemtd_y1", "gemtd_d1" },
  gemtd_kongqueshi = { "gemtd_e1", "gemtd_q1", "gemtd_g1" },
  gemtd_xingcaihongbaoshi = { "gemtd_r11", "gemtd_r1", "gemtd_p1" },
  gemtd_yu = { "gemtd_g111", "gemtd_e111", "gemtd_b11" },
  gemtd_furongshi = { "gemtd_g1111", "gemtd_r111", "gemtd_p11" },
  gemtd_heianfeicui = { "gemtd_g11111", "gemtd_b1111", "gemtd_y11"  },
  gemtd_huangcailanbaoshi = { "gemtd_b11111", "gemtd_y1111", "gemtd_r1111"  },
  gemtd_palayibabixi = { "gemtd_q11111", "gemtd_e1111", "gemtd_g11" },
  gemtd_heisemaoyanshi = { "gemtd_e11111", "gemtd_d1111", "gemtd_q111"  },
  gemtd_jin = { "gemtd_p11111", "gemtd_p1111", "gemtd_d11"  },
  gemtd_fenhongzuanshi = { "gemtd_d11111", "gemtd_y111", "gemtd_d111"  },
  gemtd_jixueshi = { "gemtd_r11111", "gemtd_q1111", "gemtd_p111" },
  gemtd_you238 = { "gemtd_y11111", "gemtd_e11", "gemtd_b111" },
  gemtd_baiyinqishi = { "gemtd_baiyin", "gemtd_q11", "gemtd_r111" },
  gemtd_xianyandekongqueshi = { "gemtd_kongqueshi", "gemtd_d11", "gemtd_y111" },
  gemtd_xuehonghuoshan = { "gemtd_xingcaihongbaoshi", "gemtd_r1111", "gemtd_p111" },
  gemtd_jixiangdezhongguoyu = { "gemtd_yu", "gemtd_furongshi", "gemtd_g111" },
  gemtd_juxingfenhongzuanshi = { "gemtd_fenhongzuanshi", "gemtd_baiyinqishi", "gemtd_baiyin" },
  gemtd_you235 = { "gemtd_you238", "gemtd_xianyandekongqueshi", "gemtd_kongqueshi" },
  gemtd_jingxindiaozhuodepalayibabixi = { "gemtd_palayibabixi", "gemtd_heianfeicui", "gemtd_g11" },
  gemtd_gudaidejixueshi = { "gemtd_jixueshi", "gemtd_xuehonghuoshan", "gemtd_r11" },
  gemtd_mirendeqingjinshi = { "gemtd_furongshi", "gemtd_p1111", "gemtd_y11" },
  gemtd_aijijin = { "gemtd_jin", "gemtd_p11111", "gemtd_q111" },
  gemtd_shenhaizhenzhu = { "gemtd_q1111", "gemtd_d1111", "gemtd_e11" },
  gemtd_haiyangqingyu = { "gemtd_yu", "gemtd_b1111", "gemtd_q111" },
  gemtd_hongshanhu = { "gemtd_heisemaoyanshi", "gemtd_shenhaizhenzhu", "gemtd_e1111" },
  gemtd_feicuimoxiang = { "gemtd_jin", "gemtd_heianfeicui", "gemtd_d111" },
}
GameRules.gemtd_merge_secret = {
  gemtd_yijiazhishi = { "gemtd_e1", "gemtd_e11", "gemtd_e111", "gemtd_e1111", "gemtd_e11111" },
  gemtd_huguoshenyishi = { "gemtd_y1", "gemtd_y11", "gemtd_y111", "gemtd_y1111", "gemtd_y11111" },
  gemtd_heiyaoshi = { "gemtd_b11111", "gemtd_y11111", "gemtd_d11111" },
  gemtd_manao = { "gemtd_q11111", "gemtd_e11111", "gemtd_g11111" },
  gemtd_ranshaozhishi = { "gemtd_r11111", "gemtd_p11111", "gemtd_r1111", "gemtd_p1111" },
  gemtd_xiameishi = { "gemtd_r11111", "gemtd_g11111", "gemtd_b11111" },
}
GameRules.gemtd_merge_shiban = {
  gemtd_zhiliushiban = { "gemtd_y111", "gemtd_p11" }
}

GameRules.gemtd_pool = {}
GameRules.gemtd_pool_can_merge = {}
GameRules.gemtd_pool_can_merge_1 = {
  [0] = {},
  [1] = {},
  [2] = {},
  [3] = {}
}
GameRules.build_index = {
  [0] = 0,
  [1] = 0,
  [2] = 0,
  [3] = 0
}
GameRules.build_curr = {
  [0] = {},
  [1] = {},
  [2] = {},
  [3] = {}
}
playerInfoReceived = {}
GameRules.replced = {
  [0] = false, 
  [1] = false, 
  [2] = false, 
  [3] = false
}

GameRules.heroindex = {}
userid2player = {}
isConnected = {}

GameRules.gem_difficulty = {
  [1] = 0.7,
  [2] = 3.0,
  [3] = 5.5,
  [4] = 7.4
}

GameRules.gem_difficulty_speed = {
  [1] = 0.9,
  [2] = 1.04,
  [3] = 1.18,
  [4] = 1.32
}

GameRules.gem_path_show = {}
GameRules.table_bubbles = {}

GameRules.gem_boss_damage_all = 0
GameRules.is_boss_entered = false

GameRules.kills = 0

GameRules.default_stone = {
    [1] = {
      [1] = { x = 1, y = 19 },
      [2] = { x = 2, y = 19 },
      [3] = { x = 3, y = 19 },
      [4] = { x = 4, y = 19 },
      [5] = { x = 37, y = 19 },
      [6] = { x = 36, y = 19 },
      [7] = { x = 35, y = 19 },
      [8] = { x = 34, y = 19 },
      [9] = { x = 19, y = 1 },
      [10] = { x = 19, y = 2 },
      [11] = { x = 19, y = 3 },
      [12] = { x = 19, y = 4 },
      [13] = { x = 19, y = 37 },
      [14] = { x = 19, y = 36 },
      [15] = { x = 19, y = 35 },
      [16] = { x = 19, y = 34 },
      [17] = { x = 6, y = 19 },
      [18] = { x = 7, y = 19 },
      [19] = { x = 8, y = 19 },
      [20] = { x = 9, y = 19 },
      [21] = { x = 32, y = 19 },
      [22] = { x = 31, y = 19 },
      [23] = { x = 30, y = 19 },
      [24] = { x = 29, y = 19 },
      [25] = { x = 19, y = 6 },
      [26] = { x = 19, y = 7 },
      [27] = { x = 19, y = 8 },
      [28] = { x = 19, y = 9 },
      [29] = { x = 19, y = 32 },
      [30] = { x = 19, y = 31 },
      [31] = { x = 19, y = 30 },
      [32] = { x = 19, y = 29 }
      },
    [2] = {
      [1] = { x = 1, y = 19 },
      [2] = { x = 2, y = 19 },
      [3] = { x = 3, y = 19 },
      [4] = { x = 4, y = 19 },
      [5] = { x = 37, y = 19 },
      [6] = { x = 36, y = 19 },
      [7] = { x = 35, y = 19 },
      [8] = { x = 34, y = 19 },
      [9] = { x = 19, y = 1 },
      [10] = { x = 19, y = 2 },
      [11] = { x = 19, y = 3 },
      [12] = { x = 19, y = 4 },
      [13] = { x = 19, y = 37 },
      [14] = { x = 19, y = 36 },
      [15] = { x = 19, y = 35 },
      [16] = { x = 19, y = 34 }
      },
    [3] = {
      [1] = { x = 1, y = 19 },
      [2] = { x = 2, y = 19 },
      [3] = { x = 37, y = 19 },
      [4] = { x = 36, y = 19 },
      [5] = { x = 19, y = 1 },
      [6] = { x = 19, y = 2 },
      [7] = { x = 19, y = 37 },
      [8] = { x = 19, y = 36 },
      },
    [4] = {}
  }

GameRules.is_default_builded = false

GameRules.gem_nandu = 0

GameRules.is_debug = true

GameRules.gem_path = {
  {},{},{},{},{},{}
}
GameRules.gem_path_all = {}
GameRules.gem_path_speed = { {{},{},{},{},{},{}}, {{},{},{},{},{},{}}, {{},{},{},{},{},{}}, {{},{},{},{},{},{}}}
GameRules.gem_path_all_speed = {{},{},{},{}}

GameRules.game_status = 0   --0 = 准备时间, 1 = 建造时间, 2 = 刷怪时间

GameRules.start_level = 1
GameRules.level = GameRules.start_level
GameRules.level_speed = {GameRules.start_level, GameRules.start_level, GameRules.start_level, GameRules.start_level}
GameRules.gem_is_shuaguaiing = false
GameRules.gem_is_shuaguaiing_speed = {false,false,false,false}
GameRules.guai_count = 10
GameRules.guai_count_speed = {10,10,10,10}
GameRules.guai_live_count = 0
GameRules.guai_live_count_speed = {0,0,0,0}
GameRules.gemtd_pool_can_merge_all = {}

GameRules.gem_player_count = 0
GameRules.gem_hero_count = 0
GameRules.gem_maze_length = 0
GameRules.gem_maze_length_speed = {0,0,0,0}
GameRules.team_gold = 0
GameRules.gem_swap = {}
GameRules.damage = {}

GameRules.is_cheat = false
GameRules.check_cheat_interval = 5

GameRules.max_xy = 40
GameRules.max_grids = GameRules.max_xy * GameRules.max_xy
GameRules.start_time = 0
GameRules.random_seed_levels = 1
GameRules.online_player_count = 0

  CustomGameEventManager:RegisterListener("get_mvp_text", Dynamic_Wrap(GameMode, "OnReceiveMvpText") )
  CustomGameEventManager:RegisterListener("gather_steam_ids", Dynamic_Wrap(GameMode, "OnReceiveSteamIDs") )
  CustomGameEventManager:RegisterListener("player_share_map", Dynamic_Wrap(GameMode, "OnReceiveShareMap") )
  CustomGameEventManager:RegisterListener("gemtd_hero", Dynamic_Wrap(GameMode, "OnReceiveHeroInfo") )
  CustomGameEventManager:RegisterListener("gemtd_repick_hero", Dynamic_Wrap(GameMode, "OnRepickHero") )

GameRules.guai = {
  [1] = "gemtd_kuangbaoyezhu",
  [2] = "gemtd_kuaidiqingwatiaotiao",
  [3] = "gemtd_zhongchenggaoshanmaoniu",
  [4] = "gemtd_moluokedejixiezhushou",
  [5] = "gemtd_wuweizhihuan_fly",
  [105] = "gemtd_xiaohongmao_fly",
  [6] = "gemtd_shudunziranzhizhu",
  [7] = "gemtd_chaomengjuxi",
  [8] = "gemtd_mengzhu",
  [9] = "gemtd_dashiqi",
  [10] = "gemtd_buquzhanquan_boss",
  [11] = "gemtd_maorongrongdefeiyangyang",
  [12] = "gemtd_caonimalama",
  [13] = "gemtd_fengtungongzhu",
  [14] = "gemtd_bugou",
  [15] = "gemtd_banzhuduizhang_fly",
  [115] = "gemtd_tianmaodigou_fly",
  [16] = "gemtd_xunjiemotong",
  [17] = "gemtd_yonggandexiaoji",
  [18] = "gemtd_xiaobajie",
  [19] = "gemtd_shentu",
  [119] = "gemtd_yaobaidelvgemi",
  [20] = "gemtd_huxiaotao_boss",
  [21] = "gemtd_siwangsiliezhe",
  [22] = "gemtd_yaorenxiangluoke",
  [23] = "gemtd_tiezuiyaorenxiang",
  [123] = "gemtd_dazuiyaorenxiang",
  [24] = "gemtd_jixieyaorenxiang",
  [124] = "gemtd_jixiezhanlv",
  [25] = "gemtd_fengbaozhizikesaier_fly",
  [125] = "gemtd_huoxingche_fly",
  [26] = "gemtd_niepanhuolieniao",
  [27] = "gemtd_lgddejinmengmeng_fly",
  [28] = "gemtd_youniekesizhinu_fly",
  [128] = "gemtd_xiaofamuji_fly",
  [29] = "gemtd_feihuxia_fly",
  [30] = "gemtd_mofafeitanxiaoemo_boss_fly",
  [31] = "gemtd_modianxiaolong",
  [32] = "gemtd_xiaoshayu",
  [33] = "gemtd_feijiangxiaobao",
  [133] = "gemtd_siwangxianzhi",
  [34] = "gemtd_shangjinbaobao_fly",
  [134] = "gemtd_xuemobaobao_fly",
  [35] = "gemtd_jinyinhuling_fly",
  [36] = "gemtd_cuihua",
  [37] = "gemtd_xiaobaihu",
  [38] = "gemtd_xiaoxingyue",
  [39] = "gemtd_liangqiyuhai_fly",
  [139] = "gemtd_fennenrongyuan_fly",
  [40] = "gemtd_guixiaoxieling_boss_fly",
  [41] = "gemtd_weilanlong",
  [141] = "gemtd_cuiyuxiaolong",
  [42] = "gemtd_saodiekupu_fly",
  [43] = "gemtd_maomaoyu",
  [44] = "gemtd_xiaomogu",
  [45] = "gemtd_jiujiu_fly",
  --[46] = "gemtd_juniaoduoduo_tester"
  [46] = "gemtd_siwangxintu",
  [47] = "gemtd_jilamofashi",
  [48] = "gemtd_xiaofeixia_fly",
  [49] = "gemtd_juniaoduoduo",
  [50] = "gemtd_roushan_boss_fly",
}
GameRules.guai_ability = {
  [1] = {},
  [2] = {},
  [3] = {},
  [4] = {},
  [5] = {},
  [6] = {},
  [7] = {},
  [8] = {},
  [9] = {"phantom_assassin_blur"},
  [10] ={},
  [11] = {},
  [12] = {"guai_jiaoxieguanghuan"},
  [13] = {},
  [14] = {},
  [15] = {},
  [16] = {},
  [17] = {"enemy_bukeqinfan"},
  [18] = {"guai_jiaoxieguanghuan"},
  [19] = {"phantom_assassin_blur"},
  [20] = {},
  [21] = {},
  [22] = {"enemy_high_armor"},
  [23] = {},
  [24] = {"shredder_reactive_armor"},
  [25] = {"enemy_high_armor"},
  [26] = {},
  [27] = {"enemy_bukeqinfan"},
  [28] = {"shredder_reactive_armor"},
  [29] = {"phantom_assassin_blur"},
  [30] = {},
  [31] = {},
  [32] = {"enemy_recharge"},
  [33] = {},
  [34] = {"phantom_assassin_blur"},
  [35] = {},
  [36] = {},
  [37] = {"enemy_bukeqinfan"},
  [38] = {"guai_jiaoxieguanghuan"},
  [39] = {"enemy_bukeqinfan","tidehunter_kraken_shell","phantom_assassin_blur"},
  [40] = {"tidehunter_kraken_shell"},
  [41] = {},
  [42] = {},
  [43] = {"enemy_bukeqinfan","phantom_assassin_blur","enemy_recharge"},
  [44] = {"guai_jiaoxieguanghuan"},
  [45] = {"guai_jiaoxieguanghuan"},
  --[46] = {"tidehunter_kraken_shell"},
  [46] = {},
  [47] = {"enemy_bukeqinfan","enemy_recharge"},
  [48] = {"guai_jiaoxieguanghuan","phantom_assassin_blur"},
  [49] = {"tidehunter_kraken_shell","enemy_recharge"},
  [50] = {"tidehunter_kraken_shell"},
}
GameRules.guai_tips = {
  [1] = "",
  [2] = "",
  [3] = "",
  [4] = "",
  [5] = "#text_tips_flying",
  [6] = "",
  [7] = "",
  [8] = "#text_tips_invisibility",
  [9] = "",
  [10] = "#text_tips_boss",
  [11] = "",
  [12] = "",
  [13] = "",
  [14] = "",
  [15] = "#text_tips_flying",
  [16] = "",
  [17] = "",
  [18] = "#text_tips_invisibility",
  [19] = "",
  [20] = "#text_tips_boss",
  [21] = "",
  [22] = "",
  [23] = "",
  [24] = "",
  [25] = "#text_tips_flying",
  [26] = "",
  [27] = "#text_tips_flying",
  [28] = "#text_tips_flying",
  [29] = "#text_tips_flying",
  [30] = "#text_tips_boss",
  [31] = "",
  [32] = "",
  [33] = "",
  [34] = "#text_tips_flying",
  [35] = "#text_tips_flying",
  [36] = "",
  [37] = "",
  [38] = "",
  [39] = "#text_tips_flying",
  [40] = "#text_tips_boss",
  [41] = "",
  [42] = "#text_tips_flying",
  [43] = "",
  [44] = "",
  [45] = "#text_tips_flying",
  --[46] = "#text_tips_tester",
}

-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]



function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  --hero:SetGold(500, false)

  local spawned_unit = EntIndexToHScript(hero.entindex)

  local spawned_unit_name = spawned_unit:GetUnitName()

  --英雄出生
  if spawned_unit:IsHero() then
    spawned_unit.ftd = 2009

    local owner = spawned_unit:GetOwner()
    local player_id = owner:GetPlayerID()


    -- print ("hero select")
    -- GameRules.gem_hero_count = GameRules.gem_hero_count + 1
    -- print ("hero_count:"..GameRules.gem_hero_count)
    -- GameRules:SendCustomMessage("实际英雄数："..GameRules.gem_hero_count, 0, 0)


    -- local particle2 = ParticleManager:CreateParticle("particles/kunkka_hehe.vpcf", PATTACH_ABSORIGIN_FOLLOW, spawned_unit)
    -- ParticleManager:SetParticleControl(particle2, 0, spawned_unit:GetAbsOrigin())
    -- spawned_unit.xxx = particle2

    --spawned_unit:AddAbility("tower_fenliejian_you")
    --spawned_unit:FindAbilityByName("tower_fenliejian_you"):SetLevel(1)

    spawned_unit:SetHullRadius(2)

    GameRules.gem_hero[player_id] = spawned_unit
  end

  local abil1 = hero:GetAbilityByIndex(0)
  abil1:SetLevel(1) --[[Returns:void
  Sets the level of this ability.
  ]]
  local abil2 = hero:GetAbilityByIndex(1)
  abil2:SetLevel(1)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

      Timers:CreateTimer(2,function()
      GameRules:SendCustomMessage("#text_game_start", 0, 0)
      GameRules:GetGameModeEntity().game_time = GameRules:GetGameTime()
      GameRules.game_status = 1
      start_build()
      end)
      --[[
  Timers:CreateTimer(10, -- Start this timer 10 game-time seconds later
    function()
      print("This function is called 10 seconds after the game begins, and every 10 seconds thereafter")
      find_all_path()
      print_gem_map()
      DebugPrint('Timer Output')
      return 10.0 -- Rerun this timer every 10 game-time seconds 
    end)
  ]]
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')
  AMHCInit();
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  --Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')

  GameRules:GetGameModeEntity().gem_map ={}
  for i=1,37 do
      GameRules:GetGameModeEntity().gem_map[i] = {}   
      for j=1,37 do
         GameRules:GetGameModeEntity().gem_map[i][j] = 0
      end
  end
  GameRules:GetGameModeEntity().gem_castle_hp = 100
  GameRules:GetGameModeEntity().gem_castle_hp_speed = { 100,100,100,100 }
  GameRules:GetGameModeEntity().gem_castle = nil
  GameRules:GetGameModeEntity().gem_castle_speed = { nil,nil,nil,nil }

  GameRules:GetGameModeEntity().is_build_ready = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
  }

  local u = CreateUnitByName("gemtd_castle", Entities:FindByName(nil,"path7"):GetAbsOrigin() ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
  u.ftd = 2009
  u:AddAbility("no_hp_bar")
  u:FindAbilityByName("no_hp_bar"):SetLevel(1)
  u:RemoveModifierByName("modifier_invulnerable")
  u:SetHullRadius(64)
  u:SetForwardVector(Vector(-1,0,0))
  GameRules:GetGameModeEntity().gem_castle = u

  gemtd_randomize()
  GameRules:GetGameModeEntity().navi = RandomInt(1000,9999)
  GameRules:GetGameModeEntity().hero = {}
  GameRules:GetGameModeEntity().online_player_count = 0

end

function OnThink()
  
    time_tick = time_tick +1
  --print(time_tick)

  if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

    local i = 0
    for i = 0, 9 do
      if ( PlayerResource:IsValidPlayer( i ) ) then
        local player = PlayerResource:GetPlayer(i)
        if player ~= nil then
          local h = player:GetAssignedHero()
          if h ~= nil and h:GetAbilityPoints() ~=0 then
            --h:DestroyAllSpeechBubbles()
            --h:AddSpeechBubble(2,"#text_i_level_up",3,0,30)
            if h:GetLevel() > 1 then
              createHintBubble(h,"#text_i_level_up")
            end
            h:SetAbilityPoints(0)
            CustomNetTables:SetTableValue( "game_state", "gem_team_level", { level = h:GetLevel() } );
          end
        end
      end
    end

    --超时加狂暴
    if GetMapName() == "gemtd_coop" then
      if GameRules.stop_watch ~= nil then
        local time_this_level = math.floor(GameRules:GetGameTime() - GameRules.stop_watch)

        local kuangbao_time = PlayerResource:GetPlayerCount()*120 + 120

        if time_this_level > kuangbao_time and not GameRules.is_crazy == true then
          GameRules.is_crazy = true
          GameRules:SendCustomMessage("#text_enemy_crazy", 0, 0)
          EmitGlobalSound("diretide_eventstart_Stinger")

          GameRules:GetGameModeEntity().gem_castle:AddAbility("enemy_crazy")
          GameRules:GetGameModeEntity().gem_castle:FindAbilityByName("enemy_crazy"):SetLevel(1)
        end
      end
    end

    --刷怪
    if ( GameRules.gem_is_shuaguaiing==true and not GameRules:IsGamePaused()) then
      local ShuaGuai_entity = Entities:FindByName(nil,"path1")
      local position = ShuaGuai_entity:GetAbsOrigin() 
      position.z = 150

      local u = nil

      local guai_name  = GameRules.guai[GameRules.level]

      --有些关卡有特殊刷怪逻辑
      if (GameRules.level ==35 and RandomInt(1,100)>50 ) then
        guai_name = guai_name.."1"
      end
      if (GameRules.level ==36 and RandomInt(1,100)>50 ) then
        guai_name = guai_name.."1"
      end
      if (GameRules.level ==38 and RandomInt(1,100)>50 ) then
        guai_name = guai_name.."1"
      end
      if (GameRules.level ==30 and RandomInt(1,100)>90 ) then
        guai_name = "gemtd_zard_boss_fly"
      end
      if (GameRules.level ==50 and RandomInt(1,100)>80 ) then
        guai_name = "gemtd_roushan_boss_fly_jin"
      end
      if (GameRules.level ==50 and RandomInt(1,100)>90 ) then
        guai_name = "gemtd_roushan_boss_fly_bojin"
      end
      -- if (GameRules.level ==46) then
      --  for i,vi in pairs (GameRules.gemtd_pool) do
      --    vi:RemoveModifierByName('modifier_gemtd_hero_miaozhun')
      --    vi:RemoveModifierByName('modifier_gemtd_hero_baoji')
      --    vi:RemoveModifierByName('modifier_gemtd_hero_kuaisusheji')
      --  end     
      -- end

        u = CreateUnitByName(guai_name, position,true,nil,nil,DOTA_TEAM_BADGUYS) 
        u.ftd = 2009

        

        
        if GameRules.is_debug == true then
          GameRules:SendCustomMessage("PlayerResource里的玩家数: "..PlayerResource:GetPlayerCount(), 0, 0)
        end

        if GameRules.gem_nandu <= PlayerResource:GetPlayerCount() then
          GameRules.gem_nandu = PlayerResource:GetPlayerCount()
        end

        if GameRules.is_debug == true then
          GameRules:SendCustomMessage("难度等级： "..GameRules.gem_nandu, 0, 0)
          GameRules:SendCustomMessage("难度系数： "..GameRules.gem_difficulty[GameRules.gem_nandu], 0, 0)
      end

        if GameRules.gem_difficulty[GameRules.gem_nandu] == nil then
          GameRules:SendCustomMessage("BUG le", 0, 0)
        end

        --添加技能
        for ab,abab in pairs(GameRules.guai_ability[GameRules.level]) do
          u:AddAbility(abab)
        u:FindAbilityByName(abab):SetLevel(GameRules.gem_nandu)
        end

        local random_hit = 1
        if (not string.find(guai_name, "boss")) and (not string.find(guai_name, "tester")) then
          if RandomInt(1,400) <= (1) then
            GameRules:SendCustomMessage("#text_a_elite_enemy_is_coming", 0, 0)
            EmitGlobalSound("DOTA_Item.ClarityPotion.Activate")
            random_hit = 4.0
            u:SetModelScale(u:GetModelScale()*2.0)
            u.is_jingying = true
          end
      end

      -- if (GameRules.level ==20) then
      --  --回光返照
      --  u:FindAbilityByName("abaddon_borrowed_time"):SetLevel(1)
      -- end


        local maxhealth = u:GetBaseMaxHealth() * GameRules.gem_difficulty[GameRules.gem_nandu] * random_hit
      u:SetBaseMaxHealth(maxhealth)
      u:SetMaxHealth(maxhealth)
      u:SetHealth(maxhealth)

      u:AddNewModifier(u,nil,"modifier_bloodseeker_thirst",nil)
      u:SetBaseMoveSpeed(u:GetBaseMoveSpeed()*GameRules.gem_difficulty_speed[GameRules.gem_nandu])


        u:SetHullRadius(1)

        u:AddAbility("no_pengzhuang")
      u:FindAbilityByName("no_pengzhuang"):SetLevel(1)

      u:SetContextNum("step",1,0)
      u.damage = 1+RandomInt(0,3)
      if GameRules.level >10 and GameRules.level <20 then
        u.damage = 1+RandomInt(0,7)
      elseif GameRules.level >20 and GameRules.level <30 then
        u.damage = 1+RandomInt(0,11)
      elseif GameRules.level >30 and GameRules.level <40 then
        u.damage = 1+RandomInt(0,15)
      elseif GameRules.level >40 and GameRules.level <50 then
        u.damage = 1+RandomInt(0,19)
      end

      if GameRules.level ==10 then
        u.damage = 80
      end
      if GameRules.level ==20 then
        u.damage = 80
      end
      if GameRules.level ==30 then
        u.damage = 80
      end
      if GameRules.level ==40 then
        u.damage = 80
      end
      if GameRules.level ==50 then
        u.damage = 80
      end


      u:SetBaseDamageMin(u.damage)
      u:SetBaseDamageMax(u.damage)

      u.position = u:GetAbsOrigin() 

      GameRules.guai_count = GameRules.guai_count -1
      GameRules.guai_live_count = GameRules.guai_live_count + 1



      if string.find(guai_name, "boss") then
        --PrecacheResource( "soundfile",  zr[i], context)
        GameRules.guai_count = GameRules.guai_count -100
      end

      if string.find(guai_name, "tester") then    
        --PrecacheResource( "soundfile",  zr[i], context)   
        GameRules.guai_count = GameRules.guai_count -100    
      end

      --u是刚刷的怪
      --目标点数组：GameRules.gem_path_all

      --命令移动
      Timers:CreateTimer(0.1, function()
          if (u:IsNull()) or (not u:IsAlive()) then
            --GameRules:SendCustomMessage(u:GetUnitName().."死亡了", 0, 0)
            return nil
          end

          if (u.target == nil) then  --无目标点
            u.target = 1
            u:MoveToPosition(GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
            return 0.1
          else  --有目标点
            if ( u:GetAbsOrigin() - GameRules.gem_path_all[u.target] ):Length2D() <32 then
              u.target = u.target + 1
              u:MoveToPosition(GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
              
              return 0.1
            else
              u:MoveToPosition(GameRules.gem_path_all[u.target]+Vector(RandomInt(-5,5),RandomInt(-5,5),0))
              return 0.1
            end
          end
        end
      )


      if GameRules.guai_count<=0 then
        GameRules.gem_is_shuaguaiing=false
      end
    end
    


    --判断是否有怪到达城堡
    local ShuaGuai_entity = Entities:FindByName(nil,"path7")
    local position = ShuaGuai_entity:GetAbsOrigin() 
    local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              position,
                              nil,
                              256,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
    for aaa,unit in pairs(direUnits) do
      --对城堡造成伤害

      local damage = unit.damage

          if string.find(unit:GetUnitName(), "boss") or string.find(unit:GetUnitName(), "tester") then
            --BOSS, 根据血量计算伤害
            local boss_damage = unit:GetMaxHealth() - unit:GetHealth()
            local boss_damage_per = math.floor(boss_damage / unit:GetMaxHealth() * 100)

            if damage >0 then 
              damage = math.floor(damage * (100-boss_damage_per)/100) + 10
            else
              damage = 0
            end

            GameRules.gem_boss_damage_all = GameRules.gem_boss_damage_all + boss_damage

            --GameRules:SendCustomMessage("DAMAGE +"..boss_damage, 0, 0)
            GameRules.is_boss_entered = true
          end

          -- 判断闪避
          if GameRules:GetGameModeEntity().gem_castle.shanbi ~= nil then
            if RandomInt(0,100) < tonumber(GameRules:GetGameModeEntity().gem_castle.shanbi) then
              EmitGlobalSound("n_creep_ghost.Death")
              damage = 0
          local particle = ParticleManager:CreateParticle("particles/gem/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, GameRules:GetGameModeEntity().gem_castle) 

          Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(particle,true)
          end)
            end
          end
          -- 判断格挡
          if GameRules:GetGameModeEntity().gem_castle.shouhu ~= nil then
          EmitGlobalSound("Item.LotusOrb.Destroy")
          damage = damage - tonumber(GameRules:GetGameModeEntity().gem_castle.shouhu)
          if damage < 0 then
            damage = 0
          end
          end

      GameRules:GetGameModeEntity().gem_castle_hp = GameRules:GetGameModeEntity().gem_castle_hp - damage

      CustomNetTables:SetTableValue( "game_state", "gem_life", { gem_life = GameRules:GetGameModeEntity().gem_castle_hp } );

      if damage > 0 then

        GameRules.quest_status["q107"] = false

        EmitGlobalSound("DOTA_Item.Maim")
        play_particle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf",PATTACH_OVERHEAD_FOLLOW,GameRules:GetGameModeEntity().gem_castle,2)
        AMHC:CreateNumberEffect(GameRules:GetGameModeEntity().gem_castle,damage,5,AMHC.MSG_DAMAGE,"red",3)

        -- for k,h in pairs(GameRules:GetGameModeEntity().hero) do
        --  play_particle("particles/generic_gameplay/screen_damage_indicator.vpcf",PATTACH_EYES_FOLLOW,h,2)

        --  -- Timers:CreateTimer(2,function()
        --  --  ParticleManager:DestroyParticle(blood_pfx,true)
        --  -- end)
        -- end

      end

      GameRules:GetGameModeEntity().gem_castle:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp)
      ScreenShake(Vector(150,150,0), 320, 3.2, 2, 10000, 0, false)  --无效? vsb

      PlayerResource:IncrementDeaths(0 , 1)
      PlayerResource:IncrementDeaths(1 , 1)
      PlayerResource:IncrementDeaths(2 , 1)
      PlayerResource:IncrementDeaths(3 , 1)



      --英雄同步血量
      local ii = 0
      for ii = 0, 9 do
        if ( PlayerResource:IsValidPlayer( ii ) ) then
          local player = PlayerResource:GetPlayer(ii)
          if player ~= nil then
            local h = player:GetAssignedHero()
            if h~= nil then
              h:SetHealth(GameRules:GetGameModeEntity().gem_castle_hp)
            end
          end
        end
      end

      --背水一战等级调整
      if GameRules:GetGameModeEntity().gem_castle.beishuiyizhan ~= nil then
        local beishui_level = (100-GameRules:GetGameModeEntity().gem_castle_hp)/10+1
        print(beishui_level)

        GameRules:GetGameModeEntity().gem_castle:FindAbilityByName(GameRules:GetGameModeEntity().gem_castle.beishuiyizhan):SetLevel(tonumber(beishui_level))
      end


      -- --给玩家经验
      -- local exp_count = 5
      -- if GameRules.level ==10 then
      --  exp_count = 200
      -- end
      -- if GameRules.level ==20 then
      --  exp_count = 300
      -- end
      -- if GameRules.level ==30 then
      --  exp_count = 400
      -- end
      -- if GameRules.level ==40 then
      --  exp_count = 500
      -- end
      -- if GameRules.level >=11 and GameRules.level <=19 then
      --  exp_count = 10
      -- end
      -- if GameRules.level >=21 and GameRules.level <=29 then
      --  exp_count = 15
      -- end
      -- if GameRules.level >=31 and GameRules.level <=39 then
      --  exp_count = 20
      -- end
      -- local exp_percent = 1

      -- exp_count = exp_count * exp_percent

      -- if (unit~= nil and unit.is_jingying == true) then
      --  exp_count = exp_count * 4
      -- end

      -- local i = 0
      -- for i = 0, 9 do
      --  if ( PlayerResource:IsValidPlayer( i ) ) then
      --    local player = PlayerResource:GetPlayer(i)
      --    if player ~= nil then
      --      local h = player:GetAssignedHero()
      --      if h ~= nil then
      --        h:AddExperience (-exp_count,0,false,false)
      --      end
      --    end
      --  end
      -- end

      -- GameRules.team_gold = GameRules.team_gold - exp_count
      -- --同步玩家金钱
      -- local ii = 0
      -- for ii = 0, 20 do
      --  if ( PlayerResource:IsValidPlayer( ii ) ) then
      --    local player = PlayerResource:GetPlayer(ii)
      --    if player ~= nil then
      --      PlayerResource:SetGold(ii, GameRules.team_gold, true)
      --    end
      --  end
      -- end
      -- CustomNetTables:SetTableValue( "game_state", "gem_team_gold", { gold = GameRules.team_gold } );

      --城堡被摧毁则游戏失败
      if GameRules:GetGameModeEntity().gem_castle_hp <=0 then
        GameRules.game_status = 3
        Timers:CreateTimer(20, function()
          GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
        end)
        
        send_ranking ()
        return
      end

      unit.is_entered = true

        unit:Destroy()
        GameMode:OnEntityKilled( nil )
    end

  elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return nil
  end
  return 1
end


function find_all_path()
  

  GameRules.gem_maze_length = 0

  GameRules.gem_path = {
    {},{},{},{},{},{}
  }
  local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
  local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
  find_path(p1,p2,1)
  local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
  find_path(p2,p3,2)
  local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
  find_path(p3,p4,3)
  local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
  find_path(p4,p5,4)
  local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
  find_path(p5,p6,5)
  local p7 = Entities:FindByName(nil,"path7"):GetAbsOrigin()
  find_path(p6,p7,6)

  CustomNetTables:SetTableValue( "game_state", "gem_maze_length", { length = math.modf(GameRules.gem_maze_length) } );

  GameRules.gem_path_all = {}
  for i = 1,6 do
    for j = 1,table.maxn(GameRules.gem_path[i])-1 do
      table.insert (GameRules.gem_path_all, GameRules.gem_path[i][j])
    end
  end
  table.insert (GameRules.gem_path_all, p7)


  if GameRules:GetGameModeEntity().gem_path_show == nil then
    GameRules:GetGameModeEntity().gem_path_show = {}
  end

  for i = 1,table.maxn(GameRules:GetGameModeEntity().gem_path_show) do
    ParticleManager:DestroyParticle(GameRules:GetGameModeEntity().gem_path_show[i],false)
    ParticleManager:ReleaseParticleIndex(GameRules:GetGameModeEntity().gem_path_show[i])
  end
  GameRules:GetGameModeEntity().gem_path_show = {}


  for i = 2,table.maxn(GameRules.gem_path_all) do
    local ice_wall_particle_effect_b = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_mana_drain.vpcf", PATTACH_ABSORIGIN, GameRules.gem_castle)
    ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 0, GameRules.gem_path_all[i-1])
    ParticleManager:SetParticleControl(ice_wall_particle_effect_b, 1, GameRules.gem_path_all[i])
    table.insert (GameRules:GetGameModeEntity().gem_path_show, ice_wall_particle_effect_b)
  end
end

function find_path(p1,p2,step)

  -- Value for walkable tiles
  local walkable = 0

  -- Library setup
  local Grid = require ("pathfinder/grid") -- The grid class
  local Pathfinder = require ("pathfinder/pathfinder") -- The pathfinder lass

  -- Creates a grid object
  local grid = nil

  grid = Grid(GameRules:GetGameModeEntity().gem_map)
  --grid = Grid(map)

  -- Creates a pathfinder object using Jump Point Search
  local myFinder = nil
  myFinder = Pathfinder(grid, 'JPS', walkable)

  local xxx1 = math.floor((p1.x+64)/128)+19
  local yyy1 = math.floor((p1.y+64)/128)+19
  local xxx2 = math.floor((p2.x+64)/128)+19
  local yyy2 = math.floor((p2.y+64)/128)+19

  -- Define start and goal locations coordinates
  local startx, starty = xxx1,yyy1
  local endx, endy = xxx2, yyy2

  --local startx, starty = 2,2
  --local endx, endy = 9,9

  -- Calculates the path, and its length
  local path, length = myFinder:getPath(startx, starty, endx, endy)

  if path then
    --这部分算法待优化
    local dx = 0
    local dy = 0
    local lastx = -100
    local lasty = -100
    local lastdx = -100
    local lastdy = -100
    local lastd = -100
    local d = 0

    print(('Path found! Length: %.2f'):format(length))
    GameRules.gem_maze_length = GameRules.gem_maze_length + length
    
    for node, count in path:iter() do
      

        dx = node.x-lastx
        dy = node.y-lasty

        if dy==0 then
          d = 999
        else
          d = dx/dy
        end

        --print(('Step%d - %d,%d'):format(count, node.x, node.y))

        local lastindex = table.maxn (GameRules.gem_path[step])

        if d~=lastd or lastindex<=1 then
          local xxx = (node.x-19)*128
          local yyy = (node.y-19)*128
          local p = Vector(xxx,yyy,137)
          table.insert (GameRules.gem_path[step], p)
        else
          local xxx = (node.x-19)*128
          local yyy = (node.y-19)*128
          local p = Vector(xxx,yyy,137)
          
          GameRules.gem_path[step][lastindex] = p
        end


        lastdx = dx
        lastdy = dy
        lastx = node.x
        lasty = node.y
        lastd = d

    end
  else
    GameRules.gem_path[step] = {}
  end
end


function print_gem_map()
  local s = ""
  for i=1,37 do
      s = ""    
      for j=1,37 do
         s = s .. GameRules:GetGameModeEntity().gem_map[j][i]
      end
      print (s)
  end
end

function createHintBubble(unit, hint)
  Timers:CreateTimer(0.01, function()
    -- speech bubbles have a cap of 4 at the same time
    local duration = 3
    
    --check for active speech bubbles
    local bubble_index = table.getn(GameRules.table_bubbles)+1
    --print("bubble_index of current bubble", bubble_index)
    -- too many speech bubbles?
    if bubble_index > 4 then
      --local num = table.getn(table_bubbles)
      print("Too many speech bubbles at the moment : ", bubble_index)
      -- wait until bubbles expire
      Timers:CreateTimer(1,
      function()
        --try again
        createHintBubble(unit, hint)
        return nil
      end)
    else
      --less than 4 table_bubbles active
      -- +1 active bubble

      if unit:IsNull() then
        return nil
      end
      table.insert(GameRules.table_bubbles, bubble_index)
      unit:AddSpeechBubble(bubble_index-1, hint, duration, 0, -20)
      local new_bubble_index = bubble_index
      Timers:CreateTimer(3,
      function()
        --print("removing bubble_index", new_bubble_index)
        -- -1 active bubble
        GameRules.table_bubbles[new_bubble_index] = nil
        --table.remove(table_bubbles, new_bubble_index)
        --PrintTable(table_bubbles)
        return nil
      end)
    end
  end)
end

function start_build()

  GameRules.game_status = 1

  DeepPrintTable(GameRules:GetGameModeEntity().gem_castle)
  GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_crazy")
  GameRules:GetGameModeEntity().gem_castle:RemoveModifierByName("modifier_enemy_crazy")

  GameRules.stop_watch = nil
  GameRules.is_crazy = false

  if GameRules.level > table.maxn(GameRules.guai)+1 then
    return
  end

  if GameRules.level > 40 then
    --40关以后没有建造阶段了
    GameRules.game_status = 2
    start_shuaguai()
    return
  end

  if GameRules.is_debug == true then
    GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(0), 0, 0)
    GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(1), 0, 0)
    GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(2), 0, 0)
    GameRules:SendCustomMessage(PlayerResource:GetSelectedHeroName(3), 0, 0)
  end

  if PlayerResource:GetSelectedHeroName(0) ~= nil then
    CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );
  end
  
  if GameRules.level == GameRules.start_level and GameRules.is_default_builded == false then

    -- if GameRules.is_debug == true then
      GameRules:SendCustomMessage("first level", 0, 0)
    -- end

    GameRules:GetGameModeEntity().gem_map ={}
    for i=1,37 do
        GameRules:GetGameModeEntity().gem_map[i] = {}   
        for j=1,37 do
           GameRules:GetGameModeEntity().gem_map[i][j] = 0
        end
    end

    --创建初始的石头
    for i = 1,table.maxn(GameRules.default_stone[PlayerResource:GetPlayerCount()]) do
      --网格化坐标
      local x = GameRules.default_stone[PlayerResource:GetPlayerCount()][i].x
      local y = GameRules.default_stone[PlayerResource:GetPlayerCount()][i].y
      local xxx = (x-19)*128
      local yyy = (y-19)*128

      if GameRules:GetGameModeEntity().gem_map[y][x] == 0 then

        GameRules:GetGameModeEntity().gem_map[y][x]=1

        local p = Vector(xxx,yyy,128)
        p.z=1400
        local u2 = CreateUnitByName("gemtd_stone", p,false,nil,nil,DOTA_TEAM_GOODGUYS) 
        u2.ftd = 2009

        u2:SetOwner(PlayerResource:GetPlayer(0))
        u2:SetControllableByPlayer(0, true)
        u2:SetForwardVector(Vector(-1,0,0))

        u2:AddAbility("no_hp_bar")
        u2:FindAbilityByName("no_hp_bar"):SetLevel(1)
        u2:RemoveModifierByName("modifier_invulnerable")
        u2:SetHullRadius(64)
      end
    end

    GameRules.is_default_builded = true

    
  end

  find_all_path()
  print_gem_map()
  ShowCenterMessage( GameRules.guai_tips[GameRules.level], 10 )
  print(PlayerResource:GetPlayer(0))
  GameRules:SetTimeOfDay(0.3)

  EmitGlobalSound("Loot_Drop_Stinger_Legendary")
  --GameRules:SendCustomMessage("<font size='24'>#text_please_build_5_stones</font>", 0, 0)
  
  --给所有英雄建造和拆除的技能
  local ii = 0
  for ii = 0, 20 do
    if ( PlayerResource:IsValidPlayer( ii ) ) then
      local player = PlayerResource:GetPlayer(ii)
      if player ~= nil then
        local h = player:GetAssignedHero()
        if h~= nil then
          GameRules:GetGameModeEntity().is_build_ready[ii]=false

          -- if h:FindAbilityByName("gemtd_build_stone") == nil then
            GameRules:SendCustomMessage("#text_please_build_5_stones", 0, 0)
            createHintBubble(h,"#text_please_build_5_stones")

            h:RemoveAbility("gemtd_build_stone")
            h:RemoveAbility("gemtd_remove")

            h:AddAbility("gemtd_build_stone")
            h:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
            h:AddAbility("gemtd_remove")
            h:FindAbilityByName("gemtd_remove"):SetLevel(1)
          -- end

          if h.ability ~= nil then
            for a,va in pairs(h.ability) do
              h:RemoveAbility(a)
              h:AddAbility(a)
              h:FindAbilityByName(a):SetLevel(va)
            end
          end

          
        end
      end
    end
  end

  for i=0,3 do
    if GameRules.gem_hero[i] ~= nil then
      --GameRules:SendCustomMessage("给技能"..i, 0, 0)
      local h = GameRules.gem_hero[i]
      
      GameRules:GetGameModeEntity().is_build_ready[i]=false

      -- if h:FindAbilityByName("gemtd_build_stone") == nil then
        
        createHintBubble(h,"#text_please_build_5_stones")
        h:RemoveAbility("gemtd_build_stone")
        h:RemoveAbility("gemtd_remove")

        h:AddAbility("gemtd_build_stone")
        h:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
        h:AddAbility("gemtd_remove")
        h:FindAbilityByName("gemtd_remove"):SetLevel(1)
      -- end

      if h.ability ~= nil then
        for a,va in pairs(h.ability) do
          h:RemoveAbility(a)
          h:AddAbility(a)
          h:FindAbilityByName(a):SetLevel(va)
        end
      end

    end
  end
end

function start_shuaguai()

  if GameRules.level > 50 then
    return
  end

  CustomNetTables:SetTableValue( "game_state", "disable_all_repick", { hehe = RandomInt(1,10000) } );


  if GameRules.level == 1 then
    --背水一战技能
    local max_beishuiyizhan_level = 0
    for i,h in pairs(GameRules:GetGameModeEntity().hero) do
      if h:FindAbilityByName("gemtd_hero_beishuiyizhan") ~= nil and h:FindAbilityByName("gemtd_hero_beishuiyizhan"):GetLevel() > max_beishuiyizhan_level then
        max_beishuiyizhan_level = h:FindAbilityByName("gemtd_hero_beishuiyizhan"):GetLevel()
      end
    end
    if max_beishuiyizhan_level > 0 then
      GameRules:GetGameModeEntity().gem_castle.beishuiyizhan = "tower_beishuiyizhan"..max_beishuiyizhan_level
      GameRules:GetGameModeEntity().gem_castle:AddAbility("tower_beishuiyizhan"..max_beishuiyizhan_level)
      GameRules:GetGameModeEntity().gem_castle:FindAbilityByName("tower_beishuiyizhan"..max_beishuiyizhan_level):SetLevel(1)
    end
  end


  GameRules:SetTimeOfDay(0.8)
  GameRules.stop_watch = GameRules:GetGameTime()
  EmitGlobalSound("GameStart.RadiantAncient")

  --如果本关有备选怪，就随机
  if GameRules.guai[GameRules.level+100] ~= nil then
    if RandomInt(1,2) == 1 then
      GameRules.guai[GameRules.level] = GameRules.guai[GameRules.level+100]
    end
  end

  ShowCenterMessage("#"..GameRules.guai[GameRules.level], 8)

  CustomNetTables:SetTableValue( "game_state", "victory_condition", { kills_to_win = GameRules.level } );


  --GameRules:SendCustomMessage("玩家人数:"..player_count, 0, 0)

  GameRules.gem_is_shuaguaiing=true
  GameRules.guai_live_count = 0
  GameRules.guai_count = 10 --(player_count-1)*3 + 9


  -- GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_buff1")
  -- GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_buff2")
  -- GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_buff3")
  -- GameRules:GetGameModeEntity().gem_castle:RemoveAbility("enemy_buff4")

  -- GameRules:GetGameModeEntity().gem_castle:AddAbility("enemy_buff"..player_count)
  -- GameRules:GetGameModeEntity().gem_castle:FindAbilityByName("enemy_buff"..player_count):SetLevel(1)

  local guai_name  = GameRules.guai[GameRules.level]
  find_all_path()
  if string.find(guai_name, "fly") then
    find_all_path_fly()
    --GameRules:SendCustomMessage("飞行怪", 0, 0)
  end
  if string.find(guai_name, "boss") then
    --find_all_path_fly()
    GameRules:SendCustomMessage("BOSS", 0, 0)
  end

  --清空pray
  local i = 0
  for i = 0, 20 do
    if ( PlayerResource:IsValidPlayer( i ) ) then
      local player = PlayerResource:GetPlayer(i)
      if player ~= nil then
        local h = player:GetAssignedHero()
        if h ~= nil then
          h.pray = nil
          h.pray_color = nil
          h.perfected = false
        end
      end
    end
  end
end

function finish_build()

  --所有玩家都建造就绪了，开始刷怪
  if GameRules:GetGameModeEntity().is_build_ready[0]==true and GameRules:GetGameModeEntity().is_build_ready[1]==true and GameRules:GetGameModeEntity().is_build_ready[2]==true and GameRules:GetGameModeEntity().is_build_ready[3]==true then
    GameRules.game_status = 2
    start_shuaguai()

    --检查能否合成高级塔
    ----GameRules:SendCustomMessage("检查能否合成高级塔", 0, 0)
    for h,h_merge in pairs(GameRules.gemtd_merge) do
      ----GameRules:SendCustomMessage(h, 0, 0)
      local can_merge = true
      local merge_pool = {}

      for k,k_unitname in pairs(h_merge) do
        local have_merge = false
        for c,c_unit in pairs(GameRules.gemtd_pool) do
          if c_unit:GetUnitName()==k_unitname then
            --有这个合成配方
            have_merge =true
            table.insert (merge_pool, c_unit)
            --GameRules:SendCustomMessage("有"..k_unitname, 0, 0)
          end
        end
        if have_merge==false then
          can_merge = false
        end
      end

      if can_merge == true then
        --可以合成，给它们增加技能
        GameRules.gemtd_pool_can_merge[h] = {}

        for a,a_unit in pairs(merge_pool) do
          a_unit:RemoveAbility(h)
          a_unit:AddAbility(h)
          a_unit:FindAbilityByName(h):SetLevel(1)
          --a_unit:DestroyAllSpeechBubbles()
          --a_unit:AddSpeechBubble(1,"#text_can_merge_high_level_stone",3,0,-30)
          createHintBubble(a_unit,"#text_can_merge_high_level_stone")
          --GameRules:SendCustomMessage("可以合成"..h, 0, 0)

          table.insert (GameRules.gemtd_pool_can_merge[h], a_unit) 

          table.insert (GameRules.gemtd_pool_can_merge_all, h ) 
        end
      end

    end

  end
end

function ShowCenterMessage( msg, dur )
  local msg = {
    message = msg,
    duration = dur
  }
  --print( "Sending message to all clients." )
  FireGameEvent("show_center_message",msg)
end

function gemtd_randomize(s)
  if (not s) then
    s = tostring(RandomInt(100000, 999999))
  end
  
  hs = hash32(s)
  rng = mwc(hs)
  rng_pure = mwc()
  GameRules:GetGameModeEntity().rng ={}
  GameRules:GetGameModeEntity().rng.offset = rng:random(0)
  GameRules:GetGameModeEntity().rng.build_count = 0
    
  for i, v in pairs(GameRules.guai) do
    if (i > GameRules.random_seed_levels) then
      GameRules:GetGameModeEntity().rng[i] = rng_pure:random(0)
    else
      GameRules:GetGameModeEntity().rng[i] = rng:random(0)
    end
  end
end

function hash32(s)
  local h = md5.sumhexa(s)
  h = h.sub(h, -8)
  return tonumber("0x"..h)
end

function find_all_path_fly()

  
  local p1 = Entities:FindByName(nil,"path1"):GetAbsOrigin()
  local p2 = Entities:FindByName(nil,"path2"):GetAbsOrigin()
  local p3 = Entities:FindByName(nil,"path3"):GetAbsOrigin()
  local p4 = Entities:FindByName(nil,"path4"):GetAbsOrigin()
  local p5 = Entities:FindByName(nil,"path5"):GetAbsOrigin()
  local p6 = Entities:FindByName(nil,"path6"):GetAbsOrigin()
  local p7 = Entities:FindByName(nil,"path7"):GetAbsOrigin()

  GameRules.gem_path = {
    {p1,p2},{p2,p3},{p3,p4},{p4,p5},{p5,p6},{p6,p7}
  }

  GameRules.gem_path_all = {}
  for i = 1,6 do
    for j = 1,table.maxn(GameRules.gem_path[i])-1 do
      table.insert (GameRules.gem_path_all, GameRules.gem_path[i][j])
    end
  end
  table.insert (GameRules.gem_path_all, p7)
end

function GameMode:OnReceiveHeroInfo(keys)
  local heroindex = tonumber(keys.heroindex)
  local steam_id = keys.steam_id
  local onduty_hero = keys.onduty_hero.hero_id;
  local onduty_hero_info = keys.onduty_hero;

  if keys.is_black == 1 then
    GameRules:SendCustomMessage("#text_black", 0, 0)
    GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
    return
  end

  local heroindex_old = heroindex

  local hero = EntIndexToHScript(heroindex)

  local id = hero:GetPlayerID()
  --GameRules:SendCustomMessage("换英雄"..id.."--"..GameRules.hero_list[curr_hero], 0, 0)
  
  -- if (GameRules.replced[id] == false) then
    -- GameRules.replced[id] = true

  local is_can_build = 0
  if hero:FindAbilityByName("gemtd_build_stone") ~= nil then
    is_can_build = hero:FindAbilityByName("gemtd_build_stone"):GetLevel()
  end

    PrecacheUnitByNameAsync( GameRules.hero_sea[onduty_hero], function()
      local pppp = hero:GetAbsOrigin()
      hero:SetAbsOrigin(Vector(10000,10000,0))
      if hero.ppp ~= nil then
        ParticleManager:DestroyParticle(hero.ppp,true)
      end
      if hero.pp ~= nil then
        ParticleManager:DestroyParticle(hero.pp,true)
      end


      local hero_new = PlayerResource:ReplaceHeroWith(id,GameRules.hero_sea[onduty_hero],PlayerResource:GetGold(id),0)

      hero_new:RemoveAbility("techies_suicide")
      hero_new:RemoveAbility("techies_focused_detonate")
      hero_new:RemoveAbility("techies_land_mines")
      hero_new:RemoveAbility("techies_remote_mines")
      hero_new:RemoveAbility("techies_remote_mines_self_detonate")
      hero_new:RemoveAbility("techies_stasis_trap")   
      hero_new:RemoveAbility("techies_minefield_sign")  

      hero_new:SetAbsOrigin(Vector(0,0,0))
      FindClearSpaceForUnit(hero_new,Vector(0,0,0),false)

      hero_new:SetAbilityPoints(0)

      heroindex = hero_new:GetEntityIndex()

      --存在一个table里
      playerInfoReceived[heroindex] = {
        ["heroindex"] = heroindex,
        ["steam_id"] = steam_id,
        ["onduty_hero"] = onduty_hero,
      };

      --test
      -- for hh,hv in pairs(GameRules.hero_sea) do
      --  local u = CreateUnitByName(hv, Vector(0,0,0) ,false,nil,nil, DOTA_TEAM_GOODGUYS) 
      --  u.ftd = 2009
      --  u:SetOwner(hero_new:GetOwner())
      --  u:SetControllableByPlayer(0, true)
      -- end
      -- hero_new:AddAbility("e303")
      -- hero_new:FindAbilityByName("e303"):SetLevel(1)
      
      -- play_particle("particles/units/heroes/hero_siren/naga_siren_portrait.vpcf",PATTACH_EYES_FOLLOW,hero_new,20)

      --加技能
      hero_new:RemoveAbility("gemtd_build_stone")
      hero_new:RemoveAbility("gemtd_remove")

      hero_new:AddAbility("gemtd_build_stone")
      hero_new:FindAbilityByName("gemtd_build_stone"):SetLevel(is_can_build)
      hero_new:AddAbility("gemtd_remove")
      hero_new:FindAbilityByName("gemtd_remove"):SetLevel(is_can_build)

      -- hero_new:AddAbility("gemtd_hero_beishuiyizhan")
      -- hero_new:FindAbilityByName("gemtd_hero_beishuiyizhan"):SetLevel(2)
      -- hero_new:AddAbility("gemtd_hero_qingyi")
      -- hero_new:FindAbilityByName("gemtd_hero_qingyi"):SetLevel(4)
      -- hero_new:AddAbility("warlock_fatal_bonds")
      -- hero_new:FindAbilityByName("warlock_fatal_bonds"):SetLevel(4)

      hero_new:SetAbilityPoints(0)
      -- hero_new:AddAbility("gemtd_hero_putong")
      -- hero_new:FindAbilityByName("gemtd_hero_putong"):SetLevel(1)
      -- hero_new:AddAbility("gemtd_hero_wuxia")
      -- hero_new:FindAbilityByName("gemtd_hero_wuxia"):SetLevel(1)
      -- hero_new:AddAbility("gemtd_hero_wanmei")
      -- hero_new:FindAbilityByName("gemtd_hero_wanmei"):SetLevel(1)
      

      local a_count = 0
      if onduty_hero_info.ability ~= nil then

        --排序显示
        local key_test ={}
        for i in pairs(onduty_hero_info.ability) do
           table.insert(key_test,i)   --提取test1中的键值插入到key_test表中
        end
        table.sort(key_test)

        for i,v in pairs(key_test) do
          a_count = a_count+1
          local a = v
          local va = onduty_hero_info.ability[v]
          if GameRules.ability_sea[a]~=nil then
            print(">>>>"..GameRules.ability_sea[a]);
            hero_new:AddAbility(GameRules.ability_sea[a])
            hero_new:FindAbilityByName(GameRules.ability_sea[a]):SetLevel(va)
          end
        end
        hero.ability = onduty_hero_info.ability
      end
      local total_count = tonumber(string.sub(onduty_hero,2,2))
      local empty_count = total_count - a_count
      if empty_count > 0 then
        for i=1,empty_count do
          hero_new:AddAbility("empty"..i)
          hero_new:FindAbilityByName("empty"..i):SetLevel(1)
        end
      end
      
      if onduty_hero_info.effect ~= nil and onduty_hero_info.effect ~= "" then
        hero_new:AddAbility(onduty_hero_info.effect)
        hero_new:FindAbilityByName(onduty_hero_info.effect):SetLevel(1) 
        hero_new.effect = onduty_hero_info.effect
      end


      
      play_particle("particles/radiant_fx/radiant_tower002_destruction_a2.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero_new,2)

      GameRules:GetGameModeEntity().hero[heroindex_old] = nil
      GameRules:GetGameModeEntity().hero[hero_new:GetEntityIndex()] = hero_new

      CustomNetTables:SetTableValue( "game_state", "repick_hero", { old_index = heroindex_old, new_index = hero_new:GetEntityIndex() } );

      CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );

      createHintBubble(hero_new,"#text_hello")

      Timers:CreateTimer(1,function()
        --hero_new:DestroyAllSpeechBubbles()
        --hero_new:AddSpeechBubble(0,"#text_hello",3,0,30)
        
        hero_new:AddAbility("no_hp_bar")
        hero_new:FindAbilityByName("no_hp_bar"):SetLevel(1)

        -- hero_new:RemoveAbility("gemtd_build_stone")
        -- hero_new:RemoveAbility("gemtd_remove")

        -- hero_new:AddAbility("gemtd_build_stone")
        -- hero_new:FindAbilityByName("gemtd_build_stone"):SetLevel(is_can_build)
        -- hero_new:AddAbility("gemtd_remove")
        -- hero_new:FindAbilityByName("gemtd_remove"):SetLevel(is_can_build)


        --添加玩家颜色底盘
        local particle = ParticleManager:CreateParticle("particles/gem/team_"..(id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, hero_new) 
        hero_new.ppp = particle
        CustomNetTables:SetTableValue( "game_state", "hide_curtain", {} )

      end
      )
    end, id)
  -- end


  -- --服务器存的当前英雄仍有效，直接调用
  -- if curr_hero ~= 0 then
  --  print("ohyehaiyouyingxiong")
  --     hero:SetOriginalModel(GameRules.hero_list[tonumber(curr_hero)])
  --     hero:SetModel(GameRules.hero_list[tonumber(curr_hero)])
  --     GameRules.currHeroIds[steam_id] = tonumber(curr_hero)
  --     RandomAbility(tonumber(curr_hero), hero)
  -- --当前英雄已失效（服务器端置为0了）
  -- else
  --  --服务器发送的英雄池也为空，或不为空，50%概率仍然从基础角色中随机
 --     if hero_pool == nil or string.len(hero_pool) <=0 or RandomInt(0,100) > 50 then
  --      local random0 = RandomInt(1,20)
  --      while GameRules.hero_list[random0] == nil do
  --        random0 = RandomInt(1,20)
  --      end
  --      hero:SetOriginalModel(GameRules.hero_list[random0])
  --      hero:SetModel(GameRules.hero_list[random0])
  --      GameRules.currHeroIds[steam_id] = random0
  --      RandomAbility(random0, hero)
  --  --服务器发送的英雄池非空，50%概率从自有角色中随机
  --  else
  --    local pool = string.split(player_info.hero_pool,",")
  --    local random1 = RandomInt(1,table.maxn(pool))
  --    local random1_hero_id = pool[random1]
  --    local random1_hero_model = GameRules.hero_list[tonumber(random1_hero_id)]
  --      hero:SetOriginalModel(random1_hero_model)
  --      hero:SetModel(random1_hero_model)
  --      GameRules.currHeroIds[steam_id] = pool[random1]
  --      RandomAbility(tonumber(random1_hero_id), hero)
 --     end
 --    end
end

function GameMode:OnRepickHero(keys)
  local heroindex = keys.heroindex
  local steam_id = keys.steam_id
  local repick_hero = tonumber(keys.repick_hero)
  local repipck_hero_level = tonumber(keys.repipck_hero_level)

  -- print("GameRules:GetGameModeEntity().hero:")
  -- for iii,jjj in pairs(GameRules:GetGameModeEntity().hero) do
  --  print(iii..">>>"..jjj:GetUnitName())
  -- end

  local hero = GameRules:GetGameModeEntity().hero[heroindex]
  local id = hero:GetPlayerID()
  --GameRules:SendCustomMessage(heroindex.."换英雄"..id.."--"..GameRules.hero_list[repick_hero], 0, 0)

  play_particle("particles/items2_fx/refresher.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero,2)

  PrecacheUnitByNameAsync( GameRules.hero_sea[repick_hero], function()

    if hero.ppp ~= nil then
      ParticleManager:DestroyParticle(hero.ppp,true)
    end

    local hero_new = PlayerResource:ReplaceHeroWith(id,GameRules.hero_sea[repick_hero],PlayerResource:GetGold(id),0)
    GameRules.replced[id] = true

    GameRules:GetGameModeEntity().hero[heroindex] = nil
    GameRules:GetGameModeEntity().hero[hero_new:GetEntityIndex()] = hero_new

    CustomNetTables:SetTableValue( "game_state", "repick_hero", { old_index = heroindex, new_index = hero_new:GetEntityIndex() } );

    CustomNetTables:SetTableValue( "game_state", "select_hero1", { p1 = PlayerResource:GetSelectedHeroName(0), p2 = PlayerResource:GetSelectedHeroName(1), p3 = PlayerResource:GetSelectedHeroName(2), p4 = PlayerResource:GetSelectedHeroName(3) } );
    
    -- CustomNetTables:SetTableValue( "game_state", "disable_repick", { heroindex = hero_new:GetEntityIndex(), hehe = RandomInt(1,1000) } );

    --hero_new:DestroyAllSpeechBubbles()
    --hero_new:AddSpeechBubble(0,"#text_hello",3,0,30)
    createHintBubble(hero_new,"#text_hello")
    hero_new:SetAbilityPoints(0)

    hero_new:AddAbility("no_hp_bar")
    hero_new:FindAbilityByName("no_hp_bar"):SetLevel(1)

    hero_new:RemoveAbility("gemtd_build_stone")
    hero_new:RemoveAbility("gemtd_remove")

    hero_new:AddAbility("gemtd_build_stone")
    hero_new:FindAbilityByName("gemtd_build_stone"):SetLevel(1)
    hero_new:AddAbility("gemtd_remove")
    hero_new:FindAbilityByName("gemtd_remove"):SetLevel(1)

    local a = GameRules.ability_sea[repick_hero]
    hero_new:AddAbility(a)
    hero_new:FindAbilityByName(a):SetLevel(repipck_hero_level)
    hero_new.ability = a;
    hero_new.ability_level = repipck_hero_level;

    --添加玩家颜色底盘
    local particle = ParticleManager:CreateParticle("particles/gem/team_"..(id+1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, hero_new) 
    hero_new.ppp = particle
  end, id)
end

function GameMode:OnReceiveSteamIDs(keys)
  DeepPrintTable(keys)
  GameRules:GetGameModeEntity().player_ids = keys.steam_ids
  GameRules:GetGameModeEntity().steam_ids_only = keys.steam_ids_only
  GameRules:GetGameModeEntity().start_time = keys.start_time

  --GameRules:SendCustomMessage("black="..keys.is_black, 0, 0)

  if keys.is_black == 1 then
    GameRules:SendCustomMessage("#text_black", 0, 0)
    GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
  end

  --请求英雄数据
  print("Gather Steam Ids!")
  print(keys.steam_ids)
  GameRules.steam_ids = keys.steam_ids

  local url = "http://101.200.189.65:430/gemtd/heros/get/@"..keys.steam_ids.."?ver=v09g"

  local req = CreateHTTPRequest("GET", url)
  req:SetHTTPRequestAbsoluteTimeoutMS(20000)
  req:Send(function (result)

    local t = json.decode (result["Body"])

    -- local heroindex = keys.heroindex
    -- local steam_id = keys.steam_id
    -- local onduty_hero = keys.onduty_hero.hero_id;
    -- local onduty_hero_info = keys.onduty_hero;

    -- if keys.is_black == 1 then
    for u,v in pairs(t["data"]) do

        GameRules.myself = true


      --随机任务
      -- print(v.quest.quest.."-------------"..v.quest.quest_expire)
      if v.quest.quest ~= nil and v.quest.quest_expire == -2 then
        GameRules:GetGameModeEntity().quest[v.quest.quest] = GameRules.quest_status[v.quest.quest]
      end
      -- DeepPrintTable(GameRules:GetGameModeEntity().quest)

      GameMode:OnReceiveHeroInfo({
        heroindex = tonumber(v["hero_index"]),
        steam_id = v["steam_id"],
        hero_sea = v["hero_sea"],
        onduty_hero = v["onduty_hero"],
        is_black = v["is_black"],
      })
    end

    print("set_hero_sea......")
    t["data"]["hehe"] = RandomInt(1,10000)

    CustomNetTables:SetTableValue( "game_state", "crab", t["data"])



    Timers:CreateTimer(10,function()
      GameRules:SendCustomMessage("#text_game_start", 0, 0)
      GameRules:GetGameModeEntity().game_time = GameRules:GetGameTime()
      GameRules.game_status = 1
      start_build()
      end)

  end)

end