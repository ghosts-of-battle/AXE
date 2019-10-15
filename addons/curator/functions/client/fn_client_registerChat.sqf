/*
 *	ARMA EXTENDED ENVIRONMENT
 *	\axe_curator\functions\client\fn_client_registerChat.sqf
 *	by Ojemineh
 *	
 *	register client chat
 *	
 *	Arguments:
 *	nothing
 *	
 *	Return:
 *	nothing
 *	
 *	Example:
 *	[] call AXE_curator_fnc_client_registerChat;
 *	
 */

// -------------------------------------------------------------------------------------------------

if !(hasInterface) exitWith {};

// -------------------------------------------------------------------------------------------------
// CHAT: ZEUS

[
	"zeus", 
	{
		
		[
			{
				
				if (
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 1) && ([] call AXE_fnc_isAdmin)) &&
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 2) && ([] call AXE_fnc_isAdmin || [] call AXE_fnc_isCurator))
				) exitWith {
					systemChat format [localize "STR_AXE_Curator_Chat_Access_Denied"];
				};
				
				if ((count allCurators) == 0) exitWith {
					systemChat format [localize "STR_AXE_Curator_Chat_Not_Available"];
				};
				
				systemChat format [localize "STR_AXE_Curator_Chat_Available"];
				
				{
					private _curatorUnit = getAssignedCuratorUnit _x;
					private _curatorName = [_curatorUnit] call ACE_common_fnc_getName;
					systemChat format [localize "STR_AXE_Curator_Chat_Listing", _curatorUnit, _curatorName];
				} forEach allCurators;
				
			}, 
			[_this select 0]
		] call CBA_fnc_execNextFrame;
		
	}, 
	"all"
] call CBA_fnc_registerChatCommand;

// -------------------------------------------------------------------------------------------------
// CHAT: ZEUS CREATE

[
	"zeus.create", 
	{
		
		[
			{
				
				private _param = _this select 0;
				
				if (
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 1) && ([] call AXE_fnc_isAdmin)) &&
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 2) && ([] call AXE_fnc_isAdmin || [] call AXE_fnc_isCurator))
				) exitWith {
					systemChat format [localize "STR_AXE_Curator_Chat_Access_Denied"];
				};
				
				if ((_param isEqualTo "") || (_param isEqualTo "self")) then {
					
					private _unit = player;
					
					if (!(isNull _unit) && (isNull getAssignedCuratorLogic _unit)) then {
						private _unitName = [_unit] call ACE_common_fnc_getName;
						systemChat format [localize "STR_AXE_Curator_Chat_Create", _unitName, _unit];
						[{
							["axe_curator_createModule", [_this select 0, _this select 1]] call CBA_fnc_serverEvent;
						}, [player, _unit]] call CBA_fnc_execNextFrame;
					} else {
						systemChat format [localize "STR_AXE_Curator_Chat_Create_Failed", _unit];
					};
					
				} else {
					
					if (_param isEqualTo "target") then {
						
						private _unit = cursorObject;
						
						if ((_unit isKindOf "Man") && (isPlayer _unit) && (isNull getAssignedCuratorLogic _unit)) then {
							private _unitName = [_unit] call ACE_common_fnc_getName;
							systemChat format [localize "STR_AXE_Curator_Chat_Create_For", _unitName, _unit];
							[{
								["axe_curator_createModule", [_this select 0, _this select 1]] call CBA_fnc_serverEvent;
							}, [player, _unit]] call CBA_fnc_execNextFrame;
						} else {
							systemChat format [localize "STR_AXE_Curator_Chat_Create_Failed", _unit];
						};
						
					} else {
						
						private _unit = call compile _param;
						
						if (isNull (missionNamespace getVariable [_param, objNull])) exitWith {
							systemChat format [localize "STR_AXE_Curator_Chat_Unknown_Target", _param];
						};
						
						if (!(isNull _unit) && (isPlayer _unit) && (isNull getAssignedCuratorLogic _unit)) then {
							private _unitName = [_unit] call ACE_common_fnc_getName;
							systemChat format [localize "STR_AXE_Curator_Chat_Create_For", _unitName, _unit];
							[{
								["axe_curator_createModule", [_this select 0, _this select 1]] call CBA_fnc_serverEvent;
							}, [player, _unit]] call CBA_fnc_execNextFrame;
						} else {
							systemChat format [localize "STR_AXE_Curator_Chat_Create_Failed", _unit];
						};
						
					};
					
				};
				
			}, 
			[_this select 0]
		] call CBA_fnc_execNextFrame;
		
	}, 
	"all"
] call CBA_fnc_registerChatCommand;

// -------------------------------------------------------------------------------------------------
// CHAT: ZEUS REMOVE

[
	"zeus.remove", 
	{
		
		[
			{
				
				private _param = _this select 0;
				
				if (
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 1) && ([] call AXE_fnc_isAdmin)) &&
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 2) && ([] call AXE_fnc_isAdmin || [] call AXE_fnc_isCurator))
				) exitWith {
					systemChat format [localize "STR_AXE_Curator_Chat_Access_Denied"];
				};
				
				if ((_param isEqualTo "") || (_param isEqualTo "self")) then {
					
					private _unit = player;
					
					if (!(isNull _unit) && !(isNull getAssignedCuratorLogic _unit)) then {
						private _unitName = [_unit] call ACE_common_fnc_getName;
						systemChat format [localize "STR_AXE_Curator_Chat_Remove", _unitName, _unit];
						[{
							["axe_curator_removeModule", [_this select 0, _this select 1]] call CBA_fnc_serverEvent;
						}, [player, _unit]] call CBA_fnc_execNextFrame;
					} else {
						systemChat format [localize "STR_AXE_Curator_Chat_Remove_Failed", _unit];
					};
					
				} else {
					
					if (_param isEqualTo "target") then {
						
						private _unit = cursorObject;
						
						if ((_unit isKindOf "Man") && (isPlayer _unit) && !(isNull getAssignedCuratorLogic _unit)) then {
							private _unitName = [_unit] call ACE_common_fnc_getName;
							systemChat format [localize "STR_AXE_Curator_Chat_Remove_For", _unitName, _unit];
							[{
								["axe_curator_removeModule", [_this select 0, _this select 1]] call CBA_fnc_serverEvent;
							}, [player, _unit]] call CBA_fnc_execNextFrame;
						} else {
							systemChat format [localize "STR_AXE_Curator_Chat_Remove_Failed", _unit];
						};
						
					} else {
						
						private _unit = call compile _param;
						
						if (isNull (missionNamespace getVariable [_param, objNull])) exitWith {
							systemChat format [localize "STR_AXE_Curator_Chat_Unknown_Target", _param];
						};
						
						if (!(isNull _unit) && (isPlayer _unit) && !(isNull getAssignedCuratorLogic _unit)) then {
							private _unitName = [_unit] call ACE_common_fnc_getName;
							systemChat format [localize "STR_AXE_Curator_Chat_Remove_For", _unitName, _unit];
							[{
								["axe_curator_removeModule", [_this select 0, _this select 1]] call CBA_fnc_serverEvent;
							}, [player, _unit]] call CBA_fnc_execNextFrame;
						} else {
							systemChat format [localize "STR_AXE_Curator_Chat_Remove_Failed", _unit];
						};
						
					};
					
				};
				
			}, 
			[_this select 0]
		] call CBA_fnc_execNextFrame;
		
	}, 
	"all"
] call CBA_fnc_registerChatCommand;

// -------------------------------------------------------------------------------------------------
// CHAT: PLAYER HEAL

[
	"heal", 
	{
		
		[
			{
				
				private _param = _this select 0;
				
				if (
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 1) && ([] call AXE_fnc_isAdmin)) &&
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 2) && ([] call AXE_fnc_isAdmin || [] call AXE_fnc_isCurator))
				) exitWith {
					systemChat format [localize "STR_AXE_Curator_Chat_Access_Denied"];
				};
				
				if ((_param isEqualTo "") || (_param isEqualTo "self")) then {
					
					private _unit = player;
					
					if (!(isNull _unit)) then {
						private _unitName = [_unit] call ACE_common_fnc_getName;
						systemChat format [localize "STR_AXE_Curator_Chat_Healing", _unitName, _unit];
						["axe_curator_playerHeal", [player, _unit], [_unit]] call CBA_fnc_targetEvent;
					} else {
						systemChat format [localize "STR_AXE_Curator_Chat_Healing_Failed", _unit];
					};
					
				} else {
					
					if (_param isEqualTo "target") then {
						
						private _unit = cursorObject;
						
						if ((_unit isKindOf "Man") && (isPlayer _unit)) then {
							private _unitName = [_unit] call ACE_common_fnc_getName;
							systemChat format [localize "STR_AXE_Curator_Chat_Healing_For", _unitName, _unit];
							["axe_curator_playerHeal", [player, _unit], [_unit]] call CBA_fnc_targetEvent;
						} else {
							systemChat format [localize "STR_AXE_Curator_Chat_Healing_Failed", _unit];
						};
						
					} else {
						
						private _unit = call compile _param;
						
						if (isNull (missionNamespace getVariable [_param, objNull])) exitWith {
							systemChat format [localize "STR_AXE_Curator_Chat_Unknown_Target", _param];
						};
						
						if (!(isNull _unit) && (isPlayer _unit)) then {
							private _unitName = [_unit] call ACE_common_fnc_getName;
							systemChat format [localize "STR_AXE_Curator_Chat_Healing_For", _unitName, _unit];
							["axe_curator_playerHeal", [player, _unit], [_unit]] call CBA_fnc_targetEvent;
						} else {
							systemChat format [localize "STR_AXE_Curator_Chat_Healing_Failed", _unit];
						};
						
					};
					
				};
				
			}, 
			[_this select 0]
		] call CBA_fnc_execNextFrame;
		
	}, 
	"all"
] call CBA_fnc_registerChatCommand;

// -------------------------------------------------------------------------------------------------
// CHAT: END MISSION

[
	"endmission", 
	{
		
		[
			{
				
				private _param = _this select 0;
				
				if (
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 1) && ([] call AXE_fnc_isAdmin)) &&
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 2) && ([] call AXE_fnc_isAdmin || [] call AXE_fnc_isCurator))
				) exitWith {
					systemChat format [localize "STR_AXE_Curator_Chat_Access_Denied"];
				};
				
				if (_param == "") then {
					["axe_curator_endMission", [player, "AXE_MISSION_DONE", true]] call CBA_fnc_globalEvent;
				} else {
					["axe_curator_endMission", [player, _param, true]] call CBA_fnc_globalEvent;
				};
				
			}, 
			[_this select 0]
		] call CBA_fnc_execNextFrame;
		
	}, 
	"all"
] call CBA_fnc_registerChatCommand;

// -------------------------------------------------------------------------------------------------
// CHAT: FAIL MISSION

[
	"failmission", 
	{
		
		[
			{
				
				private _param = _this select 0;
				
				if (
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 1) && ([] call AXE_fnc_isAdmin)) &&
					!((missionNamespace getVariable ["axe_curator_chat_enableFor", 0] == 2) && ([] call AXE_fnc_isAdmin || [] call AXE_fnc_isCurator))
				) exitWith {
					systemChat format [localize "STR_AXE_Curator_Chat_Access_Denied"];
				};
				
				if (_param == "") then {
					["axe_curator_endMission", [player, "AXE_MISSION_FAIL", false]] call CBA_fnc_globalEvent;
				} else {
					["axe_curator_endMission", [player, _param, false]] call CBA_fnc_globalEvent;
				};
				
			}, 
			[_this select 0]
		] call CBA_fnc_execNextFrame;
		
	}, 
	"all"
] call CBA_fnc_registerChatCommand;

// -------------------------------------------------------------------------------------------------