This little program will copy the waypoints set on one specific group in the mission to all groups that have the skill level set as "Client".
Make sure you create a backup of your mission file before running it. There is no guarantee that it works flawlessly, so better to be safe than sorry.

Requirements

Lua for windows: https://github.com/rjpcomputing/luaforwindows/releases

.NET runtime 6.0: https://dotnet.microsoft.com/en-us/download

Step 1.
Add any plane to your mission and set its GROUP name to "route-template-blue", "route-template-red" or "route-template-neutrals" without the quotes, 
create waypoints for it as you'd like and save the mission.
You can have one template group per each coalition.

Step 2.
Copy the .miz file of your mission into the folder that you extracted this program into. (same folder that MassWaypointEdit.exe can be found in)
(Keep a backup of the original .miz file in case things go wrong)

Step 3.
Drag and drop the .miz file from this folder on top of MassWaypointEdit.exe

Step 4.
Once its done copy the .miz file back into your dcs missions folder, careful not to overwrite your backup accidentally.

Step 5.
Open the mission in the editor. All groups that were set to client should now have the new waypoints.
You can now safely remove the "route-template-group" group from your mission.


Other:

Exclude certain module types from being updated by editing the file named "ignore.lua" and changing the values to true if the module is to be skipped, or false if it should be updated.