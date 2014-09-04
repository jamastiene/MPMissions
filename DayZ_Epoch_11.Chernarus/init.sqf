/*	
	For DayZ Epoch
	Addons Credits: Jetski Yanahui by Kol9yN, Zakat, Gerasimow9, YuraPetrov, zGuba, A.Karagod, IceBreakr, Sahbazz
*/
startLoadingScreen ["","RscDisplayLoadCustom"];
cutText ["","BLACK OUT"];
enableSaving [false, false];

//REALLY IMPORTANT VALUES
dayZ_instance =	11;					//The instance
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

//disable greeting menu 
player setVariable ["BIS_noCoreConversations", true];
//disable radio messages to be heard and shown in the left lower corner of the screen
enableRadio true;
// May prevent "how are you civillian?" messages from NPC
enableSentences false;

// DayZ Epoch config
spawnShoremode = 1; // Default = 1 (on shore)
spawnArea= 1500; // Default = 1500

MaxVehicleLimit = 300; // Default = 50
MaxDynamicDebris = 150; // Default = 100
dayz_MapArea = 14000; // Default = 10000
dayz_maxLocalZombies = 30; // Default = 30 
DZE_DeathMsgSide = true;  //Kill message
DZE_requireplot = 0;  //Pas de plot pole pour la construction
DZE_GodModeBase = true;  //Script god mod des bases
DZE_BuildingLimit = 3000; 
DZE_MissionLootTable = true; //Custom Loot Tables
DZE_SelfTransfuse = true;  //Self BB
DZE_HeliLift = false;  //LIFT
DZE_ConfigTrader = true;
DZE_PlayerZed = false;
DZE_AsReMix_PLAYER_HUD = true; //Open Custom 	AsReMix Player HUD
dayz_paraSpawn = false;
//dayZ_UseSteamID = false;
setViewDistance 2500;
setTerrainGrid 20;
 
dayz_paraSpawn = false;
/* Default Loadout */
DefaultMagazines = ["ItemBandage","ItemBandage","17Rnd_9x19_glock17","17Rnd_9x19_glock17","ItemPainkiller"];
DefaultWeapons = ["glock17_EP1","ItemFlashlight","ItemMap","ItemToolbox"];
DefaultBackpack = "DZ_Patrol_Pack_EP1";
DefaultBackpackWeapon = "";
/* End Default Loadout */
dayz_minpos = -1; 
dayz_maxpos = 16000;
dayz_sellDistance_vehicle = 20;
dayz_sellDistance_boat = 30;
dayz_sellDistance_air = 40;
dayz_maxAnimals = 5; // Default: 8
dayz_tameDogs = true;
DynamicVehicleDamageLow = 0; // Default: 0
DynamicVehicleDamageHigh = 100; // Default: 100
DZE_BuildOnRoads = false; // Default: False
DZE_ForceNameTagsInTrader  = true;
EpochEvents = [["any","any","any","any",30,"crash_spawner"],["any","any","any","any",0,"crash_spawner"],["any","any","any","any",15,"supply_drop"]];
dayz_fullMoonNights = true;
//Load in compiled functions
call compile preprocessFileLineNumbers "init\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";				//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";	//Functions used by CLIENT for medical
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "init\compiles.sqf";				//Compile regular functions
call compile preprocessFileLineNumbers "custom\compiles.sqf";                            //Compile custom compiles
progressLoadingScreen 0.5;
call compile preprocessFileLineNumbers "server_traders.sqf";				//Compile trader configs
progressLoadingScreen 1.0;

"filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4]; setToneMapping "Filmic";

if (isServer) then {
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\missions\DayZ_Epoch_17.Chernarus\dynamic_vehicle.sqf";
	//Compile vehicle configs
	
	// Add trader citys
	_nil = [] execVM "\z\addons\dayz_server\missions\DayZ_Epoch_17.Chernarus\mission.sqf";
	_serverMonitor = 	[] execVM "\z\addons\dayz_code\system\server_monitor.sqf";
};

if (!isDedicated) then {
	//Conduct map operations
	0 fadeSound 0;
	waitUntil {!isNil "dayz_loadScreenMsg"};
	dayz_loadScreenMsg = (localize "STR_AUTHENTICATING");
	
	//Run the player monitor
	_id = player addEventHandler ["Respawn", {_id = [] spawn player_death;}];
	_playerMonitor = 	[] execVM "\z\addons\dayz_code\system\player_monitor.sqf";	
	
	//anti Hack
	//[] execVM "\z\addons\dayz_code\system\antihack.sqf";

	//Lights
	//[false,12] execVM "\z\addons\dayz_code\compile\local_lights_init.sqf";
	
};

// Zupa - SC
execVM "gold\init.sqf";
execVM "gold\addbankmarkers.sqf";
execVM "custom\safezone.sqf";
// END Zupa - SC

///#include "\z\addons\dayz_code\system\REsec.sqf"

//Start Dynamic Weather
execVM "\z\addons\dayz_code\external\DynamicWeatherEffects.sqf";


#include "\z\addons\dayz_code\system\BIS_Effects\init.sqf"

if (!isDedicated) then {
if (DZE_AsReMix_PLAYER_HUD) then {
	execVM "addons\playerhud\playerHud.sqf"//AsReMix Player HUD
};
};