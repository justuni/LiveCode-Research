script "Global_Movie_Record_Settings_Menu"
--> MetaData
-
license: GPLv3
name: Global_Movie_Record_Settings_Menu
type: controller
version: 0.1


--> Global | Movie | Record | Settings | Menu
-
on menu_ChooseVideoGrabberSettings grabberSettingName
   set the grabber_SettingName of me to grabberSettingName
end menu_ChooseVideoGrabberSettings

on menu_DeleteVideoGrabberSettings grabberSettingName
   grabber_DeleteSettings grabberSettingName
end menu_DeleteVideoGrabberSettings

on menu_DisplayVideoGrabberSettings grabberSettingName
   grabber_DisplaySettings grabberSettingName
end menu_DisplayVideoGrabberSettings

on menu_NewVideoGrabberSetting mTarget
   local grabberSettings
   
   revVideoGrabDialog
   revVideoGrabSettings "grabberSettings"
   
   put lcw_Ask("Choose a name to save these settings under?", "settings name") into grabberSettingName
   set the grabber_Setting [grabberSettingName] of me to grabberSettings
end menu_NewVideoGrabberSetting

on _
end _

on menu_TestTarget mTarget
   put the image_Object of mTarget into imageObject
   put the rect of imageObject into someRect
   rect_CreateMask someRect
   set the beepPitch to 1000
   beep
end menu_TestTarget


--> Global | Movie | Record | Settings | Menu | Props
-

--> Global | Movie | Record | Settings | Menu | Disabled
-

--> Global | Movie | Record | Settings
-
command movie_VideoGrabIdle
   revVideoGrabIdle
   
   if movie_IsVideoGrabbing() is true then send "movie_VideoGrabIdle" to me in 10 milliseconds
end movie_VideoGrabIdle

function movie_IsVideoGrabbing
   global OPN
   return OPN ["movie_VideoGrabIdle"] is true
end movie_IsVideoGrabbing

command movie_SetVideoGrabbing someBoolean
   global OPN
   put someBoolean into OPN ["movie_VideoGrabIdle"]
   if someBoolean is true then movie_VideoGrabIdle
end movie_SetVideoGrabbing

command grabber_DisplaySettings someName
   local grabberSettingsArray
   put the grabber_SettingsArray of me into grabberSettingsArray
   display_Array grabberSettingsArray, "the grabber_SettingsArray of me"
end grabber_DisplaySettings


--> Global | Movie | Record | Settings | Model
-
command grabber_DeleteSettings someName
   local grabberSettingsArray
   put the grabber_SettingsArray of me into grabberSettingsArray
   delete local grabberSettingsArray [someName]
   set the grabber_SettingsArray of me to grabberSettingsArray
end grabber_DeleteSettings

getprop grabber_SettingName
   return the uOPN ["grabberSettingName"] of me
end grabber_SettingName

setprop grabber_SettingName grabberSettingName
   local grabberSetting
   
   put the grabber_Setting [grabberSettingName] of me into grabberSetting
   revSetVideoGrabSettings "grabberSetting"
   set the uOPN ["grabberSettingName"] of me to grabberSettingName
end grabber_SettingName

getprop grabber_SettingNames
   put the grabber_SettingsArray of me into grabberSettingsArray
   return keys(grabberSettingsArray)
end grabber_SettingNames

getprop grabber_Setting [someName]
   put the grabber_SettingsArray of me into grabberSettingsArray
   return grabberSettingsArray [someName]
end grabber_Setting

setprop grabber_Setting [someName] grabberSetting
   put the grabber_SettingsArray of me into grabberSettingsArray
   put grabberSetting into grabberSettingsArray [someName]
   set the grabber_SettingsArray of me to grabberSettingsArray
   
   set the grabber_SettingName of me to someName
end grabber_Setting

getprop grabber_SettingsArray
   return the uOPN_MovieGrabberSettings of me
end grabber_SettingsArray

setprop grabber_SettingsArray grabberArray
   set the uOPN_MovieGrabberSettings of me to grabberArray
end grabber_SettingsArray

