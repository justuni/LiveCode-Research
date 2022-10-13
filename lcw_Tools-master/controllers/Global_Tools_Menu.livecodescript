script "Global_Tools_Menu"
--> MetaData
-
license: GPLv3
name: Global_Tools_Menu
type: controller
version: 0.2


--> Global | Tools | Menu
-
on menu_DisplayLibraryArray mTarget, libraryArrayName
   put lcw_FetchArray (libraryArrayName) into libraryArray
   display_Array libraryArray, merge ("[[libraryArrayName]],lcw_FetchArray()")
end menu_DisplayLibraryArray

on menu_DisplayProjectArray indexView, someName
   put project_FetchArray (someName) into projectArray
   display_Array projectArray, merge ("[[someName]],project_FetchArray()")
end menu_DisplayProjectArray


--> Global | Tools | Menu | Props
-
getprop some_Names
   put env_GetHomeArrayFileData() into envProjectArrayFileArray
   put envProjectArrayFileArray ["projectNames"] into projectNameArray
   put keys (projectNameArray) into projectNames
   sort projectNames
   return projectNames
end some_Names

getprop library_ArrayNames
   put model_ListModelFiles (true) into shortFiles
   put file_StripExtension (shortFiles) into libraryArrayNames
   return libraryArrayNames
end library_ArrayNames
 
function file_StripExtension shortFiles
   set the columndelimiter to "."
   split shortFiles by column
   put shortFiles [1] into shortFileNames
   sort shortFileNames
   return shortFileNames
end file_StripExtension


--> Global | Tools | Menu | Disabled
-

--> Dev | Menu
-
on menu_TestModel
   -- check we are not overiding an important model
   breakpoint
   -- grab some test data
   put the model_Array ["lcw_ProjectDataLibrary.array"] of stack "model_Library" into oldModelArray
   
   put "model_Environment" into modelStackName
   set the model_Array [modelStackName] of stack modelStackName to oldModelArray
   put the model_Array [modelStackName] of stack modelStackName into modelArray
   display_Array modelArray
end menu_TestModel

