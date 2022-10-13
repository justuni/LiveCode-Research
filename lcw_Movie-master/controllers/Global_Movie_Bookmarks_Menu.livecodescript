script "Global_Movie_Bookmarks_Menu"
--> MetaData
-
license: GPLv3
name: Global_Movie_Bookmarks_Menu
type: controller
version: 0.1


--> Global | Movie | Bookmarks | Menu
-
on menu_MarkInPoint mTarget
    put the movie_View of mTarget into movieView
    put the movie_Player of mTarget into moviePlayer
     
    if the movie_InPoint of mTarget is 0 then
        put the movie_Seconds of movieView into movieSeconds
        set the movie_InPoint of movieView to movieSeconds
        set the showselection of moviePlayer to true
    else
        set the movie_InPoint of movieView to 0
        set the showselection of moviePlayer to false
    end if
end menu_MarkInPoint

on menu_MarkOutPoint mTarget
    put the movie_View of mTarget into movieView
    put the movie_Player of mTarget into moviePlayer
     
    if the optionkey is "Down" then
        set the movie_OutPoint of movieView to 0
        set the showselection of moviePlayer to false
    else
        put the movie_Seconds of movieView into movieSeconds
        set the movie_OutPoint of movieView to movieSeconds
        set the showselection of moviePlayer to true
    end if
end menu_MarkOutPoint

on menu_AddBookmark mTarget
    put the movie_View of mTarget into movieView
    
    ask "Mark the current selection under the following title?"
    if it is empty then exit to top
    put it into bookmarkTitle
    
    set the movie_NewBookMark of movieView to bookmarkTitle
end menu_AddBookmark

on _
end _

on menu_GoToMarker menuChoice, mTarget
    put the movie_View of mTarget into movieView
    switch menuChoice 
        case "in point"
            put the movie_InPoint of movieView into movieTime
            break
        case "out point"
            put the movie_OutPoint of movieView into movieTime
            break
    end switch
    if movieTime is empty then return empty
    
    lock screen
    set the movie_ControllerShowing of movieView to true
    set the movie_Seconds of movieView to movieTime
    unlock screen
    -- put movieTime
end menu_GoToMarker

on menu_DisplayBookmark bookmarkTitle, mTarget
    put the movie_View of mTarget into movieView
     
    put the movie_File of movieView into movieFile
    put movie_GetMovieXml(movieFile) into movieXml
    movie_DeconstructBookmarkXml movieXml, bookmarkTitle, inPoint, outPoint, notes, who, clipType, dateCreated, bookMarkXml
    movie_DisplayBookMark inPoint, outPoint, movieView
    movie_DisplayMetadata movieView
end menu_DisplayBookmark

on menu_DeleteBookmark bookmarkTitle, mTarget
    put the movie_View of mTarget into movieView
     
    answer merge("Are you sure you want to delete the bookmark '[[bookMarkTitle]]'?") with "OK" or "Cancel"
    if it is "Cancel" then exit to top
     
    put the movie_File of movieView into movieFile
    movie_DeleteBookMark bookmarkTitle, movieFile
end menu_DeleteBookmark


--> Global | Movie | Bookmarks | Menu | Props
-
getprop bookmark_Titles [mTarget]
   if exists(mTarget) is false then
      put mTarget
      return empty
   else
      get the movie_Bookmarks of mTarget
      return it
   end if
end bookmark_Titles


--> Global | Movie | Bookmarks | Menu | Disabled
-
getprop disabled_AddBookmark [mTarget]
   put the movie_OutPoint of mTarget into outPoint
   put the movie_InPoint of mTarget into inPoint
   if outPoint = inPoint then
      return true
   else
      return false
   end if
end disabled_AddBookmark

getprop disabled_GoToBookmark [mTarget]
   put the movie_InPoint of mTarget into movieInPoint
   put the movie_OutPoint of mTarget into movieOutPoint
   return false
end disabled_GoToBookmark
