script "Global_Movie_Record_Menu"
--> MetaData
-
license: GPLv3
name: Global_Movie_Record_Menu
type: controller
version: 0.1


--> Global | Movie | Record | Menu
-
on menu_InitialiseRecording movieView
   put the rect of movieView into innerRect 
   -- put rect_SubtractMargin (24, the rect of movieView) into innerRect 
   
   put the stack_Object of movieView into stackObject
   put the short name of stackObject into stackName
   
   revInitializeVideoGrabber stackName, "QT", tRectinnerRect 
   revSetVideoGrabberRect innerRect
   
   local vSettings
   put the videoSettings of me into vSettings
   revSetVideoGrabSettings "vSettings"
end menu_InitialiseRecording

on menu_RecordVideo movieView
   put the stack_Object of movieView into stackObject
   
   get the effective filename of stackObject
   set the itemdelimiter to slash
   delete item -1 of it
   ask file "Save video as..." with it & "/untitled.mov" as sheet
   if it is empty then exit to top
   set the filetype to "TVODMooV" --make sure Mac OS knows what it is
   revRecordVideo it
   movie_SetVideoGrabbing true
end menu_RecordVideo

on menu_CloseRecording movieView
   set the time_Lapse of me to false
   -- movie_SetVideoGrabbing false
   revCloseVideoGrabber
end menu_CloseRecording

on _
end _

on menu_PreviewVideo movieView
   revPreviewVideo
   movie_SetVideoGrabbing true
end menu_PreviewVideo

on menu_ClosePreview movieView
   movie_SetVideoGrabbing false
   revStopPreviewingVideo
end menu_ClosePreview

on _
end _

on submenu_Settings
   return "Global | Movie | Record | Settings | Menu"
end submenu_Settings


--> Global | Movie | Record | Menu | Props
-

--> Global | Movie | Record | Menu | Disabled
-
