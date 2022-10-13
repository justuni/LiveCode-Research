script "libqrtlaf"
/*
Quartam Look And Feel Library for LiveCode [libqrtlaf.livecodescript]
Copyright (C) 2004-2018 Quartam Software / Jan Schenkel

This program is free software; you can redistribute it and/or modify 
it under the terms of the GNU Lesser General Public License as 
published by the Free Software Foundation, either version 3 of the 
License, or (at your option) any later version, with the following
clarification and special exception.

Linking this library statically or dynamically with other modules is
making a combined work based on this library. Thus, the terms and 
conditions of the GNU (Lesser) General Public License cover the whole
combination.

As a special exception, the copyright holders of this library give
you permission to link this library with independent modules to produce 
an executable, regardless of the license terms of these independent 
modules, and to copy and distribute the resulting executable under 
terms of your choice, provided that you also meet, for each linked 
independent module, the terms and conditions of the license of that 
module. An independent module is a module which is not derived from 
or based on this library. If you modify this library, you may extend 
this exception to your version of the library, but you are not 
obligated to do so. If you do not wish to do so, delete this exception 
statement from your version.

This program is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License 
along with this program.  If not, see <http://www.gnu.org/licenses>.
*/

--> script constants

constant kLibVersion = "1.0.0"
constant kLibErrorPrefix = "qrtlaferr: "

--> script local variables

local sMacOSVersion
local sWindowsVersion

--> engine message handlers

on libraryStack
   if the target is me then
      p_qrtLAF_InitLib
   end if
   pass libraryStack
end libraryStack

--> public commands and functions

function qrtLAF_Version
   return kLibVersion
end qrtLAF_Version

function qrtLAF_MacOSAppearance
   return p_qrtLAF_MacOS_Appearance()
end qrtLAF_MacOSAppearance

function qrtLAF_MacOSAquaColorVariant
   return p_qrtLAF_MacOS_AppleAquaColorVariant()
end qrtLAF_MacOSAquaColorVariant

function qrtLAF_MacOSDarkMenubarAndDock
   return p_qrtLAF_MacOS_DarkMenubarAndDock()
end qrtLAF_MacOSDarkMenubarAndDock

function qrtLAF_MacOSInterfaceStyle
   return p_qrtLAF_MacOS_AppleInterfaceStyle()
end qrtLAF_MacOSInterfaceStyle

function qrtLAF_MacOSShowScrollBars
   return p_qrtLAF_MacOS_AppleShowScrollbars()
end qrtLAF_MacOSShowScrollBars

function qrtLAF_WindowsColors
   return p_qrtLAF_Windows_Colors()
end qrtLAF_WindowsColors

function qrtLAF_WindowsThemeName
   return p_qrtLAF_Windows_ThemeName()
end qrtLAF_WindowsThemeName

--> private commands and functions

private command p_qrtLAF_InitLib
   local tSystemVersion
   put the systemVersion into tSystemVersion
   set the itemDelimiter to "."
   switch the platform
      case "MacOS"
         put format("%02d.%02d", item 1 of tSystemVersion, item 2 of tSystemVersion) into sMacOSVersion
         break
      case "Win32"
         put item 1 to 2 of (word -1 of tSystemVersion) into sWindowsVersion
         break
   end switch
end p_qrtLAF_InitLib

private function p_qrtLAF_MacOS_Appearance
   local tMacOSAppearance, tAppleAquaColorVariant
   put p_qrtLAF_MacOS_AppleAquaColorVariant() into tAppleAquaColorVariant
   switch tAppleAquaColorVariant
      case 1
         put "Blue" into tMacOSAppearance
         break
      case 6
         put "Graphite" into tMacOSAppearance
         break
      default
         put tAppleAquaColorVariant into tMacOSAppearance
         break
   end switch
   return tMacOSAppearance
end p_qrtLAF_MacOS_Appearance

private function p_qrtLAF_MacOS_AppleAquaColorVariant
   local tAppleAquaColorVariant
   if sMacOSVersion > 10 then
      put word 1 to -1 of shell("defaults read -g AppleAquaColorVariant") into tAppleAquaColorVariant
   end if
   return tAppleAquaColorVariant
end p_qrtLAF_MacOS_AppleAquaColorVariant

private function p_qrtLAF_MacOS_DarkMenubarAndDock pReRead
   local tMacOSDarkMenubarAndDock, tAppleInterfaceStyle
   put p_qrtLAF_MacOS_AppleInterfaceStyle() into tAppleInterfaceStyle
   put tAppleInterfaceStyle is "Dark" into tMacOSDarkMenubarAndDock
   return tMacOSDarkMenubarAndDock
end p_qrtLAF_MacOS_DarkMenubarAndDock

private function p_qrtLAF_MacOS_AppleInterfaceStyle
   local tAppleInterfaceStyle
   if sMacOSVersion > 10 then
      put word 1 to -1 of shell("defaults read -g AppleInterfaceStyle") into tAppleInterfaceStyle
   end if
   return tAppleInterfaceStyle
end p_qrtLAF_MacOS_AppleInterfaceStyle

private function p_qrtLAF_MacOS_AppleShowScrollBars
   local tAppleShowScrollBars
   if sMacOSVersion > 10 then
      put word 1 to -1 of shell("defaults read -g AppleShowScrollBars") into tAppleShowScrollBars
   end if
   return tAppleShowScrollBars
end p_qrtLAF_MacOS_AppleShowScrollBars

private function p_qrtLAF_Windows_Colors
   local tColorsA
   if sWindowsVersion is not empty then
      local tColorNames, tColorName, tColorRGB
      put   "ActiveBorder,ActiveTitle,AppWorkspace,Background," & \
            "ButtonAlternateFace,ButtonDkShadow,ButtonFace,ButtonHilight," & \
            "ButtonLight,ButtonShadow,ButtonText,GradientActiveTitle," & \
            "GradientInactiveTitle,GrayText,Hilight,HilightText," & \
            "HotTrackingColor,InactiveBorder,InactiveTitle,InactiveTitleText," & \
            "InfoText,InfoWindow,Menu,Menubar," & \
            "MenuHilight,MenuText,Scrollbar,TitleText," & \
            "Window,WindowFrame,WindowText" into tColorNames
      repeat for each item tColorName in tColorNames
         put queryRegistry("HKEY_CURRENT_USER\Control Panel\Colors\" & tColorName) into tColorRGB
         replace space with comma in tColorRGB
         put tColorRGB into tColorsA[tColorName]
      end repeat
   end if
   return tColorsA
end p_qrtLAF_Windows_Colors

private function p_qrtLAF_Windows_ThemeName
   local tThemeName
   if sWindowsVersion is not empty then
      local tThemeDllName
      put queryRegistry("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ThemeManager\DllName") into tThemeDllName
      if tThemeDllName is not empty then
         set the itemDelimiter to "\"
         put item -1 of tThemeDllName into tThemeName
         set the itemDelimiter to "."
         delete item -1 of tThemeName
      end if
   end if
   return tThemeName
end p_qrtLAF_Windows_ThemeName
