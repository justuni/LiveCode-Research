# livecode-quartam-laf-library

### Quartam Look And Feel Library for LiveCode

The source in script-only stack 'libqrtlaf.livecodescript' is licensed under the GNU Lesser General Public License version 3 and you can make adaptations of this work

![LGPLv3 logo](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/LGPLv3_Logo.svg/200px-LGPLv3_Logo.svg.png)

#### Features

 * Check macOS appearance settings
   * Appearance (Blue / Graphite)
   * Dark Menubar and Dock
   * Show Scrollbars
 * Check Windows appearance settings
   * Windows Colors
   * Windows XP Theme

#### Usage

##### Loading the script library

Add the library to the 'stackfiles' of your project's main stack.
Then load the library using the following command:

```livecode
start using stack "libqrtlaf"
```

##### Check macOS appearance settings from script

```livecode
if qrtLAF_MacOSAppearance() is "Graphite" then
  -- apply grayscales instead of blue colors
end if

if qrtLAF_MacOSDarkMenuAndDock() is true then
  -- make specific parts of the UI dark instead of light
end if

if qrtLAF_MacOSShowScrollbars() is "Always" then
  -- show horizontal and vertical scrollbars in custom control group
end if
```

##### Check Windows appearance settings from script

```livecode
if qrtLAF_WindowsThemeName is "luna" then
  -- apply UI design appropriate for Windows XP 'Luna' theme
end if

local tWindowsColorsA
put qrtLAF_WindowsColors() into tWindowsColorsA
set the foregroundColor of graphic "Hilite Rectangle" to tWindowsColorsA["ActiveBorder"]
```

#### Converting for use in LiveCode versions older than 6.7

The file 'libqrtosi.livecodescript' is a so-called 'script-only stack' - which means you'll need to convert it to one of the 'legacy' formats to use the library in older LiveCode versions.

 * Download LiveCode Community 6.7.11 from the [LiveCode Downloads](https://downloads.livecode.com/livecode/) page
 * Open the stack 'libqrtosi.livecodescript' in LiveCode Community 6.7.11
 * Save the stack as 'libqrtosi.livecode' in format 'Legacy LiveCode Stack (2.7)' if you want to use it in older versions 4.5.0 through 6.6.5
 * Or save the stack as 'libqrtosi.rev' in format 'Legacy LiveCode Stack (2.7)' if you want to use it in older versions 2.7.0 through 4.0.0
 * Or save the stack as 'libqrtosi.rev' in format 'Legacy LiveCode Stack (2.4)' if you want to use it in really old versions up to 2.6.1
