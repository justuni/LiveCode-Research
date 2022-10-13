script "lib_Movie"
--> MetaData
-
license: GPLv3
name: lib_Movie
type: library
copyright: David Bovill
version: 0.1

/*
This stack can be used as a standalone window for displaying movies.

The window can be resizeable, allowing full screen viewing with hding of menus and cursor.
The stack also contains a library and a view. 
The library is the script of the stack
The view can be copied multiple times to different locations.

The stack can also be "linked" to related views and therefore the stacks that contain these views:
movieController_View
moviePlayList_View
*/


--> Old
-
getprop movie_PlayClip
   return the playselection of the movie_Player of the target
end movie_PlayClip

setprop movie_PlayClip someBoolean
    set the playselection of the movie_Player of the target  to someBoolean
 end movie_PlayClip
 
 getprop movie_StartTime [tFormat]
   put the clip_StartTime [tFormat] of the target into sTime
   return sTime  
end movie_StartTime

setprop movie_StartTime [tFormat] sTime
   set the clip_StartTime [tFormat] of the target to sTime
   return the result  
end movie_StartTime

getprop movie_EndTime
   put the clip_EndTime [tFormat] of the target into sTime
   return sTime  
end movie_EndTime

setprop movie_EndTime eTime
   set the clip_EndTime [tFormat] of the target to eTime
   return the result  
end movie_EndTime


--> Movie | Objects | Default
-
/*
These are "default" elemets in that as properties of the gobal library,
they will be used if there is no local property to override them.
*/

getprop movie_StackName
   return "View|Movie|Player"
end movie_StackName

getprop movie_View
   return the long id of group 1 of me
end movie_View

getprop movie_Player
   return the movie_Player of the movie_View of me
end movie_Player

getprop movieController_View
   put view_GetTemplateObject ("View|Movie|Controller|QuickTime") into movieController
   if exists(movieController) then
      return movieController
   else
      return empty
   end if
end movieController_View

getprop playList_Stack
   return the name of stack "opn_MoviePlayList" 
end playList_Stack


--> Movie| Progressive
-
setprop movie_Url someUrl
   put the movie_View of the target into movieView
   if exists(movieView) is false then return empty
   put the movie_Player of movieView into moviePlayer
   
   -- could check it is a valid url (http, rtsp)
   put word 1 to -1 of line 1 of someUrl into someUrl
   
   -- put the rect of movieView into oRect
   set filename of player "Movie" to someUrl
   send "movie_DisplayDownloadStatus movieView" to me in 100 milliseconds
   -- set the view_Rect of movieView to oRect
   
   focus on moviePlayer
   unlock screen
end movie_Url

private command movie_DisplayDownloadStatus movieView
   -- an asynch idle loop
   put the movie_Player of movieView into moviePlayer
   
   put the movie_LoadState of moviePlayer into movieLoadState
   set the movie_DisplayLoadState of moviePlayer to movieLoadState
   if movieLoadState is not "MovieLoadStateComplete" then
      send "movie_DisplayDownloadStatus" to me in 100 milliseconds
   end if
end movie_DisplayDownloadStatus

getprop movie_LoadState
   put the movie_Player  of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   try
      put moviecontrollerid of moviePlayer into moviecontrollerid
      put qtGetMovieLoadState(movieControllerID) into loadStateNumber
      switch
         case loadStateNumber < 1000
            return "MovieLoadStateError"
         case loadStateNumber < 10000
            return "MovieLoadStateLoading"
         case loadStateNumber < 20000
            return "MovieLoadStatePlayable"
         case loadStateNumber < 100000
            return "MovieLoadStatePlayThroughOK"
         default
            return "MovieLoadStateComplete"
      end switch
   catch someError
      return empty
   end try
end movie_LoadState


--> Movie| Progressive | Display
-
setprop display_MovieLoadState movieLoadState
   -- a default to be handled / overrideen by the player
   
   put the movie_Player  of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   
   try
      put duration of moviePlayer into movieDuration
      if movieDuration = 0 then
         put 0 into percentDownloaded
      else
         put moviecontrollerid of moviePlayer into moviecontrollerid
         put qtGetMaxLoadedTimeInMovie(movieControllerID) into maxLoadedTime
         put maxLoadedTime / (movieDuration + 0.00001) * 100 into percentDownloaded
      end if
      
      switch movieLoadState
         case "MovieLoadStateError"
            -- reset
            break
         case "MovieLoadStateLoading"
            break
         default
            if the paused of player "Movie" is true then
               set the paused of player "Movie" to false
               -- start player "Movie"
            end if
      end switch
   catch someError
      return empty
   end try
end display_MovieLoadState


--> Movie | Geometry
-
getprop movie_OriginalRect [sFactor]
   put the movie_Player of the target into moviePlayer
   if exists(moviePlayer) is false then return empty
   return the media_OriginalRect [sFactor] of moviePlayer
end movie_OriginalRect

getprop movie_Size
   return the uOPN ["movie_Size"] of the movie_View of the target
end movie_Size

setprop movie_Size viewSize
   put the movie_View of the target into movieView
   put the movie_Player of movieView into moviePlayer
   
   set the uOPN ["movie_Size"] of movieView to viewSize
   switch word 1 of viewSize
      case "Resize"
         set the view_Rect of movieView to the rect of movieView
         break
      case "Original"
         put the movie_OriginalRect of movieView into movieRect
         set the view_Rect of movieView to movieRect
         break
      case "Half"
         put the movie_OriginalRect [0.5] of movieView into movieRect
         set the view_Rect of movieView to movieRect
         break
      case "Double"
         put the movie_OriginalRect [2] of movieView into movieRect
         set the view_Rect of movieView to movieRect
         break
      case "Full"
         put the card_Object of movieView into cardObject
         put the rect of cardObject into cardRect
         put the card_Margin of cardObject into someMargin
         if someMargin is not a number then
            put 0 into someMargin
            set the card_Margin of cardObject to someMargin
         end if
         put rect_SubtractMargin(someMargin, cardRect) into movieRect
         
         set the view_Rect of movieView to movieRect
         break
   end switch
end movie_Size


--> Media | Geometry
-
/*
These handlers *should* work for both images and video (ie any media).
*/

getprop media_OriginalRect [sFactor]
   put the long id of the target into mediaObject
   if sFactor is not a number then put 1 into sFactor
   
   put the loc of mediaObject into someLoc
   put sFactor * the formattedwidth of mediaObject into originalW
   put sFactor * the formattedheight of mediaObject into originalH
   return rect_LocWidthHeight(someLoc, originalW, originalH)
end media_OriginalRect

getprop media_Rect [frameRect]
   -- when invisible as formatted stuff = 0
   -- so using stored properties
   put the movie_View of the target into movieView
   if frameRect is empty then put the rect of movieView into frameRect
   
   put the media_Width of movieView into originalW
   if originalW is 0 then return frameRect
   
   put the media_Height of movieView into originalH
   put rect_FitInside(originalW, originalH, frameRect) into someRect
   return someRect
end media_Rect

setprop media_Rect [someDimension] someRect
   lock screen
   put the long id of the target into targetObject
   
   put the margins of targetObject into someMargin
   switch
      case someDimension is a point
         put item 1 of someDimension into xDimension
         put item 2 of someDimension into yDimension
         put rect_FitInside (xDimension, yDimension, someRect) into mediaRect
         put rect_AddMargin (someMargin, mediaRect) into someRect
         set the rect of targetObject to someRect
         break
      case someDimension is empty
         put the media_Width of targetObject into xDimension
         put the media_Height of targetObject into yDimension
         put rect_FitInside (xDimension, yDimension, someRect) into mediaRect
         put rect_AddMargin (someMargin, mediaRect) into someRect
         set the rect of targetObject to someRect
         break
      default
         -- bit of a hack!
         set the rect of targetObject to someRect
         set the resize_Style of targetObject to someDimension
         put the result into mediaRect
         put rect_AddMargin (someMargin, mediaRect) into someRect
         set the rect of targetObject to someRect
   end switch
   -- rect_CreateMask someRect
   unlock screen
   return someRect
end media_Rect

getprop media_Width
   put the movie_View of the target into movieView
   if the visible of movieView is true then
      -- this is zero if player is not visible
      put the movie_Player of movieView into moviePlayer
      return the formattedwidth of moviePlayer
   else
      return the uOPN ["media_Width"] of movieView
   end if
end media_Width

setprop media_Width someWidth
   put the movie_View of the target into movieView
   set the uOPN ["media_Width"] of movieView to someWidth
end media_Width

getprop media_Height
   put the movie_View of the target into movieView
   if the visible of movieView is true then
      -- this is zero if player is not visible
      put the movie_Player of movieView into moviePlayer
      return the formattedheight of moviePlayer
   else
      return the uOPN ["media_Height"] of movieView
   end if
end media_Height

setprop media_Height someHeight
   put the movie_View of the target into movieView
   set the uOPN ["media_Height"] of movieView to someHeight
end media_Height


--> Movie | Play
-
on movie_Play movieFile, bookmarkTitle, movieView
    if exists(movieView) is false then
        put the movie_View of the target into movieView
        if exists(movieView) is false then return merge("Error: movie view does not exist!") 
    end if
    if movieFile is empty then put the movie_File of movieView into movieFile
    
    if file_IsVideo(movieFile) is false then
        return merge("Error: file [[movieFile]] is not a video!")
    else
        -- set the movie_File of movieView to empty
        object_GoTo movieView
        movie_PlayUrlOrFile movieFile, movieView, bookmarkTitle
    end if
end movie_Play

on movie_PlayUrlOrFile movieFile, movieView, bookmarkTitle
    set the cursor to watch
    lock screen
    set the movie_File of movieView to movieFile
    set the movie_BookMark of movieView to bookmarkTitle
    set the movie_PlayRate of movieView to 1
    set the movie_PlayStatus of movieView to "play"
    unlock screen
    
    if the stack_IsVisible of movieView is false then set the stack_IsVisible of movieView to true
    focus on the movie_Player of movieView
end movie_PlayUrlOrFile

function movie_ReversePlayStatus playStatus
    switch playStatus
        case "stop"
            return "play"
        case "play"
            return "pause"
        case "pause"
            return "play"
    end switch
end movie_ReversePlayStatus

setprop movie_DisplayPaused boolean
    -- automatically set by messages
    put the movieController_View of the target into movieControllerViews
    repeat for each line movieControllerView in movieControllerViews
        if exists(movieControllerView) then
            set the movie_Paused of movieControllerView to boolean
        end if
    end repeat
end movie_DisplayPaused

getprop movie_PlayStatus
    put the movie_Player of the target into moviePlayer
    
    put the paused of moviePlayer into isPaused
    put the movie_Time of moviePlayer = 0 into atStart
     
    if atStart and isPaused then
        return "stop"
    else if isPaused then
        return "pause"
    else
        return "play"
    end if
end movie_PlayStatus
 
setprop movie_PlayStatus playStatus
    put the movie_Player of the target into moviePlayer
    switch playStatus
        case "play"
            set the paused of moviePlayer to false
            break
        case "pause"
            set the paused of moviePlayer to true
            break
        case "stop"
            set the paused of moviePlayer to true
            set the movie_Time of moviePlayer to 0
            break
    end switch
    focus on moviePlayer
end movie_PlayStatus

on remote_PlayMovie
    put the movie_View of the target into movieView
    if the movie_PlayStatus of movieView is "play" then
        -- start again
        -- movie_Play
        -- set the movie_Size of group 1 to "full"
        beep
    else
        -- put "Interactive"
        get the movie_Size of movieView
        -- put it
        if it is "full" then
            put "medium" into layoutName 
            send "menu_RestoreMoviePosition layoutName, movieView" to movieView
        else
            set the movie_Size of group 1 to "full"
        end if
    end if
end remote_PlayMovie


--> Movie | Image
-
/*
A movie image is a still file associated with the movie clip.
As a player object can display an image file we do not need an image object to do this.
Except I guess if QuickTime is not available.
*/

getprop movie_ImageShowing
    put the movie_View of the target into movieView
    put the movie_Player of the target into moviePlayer
     
    put the movie_ImageFile of the target into movieImageFile
    if movieImageFile is empty then return false
    else if the movie_File of the target = movieImageFile then
        return true
    else
        return false
    end if
end movie_ImageShowing

setprop movie_ImageShowing boolean
    put the movie_View of the target into movieView
    put the movie_Player of the target into moviePlayer
     
    put the movie_ImageFile of the target into movieImageFile
    lock screen
    if boolean is true then
        put the movie_File of movieView into movieFile
        set the filename of moviePlayer to movieImageFile
        set the uOPN ["movie_LastFile"] of movieView to movieFile
         
        set the uOPN ["movie_LastShowcontroller"] of movieView to the showcontroller of moviePlayer
        set the uOPN ["movie_LastTime"] of movieView to the movie_Seconds of movieView
        set the movie_ControllerShowing of movieView to false
    else
        set the movie_File of moviePlayer to the uOPN ["movie_LastFile"] of movieView
         
        set the movie_ControllerShowing of movieView to the uOPN ["movie_LastShowcontroller"] of movieView
        set the movie_Seconds of movieView to the uOPN ["movie_LastTime"] of movieView
    end if
    unlock screen
end movie_ImageShowing

getprop movie_ImageFile
    put the movie_View of the target into movieView
    return the uOPN ["movie_ImageFile"] of movieView
end movie_ImageFile

setprop movie_ImageFile someFile
    put the movie_View of the target into movieView
    set the uOPN ["movie_ImageFile"] of movieView to someFile
    set the movie_ImageShowing of movieView to true
end movie_ImageFile


--> Movie | Display
-
on movie_ShowControllerPalette someBoolean, movieView
    put "View|Movie|Controller|Quicktime" into movieControllerStackName
    if someBoolean is true then
        palette stack movieControllerStackName
         
        put the mobile_Name of group 1 of stack movieControllerStackName into movieControllerView
        set the movie_View of movieControllerView to movieView
    else if movie_ControllerPaletteShowing() then
        close stack movieControllerStackName
    end if
end movie_ShowControllerPalette

function movie_ControllerPaletteShowing
    put "View|Movie|Controller|Quicktime" into movieControllerStackName
    return movieControllerStackName is among the lines of the openstacks
end movie_ControllerPaletteShowing

getprop movie_DisplaySelection
    return the showselection of the movie_Player of the target
end movie_DisplaySelection

setprop movie_DisplaySelection someBoolean
    set the showselection of the movie_Player of the target  to someBoolean
 end movie_DisplaySelection
 
getprop movie_InPoint
    put the movie_View of the target into movieView
    if exists(movieView) is false then return empty
    put the movie_Player of movieView into moviePlayer
     
    put the timescale of moviePlayer into someScale
    if someScale = 0 then return empty
    put the starttime of moviePlayer into movieTime
    return movieTime / someScale
end movie_InPoint

setprop movie_InPoint movieSeconds
    put the movie_View of the target into movieView
    if exists(movieView) is false then return empty
    put the movie_Player of movieView into moviePlayer
     
    put the timescale of moviePlayer into someScale
    if someScale = 0 then return empty
    movieConvertTime movieSeconds
    
    if movieSeconds is "end" then
        put the duration of moviePlayer into movieTime
    else
        put round(movieSeconds * someScale) into movieTime
    end if
    set the starttime of moviePlayer to movieTime
     
    put the metadata_View of movieView into metadataView
    if exists(metadataView) then
        set the display_InPoint of metaDataView to movieSeconds
    end if
    focus on moviePlayer
end movie_InPoint

getprop movie_OutPoint
    put the movie_Player of the target into moviePlayer
    
    put the timescale of moviePlayer into someScale
    if someScale = 0 then return empty
    put the endtime of moviePlayer into movieTime
    return movieTime / someScale
end movie_OutPoint

setprop movie_OutPoint movieSeconds
    put the movie_Player of the target into moviePlayer
    
    put the timescale of moviePlayer into someScale
    if someScale = 0 then return empty
    movieConvertTime movieSeconds
    
    if movieSeconds is "end" then
        put the duration of moviePlayer into movieTime
    else
        put round(movieSeconds * someScale) into movieTime
    end if
    set the endtime of moviePlayer to movieTime
     
    try
        put the metadata_View of the target into metadataView
        if exists(metadataView) then
            set the display_OutPoint of metaDataView to movieSeconds
        end if
    end try
    focus on moviePlayer
end movie_OutPoint


--> Private
-
command movieConvertTime @movieSeconds
    -- in case it is not seconds
    -- should not be currettime as this is not moviescale independent
    if movieSeconds is a number then return empty
    set the itemdelimiter to ":"
    if the number of items of movieSeconds is 4 then
        put time_HmsfToSeconds(movieSeconds) into movieSeconds
        return empty
    else
        get merge("Time not recognised: [[movieSeconds]]")
        opn_Notify it
        return it
    end if
end movieConvertTime


--> Date and Time
-
function time_HmsfToSeconds hmsf, pFramesPerSecond
   if pFramesPerSecond is not a number then
      put 25 into pFramesPerSecond
   end if
   
   set the itemdelimiter to ":"
   put item 1 of hmsf into someHours
   put item 2 of hmsf into someMinutes
   put item 3 of hmsf into someSeconds
   put item 4 of hmsf into someFrames
   
   add someHours * 3600 to someSeconds
   add someMinutes * 60 to someSeconds
   add someFrames / pFramesPerSecond to someSeconds
   
   return someSeconds
end time_HmsfToSeconds

function time_SecondsToHMSF someSeconds, someFrames
    put the numberformat into oFormat
    set the numberformat to "##"
     
    put someSeconds div 3600 into someHours 
    put someSeconds mod 3600 into secondsLeft
     
    put secondsLeft div 60 into someMinutes
    put secondsLeft mod 60 into secondsLeft
     
    put trunc(secondsLeft) into someSeconds
    put secondsLeft - someSeconds into someFraction
     
    if someFrames is empty then put round(someFraction * 25) into someFrames
    add 0 to someFrames
     
    get someHours & ":" & someMinutes  & ":" & someSeconds  & ":" & someFrames
    set the numberformat to oFormat
    return it
end time_SecondsToHMSF


--> XML
-
on xml_CheckRevError theResult
    if char 1 to 6 of theResult is "xmlerr" then
        opn_Notify theResult
        exit to top
    end if
 end xml_CheckRevError
 
 
 --> Deps
 -
function file_IsVideo someFile, quickSearch, beAggressive
   set the itemdelimiter to "."
   if the platform = "MacOS" then
      put "file -I" && kwote (someFile) into someShell
      put shell (someShell) into shellReply
      -- /Users/BabyBlue/Movies/Guerrilla.mp4: video/mp4; charset=binary
      set the itemdelimiter to ":"
      get token 1 of item 2 of shellReply
      put it ="video" into isVideo
      
      -- put spotlight_GetFileKind (someFile) into fileKind
      if isVideo is true then
         return true
      else
         return false
      end if
   else if item -1 of someFile is among the items of "mov.mp4.avi.mpg.m4v" then
      return true
   else
      return false
   end if
   
   /*
   -- in case it is an eyeTV bundle
   put eyetv_ExtractMp4File (someFile) into eyeTvFile
   if there is a file eyeTvFile then
      put eyeTvFile into someFile
   end if
   
   -- check its a video
   if there is not a file someFile then return false
   file_Deconstruct someFile, someRoot, shortName, fileExtension
   
   if external_GetInstalled("eqt") is true then
      -- "qtCanOpenFile" and "qtGetMovieFileType" do not seem to recognize avi's
      if fileExtension = "avi" then return true
      
      put true into onlyMovies
      put quickSearch is not false into quickSearch
      put beAggressive is true into beAggressive
      if qtCanOpenFile(someFile, quickSearch, onlyMovies, beAggressive) then
         -- get qtGetMovieFileType(someFile)
         -- if it is "Video" then
         return true
         -- end if
      end if
      return false
   else if there is a file someFile then
      if fileExtension is among the items of "mov,mp4,avi,mpg,m4v" then
         return true
      else
         return false
      end if
   else
      return false
   end if
   */
end file_IsVideo

