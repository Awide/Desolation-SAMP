YCMD:saveintoutvw(playerid, params[], help) {
	if(adminlevel[playerid] < 3) return SendErrorMessage(playerid, ERROR_ADMIN);
	if(!Group_GetPlayer(g_AdminDuty, playerid)) return SendErrorMessage(playerid, ERROR_DUTY);

	new targetid, targetvw;
	if(sscanf(params, "ii",targetid, targetvw)) return SCM(playerid, HEX_FADE2, "Usage: /saveintoutvw [sqlid] [virtualworld] (Saves the entrance's outside virtualworld! Unless the entrance is inside somewhere this value should be zero!)");
	
	foreach(new i:Entrances) {
		if(IntInfo[i][sqlid] == targetid) {
			mysql_format(g_SQL, sql, sizeof sql, "UPDATE `interiors` SET `outvw` = '%d' WHERE id = '%d' LIMIT 1", targetvw, targetid);
			mysql_tquery(g_SQL, sql, "", "");
			SFM(playerid, HEX_FADE2, "Datebase interior virtualworld update query submitted. Resetting outside virtualworld to %d!", targetvw);

			IntInfo[i][outvw] = targetvw;

			new string[256];
			format(string, sizeof string, "[LOG]: %s %s has set entrance %d's outside virtualworld to %d.", AdminNames[adminlevel[playerid]], PlayerName(playerid), targetid, targetvw);
			SendAdminMessage(HEX_YELLOW, string, true);

			return 1;
		}
	}

	SCM(playerid, HEX_RED, "Error: Invalid entrance sqlid!");

	return 1;
}