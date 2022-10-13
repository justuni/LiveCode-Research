script "Global_Place_Menu"
--> MetaData
-
license: GPLv3
name: Global_Place_Menu
type: controller
version: 0.1


--> Global | Place | Menu
-
on menu_ConstructNewPlaceArray
   env_CreateNewPlaceArray
   menu_HkeyPlaceArrayDuplicates
end menu_ConstructNewPlaceArray

on _
end _

on menu_LoadStoredPlaceArray
   hkeyLine_LoadPlaceArray
   put the result into hkeyPlaceArray
   
   put keys (hkeyPlaceArray)
   lcw_Answer "Do you want to store the new combined placeArray?"
   script_StoreHkeyPlaceArray hkeyPlaceArray
end menu_LoadStoredPlaceArray

on menu_StoreActivePlaceArray
   put hkeyLine_GetPlaceArray() into hkeyPlaceArray
   script_StoreHkeyPlaceArray hkeyPlaceArray
end menu_StoreActivePlaceArray

on _
end _

on menu_HkeyPlaceArrayDuplicates
   put script_FetchHkeyPlaceArray() into hkeyPlaceArray
   put hkeyLine_GetPlaceArray() into hkeyPlaceArray
   put hkeyPlaceArray_ExtractDuplicates (hkeyPlaceArray) into duplicatePlaceArray
   
   put "Global | HkeyPlaceObject | Menu" into mTitle
   put empty into mLineTitle
   display_Array duplicatePlaceArray, "Duplicate hTableKeys,script_FetchHkeyPlaceArray()", mTitle, mLineTitle, "editHandler", "editHandler"
end menu_HkeyPlaceArrayDuplicates

on menu_FetchBigHkeyPlaceArray
   put script_FetchHkeyPlaceArray() into hkeyPlaceArray
   
   display_Array hkeyPlaceArray, "script_FetchHkeyPlaceArray()"
   put the result into indexView
   set the displayed_Object of indexView to scriptObject
end menu_FetchBigHkeyPlaceArray
