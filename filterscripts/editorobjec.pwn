/*Автор: Starvas спецально для pawn-wiki.ru*/
#include <a_samp>
#include <streamer>
#include <mxINI>

forward Formatin();
#define DIALOG_SOE			1050
#define DIALOG_CREATE		DIALOG_SOE + 1
#define DIALOG_SELECT   	DIALOG_SOE + 2
#define DIALOG_TUTORIAL 	DIALOG_SOE + 3
#define DIALOG_SAVE_1		DIALOG_SOE + 4
#define DIALOG_SAVE_2       DIALOG_SOE + 5
#define delim_flt(%0,%1) index = token_by_delim(line,var_from_line,%1,index+1); if(index == (-1)) continue; %0 = floatstr(var_from_line)
#define delim_int(%0,%1) index = token_by_delim(line,var_from_line,%1,index+1); if(index == (-1)) continue; %0 = strval(var_from_line)
#define delim_str(%0,%1) index = token_by_delim(line,var_from_line,%1,index+1); if(index == (-1)) continue; %0 = var_from_line

enum SavedEnums {
	Float:foX,
	Float:foY,
	Float:foZ,
	Float:roX,
	Float:roY,
	Float:roZ
};
new obj;
new O[SavedEnums];
new pc;

public OnFilterScriptInit()
{
    print("\n--------------------------------------");
	print(" EditorObject v 1.2 успешно загружен ");
	print(" Автор: Starvas спецально для Pawn-wiki.ru ");
	print("--------------------------------------\n");
	PCLoad();
	Cplayer();
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp("/editorobjec", cmdtext, true, 10) == 0)
	{
        if(!IsPlayerAdmin(playerid)) return 1;
		new text[64];
		new string[450];
		new File=ini_openFile("Configirator.ini");
	    ini_getInteger(File,"State",pc);
	    ini_closeFile(File);
		if(pc==0){text="Включить загрузку объектов";}else{text="Выключить загрузку объектов";}
		format(string,sizeof(string),"{00ff00}Инструкция\nСоздать объект\n%s",text);
	    ShowPlayerDialog(playerid, DIALOG_SOE, DIALOG_STYLE_LIST, "Редактор объектов ", string ,"Выбрать","Отмена");
		return 1;
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_SOE:
	    {
	        if(response)
	        {
	            if(listitem == 0) ShowPlayerDialog(playerid, DIALOG_TUTORIAL, DIALOG_STYLE_MSGBOX, \
				"Инструкция","{FFFFFF}Горячие клавиши:\n\n{008080}Escape {FFFFFF}- чтобы выйти из редактора,\nили выбора объекта\n{008080}Shift {FFFFFF}- чтобы вращать камеру\nво время редактирования",\
				"Готово","Назад");
	            if(listitem == 1) ShowPlayerDialog(playerid, DIALOG_CREATE, DIALOG_STYLE_INPUT, \
				"Создание объекта","Введите ID модели объекта для того чтобы его создать\nОбъект появится перед вами, далее вы будете изменять его\n\nМаксимальный ID объекта - 19469",\
				"Создать","Назад");
				if(listitem == 2)
				{
				    if(pc==0){SendClientMessage(playerid,-1,"Вы включили загрузку объектов"),pc=1,PCSave();}
			        else{SendClientMessage(playerid,-1,"Вы отключили загрузку объектов"),pc=0,PCSave();}
				}
	        }
	    }
	    case DIALOG_CREATE:
	    {
			if(!response) return OnPlayerCommandText(playerid, "/editorobjec");
			if(!strval(inputtext)) return ShowPlayerDialog(playerid, DIALOG_CREATE, DIALOG_STYLE_INPUT, \
			"Создание объекта","Введите ID модели объекта для того чтобы его создать\nОбъект появится перед вами, далее вы будете изменять его\n\nМаксимальный ID объекта - 19469\n{FF0000}Ошибка: Недопустимое значение!",\
			"Создать","Назад");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			obj = CreateObject(strval(inputtext), X+1, Y+1, Z+1, 0.0,0.0,0.0);
			EditObject(playerid, obj);
			SetPVarInt(playerid, "ModelID", strval(inputtext));
		}
	    case DIALOG_SELECT:
	    {
            new objectid = GetPVarInt(playerid, "SelectedObject");
			if(response) EditObject(playerid, objectid);
			else DestroyObject(objectid) && CancelEdit(playerid);
	    }
	    case DIALOG_TUTORIAL: if(!response) return OnPlayerCommandText(playerid, "/editorobjec");
	    case DIALOG_SAVE_1:
	    {
	        if(response)
	        {
	            new string1[255], string2[128], File: objs;
	            format(string2, sizeof(string2), "ObjectsLoad.ini", inputtext);
	            objs = fopen(string2, io_append);
	            format(string1, sizeof(string1), "CreateDynamicObject(%d, %f,%f,%f, %f,%f,%f);\r\n", \
				GetPVarInt(playerid, "ModelID"), O[foX],O[foY],O[foZ], O[roX],O[roY],O[roZ]);
	            fwrite(objs, string1);
	            fclose(objs);
				SetTimer("Formatin", 2000, 0);
	        }
	    }
	}
	return 1;
}

public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
	ShowPlayerDialog(playerid, DIALOG_SELECT, DIALOG_STYLE_MSGBOX,"Действие с объектом", \
	"Выберите действие с объектом\nВы можете его отредактировать или удалить","Изменить","Удалить");
	SetPVarInt(playerid, "SelectedObject", objectid);
	SetPVarInt(playerid, "ModelID", modelid);
    return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	if(response == 1)
	{
		ShowPlayerDialog(playerid, DIALOG_SAVE_1, DIALOG_STYLE_MSGBOX, "Объект изменён",\
		"Желаете ли вы сохранить объект в файл?\n\nФайл с объектами находится в {FFFFFF}scriptfiles/ObjectsLoad.ini",\
		"Сохранить...","Отмена");
		O[foX] = fX;
		O[foY] = fY;
		O[foZ] = fZ;
		O[roX] = fRotX;
		O[roY] = fRotY;
		O[roZ] = fRotZ;
	}
	if(!IsValidObject(objectid)) return 0;
	MoveObject(objectid, fX, fY, fZ, 10.0, fRotX, fRotY, fRotZ);
	new Float:oldX, Float:oldY, Float:oldZ,
	Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	GetObjectPos(objectid, oldX, oldY, oldZ);
	GetObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
	if(!playerobject)
	{
    	if(!IsValidObject(objectid)) return 0;
    	MoveObject(objectid, fX, fY, fZ, 10.0, fRotX, fRotY, fRotZ);
	}
	if(response == EDIT_RESPONSE_FINAL)
	{
    	SetObjectPos(objectid, fX, fY, fZ);
    	SetObjectRot(objectid, fRotX, fRotY, fRotZ);
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
		if(!playerobject)
		{
	    	SetObjectPos(objectid, oldX, oldY, oldZ);
	    	SetObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
		}
		else
		{
	    	SetPlayerObjectPos(playerid, objectid, oldX, oldY, oldZ);
	    	SetPlayerObjectRot(playerid, objectid, oldRotX, oldRotY, oldRotZ);
		}
	}
	return 1;
}
stock split(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc))
    {
        if(strsrc[i]==delimiter || i==strlen(strsrc))
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}
stock PCLoad()
{
	new File=ini_openFile("Configirator.ini");
	ini_getInteger(File,"State",pc);
	ini_closeFile(File);
}
stock PCSave()
{
	new File=ini_openFile("Configirator.ini");
	ini_setInteger(File,"State",pc);
	ini_closeFile(File);
}
stock Cplayer()
{
	if(pc==1)
	{
        new total_objects_from_files=0;
		total_objects_from_files += LoadObjects("ObjectsLoad.ini");
		printf("Загружено объектов из файла: %d",total_objects_from_files);
	}
}
stock LoadObjects(const filename[])
{
	new File:file_ptr;
	new objects_loaded;
	new line[256];
	new var_from_line[64];
	new index;
	file_ptr = fopen(filename,filemode:io_read);
	if(!file_ptr) return 0;
	objects_loaded = 0;
	while(fread(file_ptr,line,256) > 0)
	{
		index = 0;
		index = token_by_delim(line,var_from_line,'(',index);
		if(index == (-1)) continue;

		if(!strcmp(var_from_line, "CreateDynamicObject"))
		{
			new objecttype, Float:SpawnX, Float:SpawnY, Float:SpawnZ, Float:SpawnRotX, Float:SpawnRotY, Float:SpawnRotZ;
			delim_int(objecttype, ',');
			delim_flt(SpawnX, ',');
			delim_flt(SpawnY, ',');
			delim_flt(SpawnZ, ',');
			delim_flt(SpawnRotX, ',');
			delim_flt(SpawnRotY, ',');
			delim_flt(SpawnRotZ, ')');
			//printf("CreateDynamicObject(%d,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f)",objecttype,SpawnX,SpawnY,SpawnZ,SpawnRotX,SpawnRotY,SpawnRotZ);
			CreateDynamicObject(objecttype,SpawnX,SpawnY,SpawnZ,SpawnRotX,SpawnRotY,SpawnRotZ);
			objects_loaded++;
		}
		else
		{
			printf("Неизвестная строка - %s", var_from_line);
		}
	}
	fclose(file_ptr);
	printf("Loaded %d objects from: %s",objects_loaded,filename);
	return objects_loaded;
}
stock token_by_delim(const string[], return_str[], delim, start_index)
{
	new x=0;
	while(string[start_index] != EOS && string[start_index] != delim)
	{
		return_str[x] = string[start_index];
		x++;
		start_index++;
	}
	return_str[x] = EOS;
	if(string[start_index] == EOS) start_index = (-1);
	return start_index;
}
