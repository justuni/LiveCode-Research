script "Global_Movie_Call_Menu"
--> MetaData
-
license: GPLv3
name: Global_Movie_Call_Menu
type: controller
version: 0.1


--> Global | Movie | Call | Menu
-
on menu_SetCallBack mTarget
    ask "set the callback to...." with "set the playrate of the target to 2"
    if it is empty then exit to top
    put it into movieCommand
    
    put the movie_Player of mTarget into moviePlayer
    put the callbacks of moviePlayer into scriptCalls
    put the currenttime of moviePlayer into thisTime
    put thisTime,movieCommand into callLine
    line_Insert callLine, scriptCalls
    sort lines of scriptCalls numeric by item 1 of each
    set the callbacks of moviePlayer to scriptCalls
    
    put scriptCalls
end menu_SetCallBack

on menu_DisplayCallBacks mTarget
    put the movie_Player of mTarget into moviePlayer
    put the callbacks of moviePlayer
end menu_DisplayCallBacks

on menu_ClearCallBacks mTarget
    put the movie_Player of mTarget into moviePlayer
    set the callbacks of moviePlayer to empty
end menu_ClearCallBacks

on _
end _

on menu_StoreCallBacks mTarget
    put the movie_Player of mTarget into moviePlayer
    put the callbacks of moviePlayer into scriptCalls
 end menu_StoreCallBacks
 

--> Global | Movie | Call | Menu | Props
-

--> Global | Movie | Call | Menu | Disabled
-
