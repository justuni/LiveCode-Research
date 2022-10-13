script "Global_Movie_Record_Time Lapse_Menu"
--> MetaData
-
license: GPLv3
name: Global_Movie_Record_Time Lapse_Menu
type: controller
version: 0.1


--> Global | Movie | Record | Time Lapse | Menu
-
on menu_TimeLapse someBoolean, mTarget
   set the time_Lapse of me to someBoolean
   if someBoolean is true then
      grabber_TakeImage mTarget
   end if
end menu_TimeLapse

on menu_TimeInterval timeInterval
   set the time_Interval of me to timeInterval
end menu_TimeInterval

on menu_SetImageSequenceFolder
   answer folder "Select a folder to store the image sequence..."
   put it into someFolder
   if someFolder is empty then exit to top
   
   set the grabber_ImageFolder of me to someFolder
end menu_SetImageSequenceFolder


--> Global | Movie | Record | Time Lapse | Menu | Props
-

--> Global | Movie | Record | Time Lapse | Menu | Disabled
-

--> Global | Movie | Record | Time Lapse
-
command grabber_TakeImage mTarget
   if the time_Lapse of me is true then
      -- put the image_Object of mTarget into imageObject
      put view_GetTemplateObject ("View|Image|OPN Image") into imageView
      put the image_Object of imageView into imageObject
      
      put the width of imageObject into someWidth
      put the height of imageObject into someHeight
      
      put the time_Interval of me into timeInterval
      revVideoFrameImage someWidth, someHeight, iData
      
      set the imagedata of imageObject to iData
      put nextImageFile() into imageFile
      image_ExportToFile imageObject, imageFile, "png"
      
      -- beep
      send "grabber_TakeImage mTarget" to me in timeInterval ticks
   end if
end grabber_TakeImage

private function nextImageFile
   put the defaultFolder into oFolder
   put the grabber_ImageFolder of me into grabberFolder
   set the defaultFolder to grabberFolder
   put the files into shortFiles
   filter shortFiles with "*_TimeLapse.png"
   put the number of lines of shortFiles into nextNum
   set the numberformat to "000000"
   add 1 to nextNum
   put nextNum & "__TimeLapse.png" into shortFile
   set the defaultFolder to oFolder
   
   folder_Format grabberFolder
   put grabberFolder & shortFile into newImageFile
   return newImageFile
end nextImageFile


--> Global | Movie | Record | Time Lapse | Model
-
getprop grabber_ImageFolder
   return the uOPN ["grabber_ImageFolder"] of me
end grabber_ImageFolder

setprop grabber_ImageFolder someFolder
   set the uOPN ["grabber_ImageFolder"] of me to someFolder
end grabber_ImageFolder

getprop time_Lapse
   return the uOPN ["time_Lapse"] of me
end time_Lapse

setprop time_Lapse someBoolean
   set the uOPN ["time_Lapse"] of me to someBoolean
end time_Lapse

getprop time_Interval
   put the uOPN ["time_Interval"] of me into timeInterval
   return timeInterval
end time_Interval

setprop time_Interval timeInterval
   set the uOPN ["time_Interval"] of me to timeInterval
end time_Interval

getprop time_Intervals
   return "2,4,6,10,30,60,120,180,1800"
end time_Intervals
