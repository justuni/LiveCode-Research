script "Global_Image_SVG_Menu"
--> MetaData
-
license: GPLv3
name: Global_Image_SVG_Menu
type: controller
version: 0.1


--> Menu | Props
-
getprop menu_Target
   put menu_GetTargetObject() into tObject
   put the svg_View of tObject into svgView
   if exists(svgView) is false then
      put the displayed_Object of tObject into svgView
   end if
   return svgView
end menu_Target


--> Global | Image | SVG | Menu
-
on menu_SvgTools svgView
   display_Index svgIndex, "SVG Tools", "Global | Image | SVG | Menu"
   put the result into indexView
   set the displayed_Object of indexView to svgView
end menu_SvgTools

on _
end _

on menu_DownloadAssets svgView
   put the project_Folder of svgView into projectFolder
   
   -- put "http://livecode.world/graphs/graph.html" into someUrl
   asset_DownloadHtml "http://livecode.world/graphs/graph.html", projectFolder
   asset_DownloadHtml "https://livecode.world/graphs/graphviz.html", projectFolder
   asset_DownloadHtml "http://js.cytoscape.org/demos/aedff159b0df05ccfaa5/", projectFolder, "cats.html"
end menu_DownloadAssets

on menu_DisplayAsset svgView, shortAssetFile
   put the project_Folder of svgView into projectFolder
   put asset_GetFile (projectFolder, shortAssetFile) into htmlFile
   put ("file:" & htmlFile) into someURL
   
   put the long id of control 1 of cd 1 of stack "View|Image|SVG" into svgView
   put url someURL into someHtml
   
   -- set the htmltext of svgView to someHtml
   set the url of svgView to htmlFile
   
   if the shiftKey is "Down" then
      put the htmltext of svgView
      display_Index someHtml
   end if
end menu_DisplayAsset

on _
end _

on menu_SetUrl svgView, whichUrl
   switch whichUrl
      case "Compound"
         put "http://livecode.world/graphs/graph.html" into someUrl
         break
      case "Paths"
         put "https://livecode.world/graphs/graphviz.html" into someUrl
         -- put "http://js.cytoscape.org/demos/6c9907e7896f8ae23f9f/" into someUrl
         break
      case "Huge"
         -- put "http://js.cytoscape.org/demos/57e7cc43342193d9d21a/" into someUrl
         put "http://js.cytoscape.org/demos/f64e811fc3311414e083/" into someUrl
         break
      case "Cats"
         put "http://js.cytoscape.org/demos/aedff159b0df05ccfaa5/" into someUrl
         break
      case "Wine"
         put "http://js.cytoscape.org/demos/cde4db55e581d10405f5/" into someURL
         break
      default
         answer file "Enter a url..."
         if it is empty then exit to top
         put it into someURL
   end switch
   -- put someURL
   set the url of svgView to someURL
end menu_SetUrl

on menu_ExportSvg svgView
   put the htmltext of svgView into someHTML
   put the svg_XML of svgView into someSVG
   put the svg_URL of svgView into svgURL
   
   answer folder "Choose a folder to export the html and svg..."
   if it is empty then exit to top
   
   put it into someFolder
   set the defaultfolder to someFolder
   
   set the itemdelimiter to slash
   put item -1 of svgURL into shortFile
   if char -4 to -1 of shortFile is not ".svg" then
      set the itemdelimiter to "."
      if the number of items of shortFile = 2 then delete item -1 of shortFile
      put ".svg" after shortFile
   end if
   put "file:" & shortFile into localSvgUrl
   
   put someHTML into url "file:index.html"
   put someSVG into url localSvgUrl
end menu_ExportSvg

on _
end _

on menu_FluidSvg svgView, someBoolean
   set the svg_IsFluid of svgView to someBoolean
end menu_FluidSvg

on _
end _

on submenu_Dev
   return "Dev | Menu"
end submenu_Dev


--> Global | Index | Simple | Menu | Props
-
getprop short_AssetFiles [svgView]
   put the project_Folder of svgView into projectFolder
   put asset_ListFiles (projectFolder, empty, true) into shortAssetFiles
   return shortAssetFiles
end short_AssetFiles

getprop fluid_Svg [svgView]
   put the svg_IsFluid of svgView into someBoolean
   return someBoolean
end fluid_Svg


--> Global | Index | Simple | Menu | Disabled
-


--> Dev | Menu
-
on menu_DisplaySvgFile svgView
   put the svg_File of svgView into svgFile
   set the svg_File of svgView to svgFile
   
   put scriptEditor_PaneObject ("Deps") into paneObject
   set the svg_File [true] of control 1 of paneObject to imageFile
   
   put the svg_File [true] of control 1 of paneObject & CR & svgFile
end menu_DisplaySvgFile

on menu_DisplaySvgHeader svgView
   put the svg_HeaderArray of svgView into svgHeaderArray
   display_Array svgHeaderArray
end menu_DisplaySvgHeader

on menu_DisplaySvgxml svgView
   put the svg_XML of svgView
end menu_DisplaySvgxml

on _
end _

on menu_DeleteHeaderKey svgView, headerType
   put the svg_HeaderArray of svgView into svgHeaderArray
   delete variable svgHeaderArray [headerType]
   set the svg_HeaderArray of svgView to svgHeaderArray
end menu_DeleteHeaderKey

on menu_SetScale svgView
   put the svg_Scale of svgView into svgScale
   put lcw_Ask ("Change the scale of the svg view?", svgScale) into svgScale
   set the svg_Scale of svgView to svgScale
end menu_SetScale

on _
end _

on menu_EditSvgBehavior svgView
   put the behavior of svgView into bObject
   edit the script of bObject
end menu_EditSvgBehavior

on _
end _

on menu_DisplayProcessedHkeyArray svgView
   put the textStack_HkeyArray of scriptObject into processedHkeyArray  
   display_Array processedHkeyArray, "processedHkeyArray"
end menu_DisplayProcessedHkeyArray

on menu_DisplayControllerGraph scriptObject
   put the project_MetadataFolder of scriptObject & CR after folderInfo
   
   put folderInfo
   
   -- put overlay_GetImageFile (overlayFolder, "HAP")
end menu_DisplayControllerGraph

-- on menu_DependencyObjects scriptObject
-- put the missing_HkeyArray of scriptObject into missingHkeyArray
put the dep_StackNames of scriptObject into depStackNames
end menu_DependencyObjects

on _
end _

on menu_RevealSvgFile svgView
   put the svg_File of svgView into svgFile
   finder_Reveal svgFile
end menu_RevealSvgFile

on menu_RevealHkeyOverlayFolder svgView
   put the displayed_Hkey of svgView into hKey
   put project_HandlerMetadataFolder (hKey, true) into hkeyMetadataFolder
   put "put project_HandlerMetadataFolder (hKey):" && hkeyMetadataFolder
   finder_Reveal hkeyMetadataFolder
end menu_RevealHkeyOverlayFolder

on menu_RevealProjectOverlayFolder svgView
   put the displayed_Object of svgView into scriptObject
   put the project_OverlayFolder of scriptObject into projectOverlayFolder
   put "the project_OverlayFolder:" && projectOverlayFolder
   finder_Reveal projectOverlayFolder
end menu_RevealProjectOverlayFolder

on menu_RevealStackOverlayFolder svgView
   put the displayed_Object of svgView into scriptObject
   put the overlay_Folder of scriptObject into overlayFolder
   put "the overlay_Folder:" && overlayFolder
   finder_Reveal overlayFolder
end menu_RevealStackOverlayFolder

on menu_RevealTextStackFolder svgView
   put the displayed_Object of svgView into scriptObject
   put the textStack_Folder of scriptObject into textStackFolder
   put "the textStack_Folder:" && textStackFolder
   finder_Reveal textStackFolder
end menu_RevealTextStackFolder



--> Dev | Menu | Props
-
getprop header_Types [svgView]
   -- strange bug trying to set this to header_Keys, or some_Keys
   put the svg_HeaderArray of svgView into svgHeaderArray
   return keys (svgHeaderArray)
end header_Types
