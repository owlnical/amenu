/*
	functions.ahk
*/
#Include settings/settings.ahk
#Include database/database.ahk
#include gui/gui.ahk

; Display error message and exit
Error(string) {
	MsgBox, 48, % Title " error", % string ".`n`namenu will now exit."
	ExitApp
}

/*
	Return value from ini file
		section
			Section of ini file, set to ALL to return string with section names
		key
			Key to read in specified section
		default
			Default value in case of missing/empty key
		File
			Path to ini file
*/
IniRead(section := "", key := "", default := "", file := "settings.ini") {
	IniRead, value, % file, % section, % key, % default
	if(value == "ERROR" and section == "ALL") {
		Error("An error occured while reading section names from " file)
	}
	else if (value == "ERROR") {
		Error("An error occured while reading " file ", section " section ", key " key)
	}
	Return value
}

; Return true if path is an existing directory
DirExist(path) {
	if (InStr(FileExist(path), "D"))
		return true
	else
		return false
}

; Create path and set it as working dir
SetWorkingDir(path) {
	if !DirExist(path)
		FileCreateDir % path
	SetWorkingDir % path
}

/*
	Register new hotkey. Only hotkeys with GuiToggle as target are global.
		key
			Combination of keys to be pressed
		target
			Function triggered by hotkey
*/
Hotkey(key, target) {
	if (target == "GuiToggle")
		Hotkey, IfWinActive
	else
		Hotkey, IfWinActive, % Title
	Hotkey, % key, % target, UseErrorLevel
	if ErrorLevel {
		if (ErrorLevel == 1)
			errorstring := "The target '" . target . "' does not exist. Check settings.ini for a list of valid target functions"
		else if ErrorLevel in 2,4
			errorstring := "The defined key combination '" . key . "' is not recognized or is not supported"
		else if (ErrorLevel == 3)
			errorstring := "The prefix in '" . key . "' is not allowed"
		Error("Hotkey configuration error! Setting """ . key . " = " . target . """ is invalid. " . errorstring . " (code " . ErrorLevel . ")")
	}
}