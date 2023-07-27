#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <zcmd>
main(){}


#define MAX_PLAYER_OBJECTS 500  //Укажите здесь максимальное количество объектов, которое могут добавить на сервер игроки.
								//Помните - от этого зависит производительность скрипта и сервера в целом.
#define COLOR_GREY 0xAFAFAFAA

#define DIALOG_OBJECT_PANEL 10001
#define DIALOG_ADD_OBJECT 10002
#define DIALOG_EDIT_OBJECT 10003
#define DIALOG_OBJECT_LIST 10004
#define DIALOG_OBJECT_LIST_MENU 10005
#define DIALOG_DELETE_OBJECT_BY_ID 10006
#define DIALOG_DELETE_PLAYER_OBJECT 10007

enum PlayerObjectState
{
    OBJECT_STATE_EMPTY,
    OBJECT_STATE_OCCUPIED
};

new g_PlayerObjectsPlayerID[MAX_PLAYER_OBJECTS];
new g_PlayerObjects[MAX_PLAYER_OBJECTS];
new PlayerObjectState:g_ObjectStates[MAX_PLAYER_OBJECTS];

public OnGameModeInit()
{
	ObjectSystemLoad();
	// Don't use these lines if it's a filterscript
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	DeletePVar(playerid, "PlayerEditMode");
	DeletePVar(playerid, "ObjectID");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid){
		case DIALOG_OBJECT_PANEL:{
		    if(response){
			    switch(listitem){
			        case 0:{//Добавление объекта
			            ShowPlayerDialog(playerid, DIALOG_ADD_OBJECT, DIALOG_STYLE_INPUT, "ID объекта", "Введите ID объекта, который Вы желаете создать", "Далее", "<<");
			        }
			        case 1:{//Редактирование объекта
			            ShowPlayerDialog(playerid, DIALOG_EDIT_OBJECT, DIALOG_STYLE_INPUT, "ID объекта", "Введите ID объекта, который Вы желаете редактировать (порядковый)", "Далее", "<<");
			        }
			        case 2:{//Список объектов игрока
			            new dialog[500], dialog_obmen[50], res;
			            for (new i = 0; i < MAX_PLAYER_OBJECTS; i++){
					        if (g_ObjectStates[i] != OBJECT_STATE_EMPTY && g_PlayerObjectsPlayerID[i] == playerid){
					        	res++;
							    format(dialog_obmen, sizeof(dialog_obmen), "[%d] Объект {FF0000}%d{FFFFFF}\n\
								", res, i);
							    strcat(dialog, dialog_obmen);
					        }
					    }
						if(res == 0) return SendClientMessage(playerid, -1, "Ошибка: У Вас нет созданных объектов!");
						ShowPlayerDialog(playerid, DIALOG_OBJECT_LIST, DIALOG_STYLE_LIST, "Список объектов", dialog, "Далее", "<<");
			        }
			        case 3:{//Удалить объект по его порядковому ID
			            ShowPlayerDialog(playerid, DIALOG_DELETE_OBJECT_BY_ID, DIALOG_STYLE_INPUT, "ID объекта", "Введите ID объекта, который Вы желаете удалить (порядковый)", "Далее", "<<");
			        }
			        case 4:{//Удалить объект по ID другого игрока
			            ShowPlayerDialog(playerid, DIALOG_DELETE_PLAYER_OBJECT, DIALOG_STYLE_INPUT, "ID игрока", "Введите ID игрока, объекты которого Вы желаете удалить", "Далее", "<<");
			        }
			        case 5:{//Удалить все объекты игрока
			            cmd_dmyobjects(playerid, "");
			        }
			        case 6:{//Удалить все объекты
			            cmd_dallobjects(playerid, "");
			        }
			    }
			}
		}
		case DIALOG_DELETE_OBJECT_BY_ID:{//Удаляем объект по его порядковому ID
            if(response){
                //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
                if(g_PlayerObjects[strval(inputtext)] == -1) return SendClientMessage(playerid, -1, "Ошибка: объекта не существует!");
				if(g_PlayerObjectsPlayerID[strval(inputtext)] != playerid /*&& PlayerInfo[playerid][pAdminLVL] < 5*/) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете удалять объекты других игроков!");
				new string[100];
				format(string, sizeof(string), "Был удален объект ID: %d", strval(inputtext));
				DestroyDynamicObject(g_PlayerObjects[strval(inputtext)]);
			    g_PlayerObjectsPlayerID[strval(inputtext)] = -1;
			    g_PlayerObjects[strval(inputtext)] = -1;
			    g_ObjectStates[strval(inputtext)] = OBJECT_STATE_EMPTY;
			    SendClientMessage(playerid, -1, string);
			}
		}
		case DIALOG_DELETE_PLAYER_OBJECT:{//Удаляем все объекты конкретного игрока
			if(response){
			    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
				//if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
				for (new i = 0; i < MAX_PLAYER_OBJECTS; i++)
			    {
			        if (g_PlayerObjectsPlayerID[i] == strval(inputtext))
			        {
			            DestroyDynamicObject(g_PlayerObjects[i]);
			            g_PlayerObjectsPlayerID[i] = -1;
			            g_PlayerObjects[i] = -1;
			            g_ObjectStates[i] = OBJECT_STATE_EMPTY;
			        }
		    	}
		    	SendClientMessage(playerid, -1, "Все созданные игроком объекты удалены!");
			}
		}
		case DIALOG_OBJECT_LIST:{//Выводим список объектов игрока
		    if(response){
			    new result;
			    for (new i = 0; i < MAX_PLAYER_OBJECTS; i++){
			        if (g_ObjectStates[i] != OBJECT_STATE_EMPTY && g_PlayerObjectsPlayerID[i] == playerid){
						if(result == listitem){
						    SetPVarInt(playerid, "ObjectID", i);
						    ShowPlayerDialog(playerid, DIALOG_OBJECT_LIST_MENU, DIALOG_STYLE_LIST, "Управление объектами", "[1] Редактирование объекта\n[2] Удаление объекта", "Далее", "<<");
						    break;
						}
						result++;
			        }
			    }
			}
			else{
			    ShowPlayerDialog(playerid, DIALOG_OBJECT_PANEL, DIALOG_STYLE_LIST, "Управление объектами", "[1] Добавление объекта\n[2] Редактирование объекта\n[3] Список моих объектов\n[4] Удалить объект по его порядковому ID\n[5] Удалить объект другого игрока\n[6] Удалить все мои объекты\n[7] Удалить все объекты на сервере", "ОК", "Х");
			}
		}
		case DIALOG_OBJECT_LIST_MENU:{//Меню действий с объектами
		    if(response){
		        switch(listitem){
		            case 0:{//Редактирование объекта
		                //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
						//if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
						new obj = GetPVarInt(playerid, "ObjectID");
						if(g_PlayerObjects[obj] == -1) return SendClientMessage(playerid, -1, "Ошибка: данный объект не существует");
						if(g_PlayerObjectsPlayerID[obj] != playerid /*&& PlayerInfo[playerid][pAdminLVL] < 5*/) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете редактировать объекты других игроков!");
					    if(GetPVarInt(playerid, "PlayerEditMode") == 1) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете создать новый объект, т.к. находитесь в режиме редактирования объектов!");
						new string[100];
						EditDynamicObject(playerid, g_PlayerObjects[obj]);
						format(string, sizeof(string), "Началось редактирование объекта под ID: %d", obj);
						SendClientMessage(playerid, -1, string);
		            }
		            case 1:{//Удаление объекта
		                //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
						//if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
                        new obj = GetPVarInt(playerid, "ObjectID");
						new string[100];
						format(string, sizeof(string), "Был удален объект ID: %d", obj);
						DestroyDynamicObject(g_PlayerObjects[obj]);
					    g_PlayerObjectsPlayerID[obj] = -1;
					    g_PlayerObjects[obj] = -1;
					    g_ObjectStates[obj] = OBJECT_STATE_EMPTY;
					    SendClientMessage(playerid, -1, string);
					}
		        }
		    }
		    else{
		        ShowPlayerDialog(playerid, DIALOG_OBJECT_PANEL, DIALOG_STYLE_LIST, "Управление объектами", "[1] Добавление объекта\n[2] Редактирование объекта\n[3] Список моих объектов\n[4] Удалить объект по его порядковому ID\n[5] Удалить объект другого игрока\n[6] Удалить все мои объекты\n[7] Удалить все объекты на сервере", "ОК", "Х");
		    }
		}
		case DIALOG_ADD_OBJECT:{//Добавляем объект
		    if(response){
		        //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
  				//if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
			    if(strval(inputtext) <= 0) return ShowPlayerDialog(playerid, DIALOG_ADD_OBJECT, DIALOG_STYLE_INPUT, "ID объекта", "Введите ID объекта, который Вы желаете создать", "Далее", "<<");
				if(GetPVarInt(playerid, "PlayerEditMode") == 1) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете создать новый объект, т.к. находитесь в режиме редактирования объектов!");
				new Float:X, Float:Y, Float:Z, obj, string[100], result;
				GetPlayerPos(playerid, X, Y, Z);
				GetXYInFrontOfPlayer(playerid, X, Y, 5.0);
				obj = CreateDynamicObject(strval(inputtext), X, Y, Z+1, 0.0,0.0,0.0);
				EditDynamicObject(playerid, obj);
			    for (new i = 0; i < MAX_PLAYER_OBJECTS; i++)
			    {
			        if (g_ObjectStates[i] == OBJECT_STATE_EMPTY)
			        {
			            g_PlayerObjectsPlayerID[i] = playerid;
			            g_PlayerObjects[i] = obj;
			            g_ObjectStates[i] = OBJECT_STATE_OCCUPIED;
			            result = i;
			            break;
			        }
			    }
			    SetPVarInt(playerid, "PlayerEditMode", 1);
			    format(string, sizeof(string), "Создан объект ID: %d. ID по счету: %d (/dobject %d - удалить объект)", strval(inputtext), result, result);
			    SendClientMessage(playerid, -1, string);
			}
			else{
			    ShowPlayerDialog(playerid, DIALOG_OBJECT_PANEL, DIALOG_STYLE_LIST, "Управление объектами", "[1] Добавление объекта\n[2] Редактирование объекта\n[3] Список моих объектов\n[4] Удалить объект по его порядковому ID\n[5] Удалить объект другого игрока\n[6] Удалить все мои объекты\n[7] Удалить все объекты на сервере", "ОК", "Х");
			}
		}
		case DIALOG_EDIT_OBJECT:{//Редактируем объект
		    if(response){
			    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
				//if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
				if(g_PlayerObjects[strval(inputtext)] == -1) return SendClientMessage(playerid, -1, "Ошибка: данный объект не существует");
                if(strval(inputtext) < 0) return ShowPlayerDialog(playerid, DIALOG_EDIT_OBJECT, DIALOG_STYLE_INPUT, "ID объекта", "Введите ID объекта, который Вы желаете редактировать (порядковый)", "Далее", "<<");
				if(g_PlayerObjectsPlayerID[strval(inputtext)] != playerid /*&& PlayerInfo[playerid][pAdminLVL] < 5*/) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете редактировать объекты других игроков!");
			    if(GetPVarInt(playerid, "PlayerEditMode") == 1) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете создать новый объект, т.к. находитесь в режиме редактирования объектов!");
				new string[100];
				EditDynamicObject(playerid, g_PlayerObjects[strval(inputtext)]);
				format(string, sizeof(string), "Началось редактирование объекта под ID: %d", strval(inputtext));
				SendClientMessage(playerid, -1, string);
			}
			else{
			    ShowPlayerDialog(playerid, DIALOG_OBJECT_PANEL, DIALOG_STYLE_LIST, "Управление объектами", "[1] Добавление объекта\n[2] Редактирование объекта\n[3] Список моих объектов\n[4] Удалить объект по его порядковому ID\n[5] Удалить объект другого игрока\n[6] Удалить все мои объекты\n[7] Удалить все объекты на сервере", "ОК", "Х");
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
stock ObjectSystemLoad(){
    for(new i; i < MAX_PLAYER_OBJECTS; i++){ // Загружаем систему
	    g_PlayerObjectsPlayerID[i] = -1;
		g_PlayerObjects[i] = -1;
		g_ObjectStates[i] = OBJECT_STATE_EMPTY;
	}
	return true;
}
stock GetXYInFrontOfPlayer(playerid, &Float:q, &Float:w, Float:distance)// Узнаем угол игрока чтобы создать объект перед ним
{
    new Float:a;
    GetPlayerPos(playerid, q, w, a);
    GetPlayerFacingAngle(playerid, a);
    q += (distance * floatsin(-a, degrees));
    w += (distance * floatcos(-a, degrees));
}
stock ClearObjects(){ // Очищаем массив и сервер в целом от созданных объектов
    for(new i; i < MAX_PLAYER_OBJECTS; i++){
        DestroyDynamicObject(g_PlayerObjects[i]);
	    g_PlayerObjectsPlayerID[i] = -1;
		g_PlayerObjects[i] = -1;
		g_ObjectStates[i] = OBJECT_STATE_EMPTY;
	}
	return true;
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    DeletePVar(playerid, "PlayerEditMode");//Удаляем PVar, т.к. игрок завершил редактирование
}
CMD:objpanel(playerid, params[]){
    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
    //if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
    ShowPlayerDialog(playerid, DIALOG_OBJECT_PANEL, DIALOG_STYLE_LIST, "Управление объектами", "[1] Добавление объекта\n[2] Редактирование объекта\n[3] Список моих объектов\n[4] Удалить объект по его порядковому ID\n[5] Удалить объект другого игрока\n[6] Удалить все мои объекты\n[7] Удалить все объекты на сервере", "ОК", "Х");
	return true;
}
CMD:cobject(playerid, params[]){
    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
    //if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
	if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_GREY, "{336600}|{FFFFFF} Используйте /cobject [ID объекта]");
	if(GetPVarInt(playerid, "PlayerEditMode") == 1) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете создать новый объект, т.к. находитесь в режиме редактирования объектов!");
    if(params[0] <= 0) return SendClientMessage(playerid, -1, "ID объекта не может быть меньше 0!");
	new Float:X, Float:Y, Float:Z, obj, string[100], result;
	GetPlayerPos(playerid, X, Y, Z);
	GetXYInFrontOfPlayer(playerid, X, Y, 5.0);
	obj = CreateDynamicObject(params[0], X, Y, Z+1, 0.0,0.0,0.0);
	EditDynamicObject(playerid, obj);
    for (new i = 0; i < MAX_PLAYER_OBJECTS; i++)
    {
        if (g_ObjectStates[i] == OBJECT_STATE_EMPTY)
        {
            g_PlayerObjectsPlayerID[i] = playerid;
            g_PlayerObjects[i] = obj;
            g_ObjectStates[i] = OBJECT_STATE_OCCUPIED;
            result = i;
            break;
        }
    }
    SetPVarInt(playerid, "PlayerEditMode", 1);
    format(string, sizeof(string), "Создан объект ID: %d. ID по счету: %d (/dobject %d - удалить объект)", params[0], result, result);
    SendClientMessage(playerid, -1, string);
	return true;
}
CMD:editobject(playerid, params[]){
    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
    //if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
    if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_GREY, "{336600}|{FFFFFF} Используйте /editobject [id объекта]");
	if(g_PlayerObjects[params[0]] == -1) return SendClientMessage(playerid, -1, "Ошибка: данный объект не существует");
	if(g_PlayerObjectsPlayerID[params[0]] != playerid /*&& PlayerInfo[playerid][pAdminLVL] < 5*/) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете редактировать объекты других игроков!");
    if(GetPVarInt(playerid, "PlayerEditMode") == 1) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете создать новый объект, т.к. находитесь в режиме редактирования объектов!");
	new string[100];
	EditDynamicObject(playerid, g_PlayerObjects[params[0]]);
	format(string, sizeof(string), "Началось редактирование объекта под ID: %d", params[0]);
	SendClientMessage(playerid, -1, string);
	return true;
}
CMD:dobject(playerid, params[]){
    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
    //if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
    if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_GREY, "{336600}|{FFFFFF} Используйте /dobject [id объекта]");
	if(g_PlayerObjects[params[0]] == -1) return SendClientMessage(playerid, -1, "Ошибка: объекта не существует!");
	if(g_PlayerObjectsPlayerID[params[0]] != playerid /*&& PlayerInfo[playerid][pAdminLVL] < 5*/) return SendClientMessage(playerid, -1, "Ошибка: Вы не можете удалять объекты других игроков!");
	new string[100];
	format(string, sizeof(string), "Был удален объект ID: %d", params[0]);
	DestroyDynamicObject(g_PlayerObjects[params[0]]);
    g_PlayerObjectsPlayerID[params[0]] = -1;
    g_PlayerObjects[params[0]] = -1;
    g_ObjectStates[params[0]] = OBJECT_STATE_EMPTY;
    SendClientMessage(playerid, -1, string);
	return true;
}
CMD:dmyobjects(playerid, params[]){//Команда удаления всех объектов разом для того, кто их создал
    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
    //if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
	new result;
	for (new i = 0; i < MAX_PLAYER_OBJECTS; i++)
    {
        if(g_PlayerObjectsPlayerID[i] == playerid)
        {
            DestroyDynamicObject(g_PlayerObjects[i]);
            g_PlayerObjectsPlayerID[i] = -1;
            g_PlayerObjects[i] = -1;
            g_ObjectStates[i] = OBJECT_STATE_EMPTY;
            result++;
        }
    }
    if(result > 0){
        SendClientMessage(playerid, -1, "Все созданные Вами объекты удалены!");
    }
    else{
		SendClientMessage(playerid, -1, "Ошибка: у Вас нет созданных объектов!");
	}
	return true;
}
CMD:dallobjects(playerid, params[]){//Удаляем ВСЕ созданные объекты с сервера
    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
    //if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
    ClearObjects();
    SendClientMessage(playerid, -1, "Все созданные игроками объекты удалены!");
	return true;
}
CMD:duserobject(playerid, params[]){//Удаляем объекты конкретного пользователя (админа), важно - вы должны знать ID пользователя, под которым он
									//создавал объекты, иначе используйте команду dallobject
    //if(PlayerInfo[playerid][pLogged] == 0) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Необходимо авторизоваться!");
    //if(PlayerInfo[playerid][pAdminLVL] > 1) return SendClientMessage(playerid, -1, "{FF0000}|{FFFFFF} Вы не уполномочены использовать данную команду!");
    if(sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_GREY, "{336600}|{FFFFFF} Используйте /duserobject [playerid]");
	for (new i = 0; i < MAX_PLAYER_OBJECTS; i++)
    {
        if (g_PlayerObjectsPlayerID[i] == params[0])
        {
            DestroyDynamicObject(g_PlayerObjects[i]);
            g_PlayerObjectsPlayerID[i] = -1;
            g_PlayerObjects[i] = -1;
            g_ObjectStates[i] = OBJECT_STATE_EMPTY;
        }
    }
    SendClientMessage(playerid, -1, "Все созданные игроком объекты удалены!");
	return true;
}

