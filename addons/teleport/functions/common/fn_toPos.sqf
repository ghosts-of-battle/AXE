/*
 *	ARMA EXTENDED ENVIRONMENT
 *	\axe_teleport\functions\common\fn_toPos.sqf
 *	by Ojemineh
 *	
 *	teleport unit to a position
 *	
 *	Arguments:
 *	0: unit			- <OBJECT>
 *	1: position		- <ARRAY>
 *	2: direction	- <NUMBER>
 *	3: message		- <STRING>	(optional)
 *	4: blackout		- <BOOLEAN>
 *	
 *	Return:
 *	nothing
 *	
 *	Example:
 *	[player, (getPos target), (getDir target)] call AXE_teleport_fnc_toPos;
 *	
 */

// -------------------------------------------------------------------------------------------------

private ["_unit", "_position", "_direction", "_message", "_blackout"];

_unit		= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_position	= [_this, 1, [], [[]]] call BIS_fnc_param;
_direction	= [_this, 2, -1, [0]] call BIS_fnc_param;
_message	= [_this, 3, "", [""]] call BIS_fnc_param;
_blackout	= [_this, 4, true, [true]] call BIS_fnc_param;

// -------------------------------------------------------------------------------------------------

if (isNull _unit) exitWith {};
if (_position isEqualTo []) then { _position = [0,0,0]; };
if (_direction isEqualTo -1) then { _direction = getDir _unit; };

// -------------------------------------------------------------------------------------------------

if (Not local _unit) exitWith {
	[_unit, _position, _direction, _message, _blackout] remoteExecCall ["AXE_teleport_fnc_toPos", _unit];
};

// -------------------------------------------------------------------------------------------------

[_unit, _position, _direction, _message, _blackout] spawn {
	
	params ["_unit", "_position", "_direction", "_message", "_blackout"];
	
	if (_unit getVariable ["AXE_Teleport_InProgress", false]) exitWith {
		private _hintInProgress = format [hint_tpl_liner_1, localize "STR_AXE_Teleport_Hint_InProgress"];
		[_hintInProgress, 2] call AXE_fnc_hint;
	};
	
	if (missionNamespace getVariable ["axe_teleport_safeMode", true]) then {
		[_unit, "blockDamage", "axe_teleport_toPos", true] call ACE_common_fnc_statusEffect_set;
	};
	
	if (visibleMap) then {openMap false;};
	closeDialog 0;
	disableUserInput true;
	
	_unit setVariable ["AXE_Teleport_InProgress", true, true];
	
	if (_blackout) then {
		999 cutText [_message, "BLACK OUT", 0.5];
	} else {
		999 cutText [_message, "BLACK FADED", 10];
	};
	
	uiSleep 2;
	
	_unit hideObjectGlobal true;
	
	waitUntil {if (preloadCamera (_position)) exitWith {true}; false};
	
	private _success = false;
	
	if (vehicle _unit != _unit) then {
		unassignVehicle _unit;
		moveOut _unit;
	};
	
	private _pos = _position findEmptyPosition [0, 30, (typeOf _unit)];
	if (!(_pos isEqualTo [])) then {
		_unit setDir _direction;
		_unit setPos _pos;
		_success = true;
	};
	
	uiSleep 0.5;
	
	999 cutText [_message, "BLACK IN", 1.0];
	
	_unit hideObjectGlobal false;
	
	disableUserInput false;
	
	[_unit, _success] spawn {
		
		params ["_unit", "_success"];
		
		if (missionNamespace getVariable ["axe_teleport_safeMode", true]) then {
			
			private _time = round (missionNamespace getVariable ["axe_teleport_safeTime", 5]);
			
			if (missionNamespace getVariable ["axe_teleport_safeInfo", true]) then {
				
				private _info = format [localize "STR_AXE_Teleport_Hint_SafeMode_Message", _time];
				
				[
					format [
						"<t color='#ff0000' size='1.2'>%1</t><br/><t color='#ff0000' size='0.7'>%2</t>", 
						toUpper (localize "STR_AXE_Teleport_Hint_SafeMode_Title"), 
						_info
					],
					-1, 
					-1, 
					_time, 
					0
				] spawn BIS_fnc_dynamicText;
				
			};
			
			uiSleep _time;
			
			[_unit, "blockDamage", "axe_teleport_toPos", false] call ACE_common_fnc_statusEffect_set;
			
		};
		
		_unit setVariable ["AXE_Teleport_InProgress", nil, true];
		
	};
	
	uiSleep 1;
	
	if (missionNamespace getVariable ["axe_teleport_hint", true]) then {
		if (_success) then {
			private _hintToPos = format [hint_tpl_liner_1, localize "STR_AXE_Teleport_Hint_toPos"];
			[_hintToPos, 0] call AXE_fnc_hint;
		} else {
			private _hintToPos = format [hint_tpl_liner_1, localize "STR_AXE_Teleport_Hint_Failure"];
			[_hintToPos, 2] call AXE_fnc_hint;
		};
	};
	
};
