#!/bin/sh
# MetaCard 2.3 stack
# The following is not ASCII text,
# so now would be a good time to q out of more
exec mc $0 "$@"
                                                                                                                                  ? 
libString 3 ?3?---== FILE INFORMATION ==---------------------------------------------------------------------------------------------------------
# Library......: libString
# Description..: functions to do common tasks to strings
# File Name....: libString 1.0.0
# Build Date...: 2002.08.26.1
# Authour......: Shao Sean <shaosean@unitz.ca>
# Website......: http://www.shaosean.tk/

---== DISCLAIMER ==---------------------------------------------------------------------------------------------------------------
# This software is released into the public domain.

# You may not claim this software as your own, but you may modify it and release
# modified versions of the software, so long as it is clearly marked as a modified
# work, has contact information and includes the contact information marked in the
# "FILE INFORMATION" section above.

# You are hereby granted an unrestricted license for it's use.

# Use of this software, whether in full or part, may be incorporated into any other
# software, including commerical for-profit software, free of charge.

# Use of this software, whether in full or part, acknowledges that you hereby release
# the authour from any liability from any damages, whether direct or indirect.

# You may not use this software in conjunction with plans to take over the world.

# You may contact the original authour of the software in regards to any "bugs", or
# code optimizations that you want addressed.

---== LIST OF PUBLIC FUNCTIONS ==-------------------------------------------------------------------------------------------------
# libString_pad                   - Pad a string to a certain length with another string
# libString_ltrim                 - Strip whitespace from the beginning of a string
# libString_rtrim                 - Strip whitespace from the end of a string
# libString_trim                  - Strip whitespace from the beginning and end of a string
# libString_explode               - Splits a string into an array
# libString_quotedPrintableEncode - Convert an 8-bit string to a quoted-printable string
# libString_repeat                - Repeat a string
# libString_reverse               - Reverses a string
# libString_wrap                  - Wraps a string to lines of specified lengths


##################################################################################################################################


function libString_pad inputString, padLength
  # Syntax...: libString_pad input padLength [padString]
  # Details..: This function returns the input string padded on the right side to the specified padding length.
  #          : If the optional padString parameter is not supplied the input is padded with spaces, otherwise it is
  #          : padded with characters from padString up to the padLength.
  #          : If the value of padLength is negative or less than the length of the input string, no padding takes place.
  # Defaults.: padString = SPACE
  local padString
  -- if it's a negative number or less than the input string, no padding is done
  if ((padLength < 0) OR (padLength < the number of chars of inputString)) then
    return inputString
  end if
  -- check if the optional padString was passed
  if (paramCount() = 2) then
    put SPACE into padString  -- no padString passed so use the default
  else
    put param(3) into padString  -- use the padString passed
  end if
  -- added the padString to the input string until the the string is equal to or greater than the padLength
  repeat until the number of chars of inputString >= padLength
    put padString after inputString
  end repeat
  -- return the new string of length padLength
  return (char 1 to padLength of inputString)
end libString_pad


##################################################################################################################################


function libString_ltrim inputString
  # Syntax...: libString_ltrim inputString [charlist]
  # Details..: This function returns a string with whitespace stripped from the beginning of the inputString.
  #          : Without the second parameter the following characters will get stripped:
  #          :   SPACE (ASCII 32 (0x20)), an ordinary space
  #          :   TAB   (ASCII  9 (0x09)), a tab
  #          :   LF    (ASCII 10 (0x0A)), a new line (linefeed)
  #          :   CR    (ASCII 13 (0x0D)), a carriage return
  #          :   NUL   (ASCII  0 (0x00)), a NUL-byte
  #          :         (ASCII 11 (0x0B)), a vertical tab
  #          : You can also specify additional characters you want to strip by passing a comma delimited list as the optional
  #          : second parameter (charlist).
  local charlist
  put SPACE & COMMA & TAB & COMMA & LF & COMMA & CR & COMMA & numToChar(0) & COMMA & numToChar(11) into charlist
  -- check to see if there was additional characters passed to be added to the charlist
  if (paramCount() = 2) then
    put COMMA & param(2) after charlist
  end if
  -- trim off the extra characters
  repeat
    if (char 1 of inputString is among the items of charlist) then
      delete char 1 of inputString
    else
      exit repeat
    end if
  end repeat
  return inputString
end libString_ltrim


##################################################################################################################################


function libString_rtrim inputString
  # Syntax...: libString_rtrim inputString [charlist]
  # Details..: This function returns a string with whitespace stripped from the end of the inputString.
  #          : Without the second parameter the following characters will get stripped:
  #          :   SPACE (ASCII 32 (0x20)), an ordinary space
  #          :   TAB   (ASCII  9 (0x09)), a tab
  #          :   LF    (ASCII 10 (0x0A)), a new line (linefeed)
  #          :   CR    (ASCII 13 (0x0D)), a carriage return
  #          :   NUL   (ASCII  0 (0x00)), a NUL-byte
  #          :         (ASCII 11 (0x0B)), a vertical tab
  #          : You can also specify additional characters you want to strip by passing a comma delimited list as the optional
  #          : second parameter (charlist).
  local charlist
  put SPACE & COMMA & TAB & COMMA & LF & COMMA & CR & COMMA & numToChar(0) & COMMA & numToChar(11) into charlist
  -- check to see if there was additional characters passed to be added to the charlist
  if (paramCount() = 2) then
    put COMMA & param(2) after charlist
  end if
  -- trim off the extra characters
  repeat
    if (char -1 of inputString is among the items of charlist) then
      delete char -1 of inputString
    else
      exit repeat
    end if
  end repeat
  return inputString
end libString_rtrim


##################################################################################################################################


function libString_trim inputString
  # Syntax...: libString_trim inputString [charlist]
  # Details..: This function returns a string with whitespace stripped from the beginning and end of the inputString.
  #          : Without the second parameter the following characters will get stripped:
  #          :   SPACE (ASCII 32 (0x20)), an ordinary space
  #          :   TAB   (ASCII  9 (0x09)), a tab
  #          :   LF    (ASCII 10 (0x0A)), a new line (linefeed)
  #          :   CR    (ASCII 13 (0x0D)), a carriage return
  #          :   NUL   (ASCII  0 (0x00)), a NUL-byte
  #          :         (ASCII 11 (0x0B)), a vertical tab
  #          : You can also specify additional characters you want to strip by passing a comma delimited list as the optional
  #          : second parameter (charlist).
  local charlist
  -- check to see if there was additional characters passed to be added to the charlist
  if (paramCount() = 2) then
    put SPACE & COMMA & TAB & COMMA & LF & COMMA & CR & COMMA & numToChar(0) & COMMA & numToChar(11) & COMMA & param(2) into charlist
    return libString_ltrim(libString_rtrim(inputString,charlist),charlist)
  else
    return libString_ltrim(libString_rtrim(inputString))
  end if
end libString_trim


##################################################################################################################################


function libString_explode inputString
  # Syntax...: libString_explode inputString [separator]
  # Details..: Returns an array of strings, each containing the item of the inputString formed by splitting in on boundaries
  #          : formed by the separator.
  # Defaults.: separator = COMMA
  local inputStringItem, inputStringArray, i
  -- check if the optional separator parameter was passed
  if (paramCount() = 2) then
    set the itemDelimiter to param(2)
  end if
  -- go through each item in the inputString and create an array containing the items
  put 0 into i
  repeat for each item inputStringItem in inputString
    put inputStringItem into inputStringArray[i]
    add 1 to i
  end repeat
  return inputStringArray
end libString_explode


##################################################################################################################################


function libString_quotedPrintableEncode inputString
  # Syntax...: libString_quotedPrintableEncode inputString
  # Details..: This function converts an 8-bit binary string into a quoted-printable string.
  local inputStringChar, quotedPrintableString
  replace "=" with "=3D" in inputString
  -- check each character to see if they need to be encoded
  repeat for each char inputStringChar in inputString
    if (charToNum(inputStringChar) > 127) then
      put "=" & toUpper(baseConvert(charToNum(inputStringChar),10,16)) after quotedPrintableString  -- encode the character
    else
      put inputStringChar after quotedPrintableString
    end if
  end repeat
  return quotedPrintableString
end libString_quotedPrintableEncode


##################################################################################################################################


function libString_repeat inputString, multipler
  # Syntax...: libString inputString, multipler
  # Details..: Returns a string containing the inputString repeated multipler times.
  #          : If multipler is a negative or zero, the function will return an empty string
  local repeatedString, i
  -- check if the multipler is negative or zero
  if (multipler <= 0) then
    return EMPTY
  end if
  -- repeat the string
  repeat for multipler times
    put inputString after repeatedString
  end repeat
  return repeatedString
end libString_repeat


##################################################################################################################################


function libString_reverse inputString
  # Syntax...: libString_reverse inputString
  # Details..: Returns the inputString reversed
  local inputStringChar, reversedString
  repeat for each char inputStringChar in inputString
    put inputStringChar before reversedString
  end repeat
  return reversedString
end libString_reverse


##################################################################################################################################


function libString_wrap inputString
  # Syntax...: libString_wrap inputString [wrapLength] [wrapString]
  # Details..: Returns the inputString wrapped at the character number specified by the wrapLength parameter.
  #          : Passing the wrapString parameter will append it to the string after the wrapLength (so it'll add extra chars to the length)
  # Defaults.: wrapLength = 75
  #          : wrapString = LINEFEED
  local wrapLength, wrapString, inputStringChar, inputStringLine, wrappedString, tempString
  put 75 into wrapLength
  put LINEFEED into wrapString
  -- check if the optional parameters are passed or if we need to use the defaults
  if (paramCount() = 2) then
    if (param(2) is a number) then
      put param(2) into wrapLength
    else
      put param(2) into wrapString
    end if
  else if (paramCount() = 3) then
    put param(2) into wrapLength
    put param(3) into wrapString
  end if
  -- check each line in the inputString to wrap it
  repeat for each line inputStringLine in inputString
    -- if the line is empty just add it to the wrappedString
    if (inputStringLine is empty) then
      put wrapString after wrappedString
      next repeat
    end if
    -- if the line is shorter or equal to the wrap length just add it to the wrappedString
    if (the number of chars in inputStringLine <= wrapLength) then
      put inputStringLine & wrapString after wrappedString
      next repeat
    end if
    -- line is longer than the wrapLength so we'll need to wrap it
    repeat
      if (the number of chars in inputStringLine > wrapLength) then
        put char 1 to wrapLength of inputStringLine into tempString
--        if (tempString contains SPACE) then
--          delete the last word of tempString
--          delete char -1 of inputStringLine
--        end if
        delete char 1 to (the number of chars in tempString) of inputStringLine
        put tempString & wrapString after wrappedString
        next repeat
      end if
      -- line is shorter or equal to the wrapLength now
      put inputStringLine & wrapString after wrappedString
      exit repeat
    end repeat
  end repeat
  return wrappedString
end libString_wrap
     ?  z N?0             libString v1.0.0 (2002.08.26)     ????    
 U Courier   U Courier   W Courier  cREVGeometryCache    stackID  1005 cREVGeneral    scriptChecksum  ?O??ao????=?LC?
bookmarks   handlerList  ?libString_pad
libString_ltrim
libString_rtrim
libString_trim
libString_explode
libString_quotedPrintableEncode
libString_repeat
libString_reverse
libString_wraptempScript   prevHandler  libString_explodescriptSelection  char 11066 to 11065script _?<FONT color="#68228B">---== FILE INFORMATION ==---------------------------------------------------------------------------------------------------------</FONT>
<P><FONT color="#68228B"># Library......: libString</FONT>
<P><FONT color="#68228B"># Description..: functions to do common tasks to strings</FONT>
<P><FONT color="#68228B"># File Name....: libString 1.0.0</FONT>
<P><FONT color="#68228B"># Build Date...: 2002.08.26.1</FONT>
<P><FONT color="#68228B"># Authour......: Shao Sean &lt;shaosean@unitz.ca&gt;</FONT>
<P><FONT color="#68228B"># Website......: http://www.shaosean.tk/</FONT>
<P>
<P><FONT color="#68228B">---== DISCLAIMER ==---------------------------------------------------------------------------------------------------------------</FONT>
<P><FONT color="#68228B"># This software is released into the public domain.</FONT>
<P>
<P><FONT color="#68228B"># You may not claim this software as your own, but you may modify it and release</FONT>
<P><FONT color="#68228B"># modified versions of the software, so long as it is clearly marked as a modified</FONT>
<P><FONT color="#68228B"># work, has contact information and includes the contact information marked in the</FONT>
<P><FONT color="#68228B"># "FILE INFORMATION" section above.</FONT>
<P>
<P><FONT color="#68228B"># You are hereby granted an unrestricted license for it's use.</FONT>
<P>
<P><FONT color="#68228B"># Use of this software, whether in full or part, may be incorporated into any other</FONT>
<P><FONT color="#68228B"># software, including commerical for-profit software, free of charge.</FONT>
<P>
<P><FONT color="#68228B"># Use of this software, whether in full or part, acknowledges that you hereby release</FONT>
<P><FONT color="#68228B"># the authour from any liability from any damages, whether direct or indirect.</FONT>
<P>
<P><FONT color="#68228B"># You may not use this software in conjunction with plans to take over the world.</FONT>
<P>
<P><FONT color="#68228B"># You may contact the original authour of the software in regards to any "bugs", or</FONT>
<P><FONT color="#68228B"># code optimizations that you want addressed.</FONT>
<P>
<P><FONT color="#68228B">---== LIST OF PUBLIC FUNCTIONS ==-------------------------------------------------------------------------------------------------</FONT>
<P><FONT color="#68228B"># libString_pad                   - Pad a string to a certain length with another string</FONT>
<P><FONT color="#68228B"># libString_ltrim                 - Strip whitespace from the beginning of a string</FONT>
<P><FONT color="#68228B"># libString_rtrim                 - Strip whitespace from the end of a string</FONT>
<P><FONT color="#68228B"># libString_trim                  - Strip whitespace from the beginning and end of a string</FONT>
<P><FONT color="#68228B"># libString_explode               - Splits a string into an array</FONT>
<P><FONT color="#68228B"># libString_quotedPrintableEncode - Convert an 8-bit string to a quoted-printable string</FONT>
<P><FONT color="#68228B"># libString_repeat                - Repeat a string</FONT>
<P><FONT color="#68228B"># libString_reverse               - Reverses a string</FONT>
<P><FONT color="#68228B"># libString_wrap                  - Wraps a string to lines of specified lengths</FONT>
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function<FONT color="#980517"> </FONT>libString_pad inputString, padLength
<P><FONT color="#68228B">  # Syntax...: libString_pad input padLength [padString]</FONT>
<P><FONT color="#68228B">  # Details..: This function returns the input string padded on the right side to the specified padding length.</FONT>
<P><FONT color="#68228B">  #          : If the optional padString parameter is not supplied the input is padded with spaces, otherwise it is</FONT>
<P><FONT color="#68228B">  #          : padded with characters from padString up to the padLength.</FONT>
<P><FONT color="#68228B">  #          : If the value of padLength is negative or less than the length of the input string, no padding takes place.</FONT>
<P><FONT color="#68228B">  # Defaults.: padString = SPACE</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">local </FONT>padString
<P>  <FONT color="#68228B">-- if it's a negative number or less than the input string, no padding is done</FONT>
<P>  <FONT color="#980517">if </FONT>((padLength &lt; 0) OR (padLength &lt; the <FONT color="#FF0000">number </FONT>of chars of inputString)) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">return </FONT>inputString
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#68228B">-- check if the optional padString was passed</FONT>
<P><FONT color="#980517">  if</FONT> (paramCount() = 2) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">put </FONT>SPACE into padString  <FONT color="#68228B">-- no padString passed so use the default</FONT>
<P>  <FONT color="#980517">else</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">put </FONT>param(3) into padString  <FONT color="#68228B">-- use the padString passed</FONT>
<P>  <FONT color="#980517">end if</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#68228B">-- added the padString to the input string until the the string is equal to or greater than the padLength</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">repeat </FONT>until the <FONT color="#FF0000">number </FONT>of chars of inputString &gt;= padLength
<P>    <FONT color="#0000FF">put </FONT>padString after inputString
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#68228B">-- return the new string of length padLength</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">return </FONT>(char 1 to padLength of inputString)
<P><FONT color="#980517">end</FONT> libString_pad
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function libString_ltrim inputString
<P>  <FONT color="#68228B"># Syntax...: libString_ltrim inputString [charlist]</FONT>
<P><FONT color="#68228B">  # Details..: This function returns a string with whitespace stripped from the beginning of the inputString.</FONT>
<P>  <FONT color="#68228B">#          : Without the second parameter the following characters will get stripped:</FONT>
<P><FONT color="#68228B">  #          :   SPACE (ASCII 32 (0x20)), an ordinary space</FONT>
<P><FONT color="#68228B">  #          :   TAB   (ASCII  9 (0x09)), a tab</FONT>
<P><FONT color="#68228B">  #          :   LF    (ASCII 10 (0x0A)), a new line (linefeed)</FONT>
<P><FONT color="#68228B">  #          :   CR    (ASCII 13 (0x0D)), a carriage return</FONT>
<P><FONT color="#68228B">  #          :   NUL   (ASCII  0 (0x00)), a NUL-byte</FONT>
<P><FONT color="#68228B">  #          :         (ASCII 11 (0x0B)), a vertical tab</FONT>
<P>  <FONT color="#68228B">#          : You can also specify additional characters you want to strip by passing a comma delimited list as the optional</FONT>
<P><FONT color="#68228B">  #          : second parameter (charlist).</FONT>
<P>  <FONT color="#0000FF">local </FONT>charlist
<P>  <FONT color="#0000FF">put </FONT>SPACE &amp; COMMA &amp; TAB &amp; COMMA &amp; LF &amp; COMMA &amp; CR &amp; COMMA &amp; numToChar(0) &amp; COMMA &amp; numToChar(11) into charlist
<P>  <FONT color="#68228B">-- check to see if there was additional characters passed to be added to the charlist</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">if </FONT>(paramCount() = 2) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">put</FONT> COMMA &amp; param(2) after charlist
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#68228B">-- trim off the extra characters</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">    if</FONT> (char 1 of inputString is among the items of charlist) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">delete </FONT>char 1 of inputString
<P>    <FONT color="#980517">else</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">exit</FONT> <FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">    end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  end repeat</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#0000FF">return</FONT> inputString
<P><FONT color="#980517">end</FONT> libString_ltrim
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function libString_rtrim inputString
<P>  <FONT color="#68228B"># Syntax...: libString_rtrim inputString [charlist]</FONT>
<P><FONT color="#68228B">  # Details..: This function returns a string with whitespace stripped from the end of the inputString.</FONT>
<P>  <FONT color="#68228B">#          : Without the second parameter the following characters will get stripped:</FONT>
<P><FONT color="#68228B">  #          :   SPACE (ASCII 32 (0x20)), an ordinary space</FONT>
<P><FONT color="#68228B">  #          :   TAB   (ASCII  9 (0x09)), a tab</FONT>
<P><FONT color="#68228B">  #          :   LF    (ASCII 10 (0x0A)), a new line (linefeed)</FONT>
<P><FONT color="#68228B">  #          :   CR    (ASCII 13 (0x0D)), a carriage return</FONT>
<P><FONT color="#68228B">  #          :   NUL   (ASCII  0 (0x00)), a NUL-byte</FONT>
<P><FONT color="#68228B">  #          :         (ASCII 11 (0x0B)), a vertical tab</FONT>
<P>  <FONT color="#68228B">#          : You can also specify additional characters you want to strip by passing a comma delimited list as the optional</FONT>
<P><FONT color="#68228B">  #          : second parameter (charlist).</FONT>
<P>  <FONT color="#0000FF">local </FONT>charlist
<P>  <FONT color="#0000FF">put </FONT>SPACE &amp; COMMA &amp; TAB &amp; COMMA &amp; LF &amp; COMMA &amp; CR &amp; COMMA &amp; numToChar(0) &amp; COMMA &amp; numToChar(11) into charlist
<P>  <FONT color="#68228B">-- check to see if there was additional characters passed to be added to the charlist</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">if </FONT>(paramCount() = 2) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">put</FONT> COMMA &amp; param(2) after charlist
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#68228B">-- trim off the extra characters</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">    if</FONT> (char -1 of inputString is among the items of charlist) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">delete </FONT>char -1 of inputString
<P>    <FONT color="#980517">else</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">exit</FONT> <FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">    end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  end repeat</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#0000FF">return</FONT> inputString
<P><FONT color="#980517">end</FONT> libString_rtrim
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function libString_trim inputString
<P>  <FONT color="#68228B"># Syntax...: libString_trim inputString [charlist]</FONT>
<P><FONT color="#68228B">  # Details..: This function returns a string with whitespace stripped from the beginning and end of the inputString.</FONT>
<P>  <FONT color="#68228B">#          : Without the second parameter the following characters will get stripped:</FONT>
<P><FONT color="#68228B">  #          :   SPACE (ASCII 32 (0x20)), an ordinary space</FONT>
<P><FONT color="#68228B">  #          :   TAB   (ASCII  9 (0x09)), a tab</FONT>
<P><FONT color="#68228B">  #          :   LF    (ASCII 10 (0x0A)), a new line (linefeed)</FONT>
<P><FONT color="#68228B">  #          :   CR    (ASCII 13 (0x0D)), a carriage return</FONT>
<P><FONT color="#68228B">  #          :   NUL   (ASCII  0 (0x00)), a NUL-byte</FONT>
<P><FONT color="#68228B">  #          :         (ASCII 11 (0x0B)), a vertical tab</FONT>
<P>  <FONT color="#68228B">#          : You can also specify additional characters you want to strip by passing a comma delimited list as the optional</FONT>
<P><FONT color="#68228B">  #          : second parameter (charlist).</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">local </FONT>charlist
<P>  <FONT color="#68228B">-- check to see if there was additional characters passed to be added to the charlist</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">if </FONT>(paramCount() = 2) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">put </FONT>SPACE &amp; COMMA &amp; TAB &amp; COMMA &amp; LF &amp; COMMA &amp; CR &amp; COMMA &amp; numToChar(0) &amp; COMMA &amp; numToChar(11) &amp; COMMA &amp; param(2) into charlist
<P>    <FONT color="#0000FF">return </FONT>libString_ltrim(libString_rtrim(inputString,charlist),charlist)
<P>  <FONT color="#980517">else</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">return</FONT> libString_ltrim(libString_rtrim(inputString))
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">end</FONT> libString_trim
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function libString_explode inputString
<P>  <FONT color="#68228B"># Syntax...: libString_explode inputString [separator]</FONT>
<P><FONT color="#68228B">  # Details..: Returns an array of strings, each containing the item of the inputString formed by splitting in on boundaries</FONT>
<P><FONT color="#68228B">  #          : formed by the separator.</FONT>
<P><FONT color="#68228B">  # Defaults.: separator = COMMA</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">local </FONT>inputStringItem, inputStringArray, i
<P>  <FONT color="#68228B">-- check if the optional separator parameter was passed</FONT>
<P>  <FONT color="#980517">if</FONT> (paramCount() = 2) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">set </FONT>the <FONT color="#FF0000">itemDelimiter </FONT>to param(2)
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#68228B">-- go through each item in the inputString and create an array containing the items</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">put</FONT> 0 into i
<P><FONT color="#68228B">  </FONT><FONT color="#980517">repeat for </FONT>each item inputStringItem in inputString
<P>    <FONT color="#0000FF">put </FONT>inputStringItem into inputStringArray[i]
<P>    <FONT color="#0000FF">add</FONT> 1 to i
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#0000FF">return</FONT> inputStringArray
<P><FONT color="#980517">end</FONT> libString_explode
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function libString_quotedPrintableEncode inputString
<P>  <FONT color="#68228B"># Syntax...: libString_quotedPrintableEncode inputString</FONT>
<P><FONT color="#68228B">  # Details..: This function converts an 8-bit binary string into a quoted-printable string.</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">local </FONT>inputStringChar, quotedPrintableString
<P>  <FONT color="#0000FF">replace </FONT>"=" <FONT color="#980517">with </FONT>"=3D" in inputString
<P>  <FONT color="#68228B">-- check each character to see if they need to be encoded</FONT>
<P>  <FONT color="#980517">repeat for </FONT>each char inputStringChar in inputString
<P>    <FONT color="#980517">if </FONT>(charToNum(inputStringChar) &gt; 127) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">put </FONT>"=" &amp; toUpper(baseConvert(charToNum(inputStringChar),10,16)) after quotedPrintableString  <FONT color="#68228B">-- encode the character</FONT>
<P>    <FONT color="#980517">else</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">put </FONT>inputStringChar after quotedPrintableString
<P>    <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">repeat</FONT>
<P>  <FONT color="#0000FF">return </FONT>quotedPrintableString
<P>end libString_quotedPrintableEncode
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function libString_repeat inputString, multipler
<P>  <FONT color="#68228B"># Syntax...: libString inputString, multipler</FONT>
<P><FONT color="#68228B">  # Details..: Returns a string containing the inputString repeated multipler times.</FONT>
<P><FONT color="#68228B">  #          : If multipler is a negative or zero, the function will return an empty string</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">local</FONT> repeatedString, i
<P>  <FONT color="#68228B">-- check if the multipler is negative or zero</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">if </FONT>(multipler &lt;= 0) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">return </FONT>EMPTY
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#68228B">-- repeat the string</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">repeat for </FONT>multipler times
<P>    <FONT color="#0000FF">put </FONT>inputString after repeatedString
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">repeat</FONT>
<P>  <FONT color="#0000FF">return</FONT> repeatedString
<P><FONT color="#980517">end</FONT> libString_repeat
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function libString_reverse inputString
<P>  <FONT color="#68228B"># Syntax...: libString_reverse inputString</FONT>
<P><FONT color="#68228B">  # Details..: Returns the inputString reversed</FONT>
<P>  <FONT color="#0000FF">local </FONT>inputStringChar, reversedString
<P>  <FONT color="#980517">repeat for </FONT>each char inputStringChar in inputString
<P>    <FONT color="#0000FF">put </FONT>inputStringChar before reversedString
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">repeat</FONT>
<P>  <FONT color="#0000FF">return</FONT> reversedString
<P><FONT color="#980517">end</FONT> libString_reverse
<P>
<P>
<P><FONT color="#68228B">##################################################################################################################################</FONT>
<P>
<P>
<P>function libString_wrap inputString
<P>  <FONT color="#68228B"># Syntax...: libString_wrap inputString [wrapLength] [wrapString]</FONT>
<P><FONT color="#68228B">  # Details..: Returns the inputString wrapped at the character number specified by the wrapLength parameter.</FONT>
<P><FONT color="#68228B">  #          : Passing the wrapString parameter will append it to the string after the wrapLength (so it'll add extra chars to the length)</FONT>
<P><FONT color="#68228B">  # Defaults.: wrapLength = 75</FONT>
<P><FONT color="#68228B">  #          : wrapString = LINEFEED</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">local </FONT>wrapLength, wrapString, inputStringChar, inputStringLine, wrappedString, tempString
<P>  <FONT color="#0000FF">put </FONT>75 into wrapLength
<P>  <FONT color="#0000FF">put </FONT>LINEFEED into wrapString
<P>  <FONT color="#68228B">-- check if the optional parameters are passed or if we need to use the defaults</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">if </FONT>(paramCount() = 2) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    if </FONT>(param(2) is a number) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">put </FONT>param(2) into wrapLength
<P>    <FONT color="#980517">else</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">put </FONT>param(2) into wrapString
<P>    <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  else if </FONT>(paramCount() = 3) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#0000FF">put </FONT>param(2) into wrapLength
<P>    <FONT color="#0000FF">put </FONT>param(3) into wrapString
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">  </FONT><FONT color="#68228B">-- check each line in the inputString to wrap it</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#980517">repeat for </FONT>each line inputStringLine in inputString
<P>    <FONT color="#68228B">-- if the line is empty just add it to the wrappedString</FONT>
<P><FONT color="#68228B">    </FONT><FONT color="#980517">if</FONT> (inputStringLine is empty) <FONT color="#980517">then</FONT>
<P><FONT color="#0000FF">      put </FONT>wrapString after wrappedString
<P><FONT color="#0000FF">      next </FONT><FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">    end if</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#68228B">-- if the line is shorter or equal to the wrap length just add it to the wrappedString</FONT>
<P><FONT color="#68228B">    </FONT><FONT color="#980517">if</FONT> (the <FONT color="#FF0000">number </FONT>of chars in inputStringLine &lt;= wrapLength) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#0000FF">put </FONT>inputStringLine &amp; wrapString after wrappedString
<P>      <FONT color="#0000FF">next</FONT> <FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">    end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">    </FONT><FONT color="#68228B">-- line is longer than the wrapLength so we'll need to wrap it</FONT>
<P><FONT color="#68228B">    </FONT><FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">      if</FONT> (the <FONT color="#FF0000">number </FONT>of chars in inputStringLine &gt; wrapLength) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">        </FONT><FONT color="#0000FF">put </FONT>char 1 to wrapLength of inputStringLine into tempString
<P>--        <FONT color="#980517">if</FONT> (tempString contains SPACE) <FONT color="#980517">then</FONT>
<P><FONT color="#980517">--          </FONT><FONT color="#0000FF">delete </FONT>the last word of tempString
<P>--          <FONT color="#0000FF">delete </FONT>char -1 of inputStringLine
<P>--        <FONT color="#980517">end if</FONT>
<P>        <FONT color="#0000FF">delete </FONT>char 1 to (the <FONT color="#FF0000">number </FONT>of chars in tempString) of inputStringLine
<P><FONT color="#980517">        </FONT><FONT color="#0000FF">put </FONT>tempString &amp; wrapString after wrappedString
<P>        <FONT color="#0000FF">next</FONT> <FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">      end</FONT> <FONT color="#980517">if</FONT>
<P><FONT color="#980517">      </FONT><FONT color="#68228B">-- line is shorter or equal to the wrapLength now</FONT>
<P><FONT color="#68228B">      </FONT><FONT color="#0000FF">put </FONT>inputStringLine &amp; wrapString after wrappedString
<P>      <FONT color="#0000FF">exit </FONT><FONT color="#980517">repeat</FONT>
<P><FONT color="#980517">    end repeat</FONT>
<P>  <FONT color="#980517">end</FONT> <FONT color="#980517">repeat</FONT>
<P><FONT color="#68228B">  </FONT><FONT color="#0000FF">return </FONT>wrappedString
<P><FONT color="#980517">end</FONT> libString_wrap
<P>  ?    	@    ?     ?0     cREVGeometryCacheIDs    1030407139729  1004 cREVGeometryCache    total  1order  1030407139729
 cREVGeneral    
bookmarks   handlerList   tempScript   prevHandler   scriptSelection  char 1 to 0  ?
  ? New Field 1 ??h  
         Black ?  
 
?           cREVGeometry    Master,scaleBottomObjectSide  centerMaster  trueMaster,scaletopObjectRef   Master,scaleLeftObjectRef  cardMaster,scaleBottomObjectRef  cardMaster,scaleBottomAbsolute  falseMaster,scaleBottom  trueMaster,scaleTopObjectSide  centerMaster,scaleLeftObjectSide  centerMaster,scalebottomDistance  0.46Master,expectedRect  10,10,490,288Master,scaleRightAbsolute  falseMaster,scaleRight  trueMaster,scalerightDistance  0.48Master,scaleLeftAbsolute  falseMaster,scaleRightObjectSide  centerMaster,scaleRightObjectRef  cardMaster,scaleTopAbsolute  falseMaster,scaleLeft  trueMaster,scaleTop  falseMaster,cardRanking  3Master,scaletopDistance  0Master,scaleleftDistance  -0.48 cREVGeneral    revUniqueID  1030407139729  ? 	Function   @           libString_pad   @           Description   @           5Pad a string to a certain length with another string   @          4 Syntax   @           0libString_pad inputString padLength [padString]   @          / Parameters   @          
 /inputString - the string to add the padding to   @          . .padLength   - the length of the padded string   @          - PpadString   - the optional string to add to the inputString (defaults to SPACE)   @          O     	Function   @           libString_ltrim   @           Description   @           0Strip whitespace from the beginning of a string   @          / Syntax   @           'libString_ltrim inputString [charlist]   @          & Parameters   @          
 !inputString - the string to trim   @            Pcharlist    - an optional comma-delimited list of additional characters to trim   @          O Notes   @           ;Trims spaces, tabs, line feeds, carriage returns and nulls   @          :     	Function   @           libString_rtrim   @           Description   @           *Strip whitespace from the end of a string   @          ) Syntax   @           'libString_rtrim inputString [charlist]   @          & Parameters   @          
 !inputString - the string to trim   @            Pcharlist    - an optional comma-delimited list of additional characters to trim   @          O Notes   @           ;Trims spaces, tabs, line feeds, carriage returns and nulls   @          :     	Function   @           libString_trim   @           Description   @           8Strip whitespace from the beginning and end of a string   @          7 Syntax   @           &libString_trim inputString [charlist]   @          % Parameters   @          
 !inputString - the string to trim   @            Pcharlist    - an optional comma-delimited list of additional characters to trim   @          O Notes   @           ;Trims spaces, tabs, line feeds, carriage returns and nulls   @          :     	Function   @           libString_explode   @           Description   @           Splits a string into an array   @           Syntax   @           (libString_explode inputString separator   @          ' Parameters   @          
 %inputString - the string to be split   @          $ Jseparator   - the char to be used to split the string into array elements   @          I Notes   @           5Returns a numeric-index array starting at index zero   @          4     	Function   @            libString_quotedPrintableEncode   @           Description   @           6Converts an 8-bit string to a quoted-printable string   @          5 Syntax   @           ,libString_quotedPrintableEncode inputString   @          + Parameters   @          
 $inputString - the string to convert   @          #     	Function   @           libString_repeat   @           Description   @           Repeat a string   @           Syntax   @           'libString_repeat inputString multipler   @          & Parameters   @          
 (inputString - the string to be repeated   @          ' ?multipled   - the number of times the string is to be repeated   @          >     	Function   @           libString_reverse   @           Description   @           Reverses a string   @           Syntax   @           libString_reverse inputString   @           Parameters   @          
 (inputString - the string to be reversed   @          '     	Function   @           libString_wrap   @           Description   @           $Wraps a string to lines to a length   @          # Syntax   @           5libString_wrap inputString [wrapLength] [wrapString]   @          4 Parameters   @          
 'inputString - the string to be wrapped   @          & HwrapLength  - the optional length of the wrapped lines (defaults to 75)   @          G ]wrapString  - the optional string to be appended to the wrapped lines (defaults to LINEFEED)   @          \ Notes   @           AThe wrapString length is not included in the wrapped line length   @          @  ?    	`    @ ?    