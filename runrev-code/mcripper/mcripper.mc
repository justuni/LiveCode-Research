#!/bin/sh
# MetaCard 2.4 stack
# The following is not ASCII text,
# so now would be a good time to q out of more
exec mc $0 "$@"
                                                                                                                                  	mcRipper    w         ??????  ??????  ?????? white ??????  ??????  ?  ? t4?                ????     U 
helvetica  
 U 
helvetica  	 U 
helvetica   ? 
card bozo   	P?
function encode theData
  #--replace "/" with "//" in theData
  #--put numtoChar(250) into stopChar
  --put "|" into stopChar
  --replace stopChar with "/" & stopChar in theData
  --replace cr with stopChar&stopChar in theData
  
  put "|" into stopChar
  
  replace stopChar with stopChar & stopChar in theData
  if cr is in theData then
    replace "]]" with stopChar & "]" & stopChar & "]" in theData
    put "<![CDATA[" & theData & "]]>" into theData
  else
    replace "<" with stopChar & "[" in theData
  end if
  
  return theData
end encode


function decode theData
  #--put numtoChar(250) into stopChar
  --put "|" into stopChar
  --replace stopChar & stopChar with cr in theData
  --replace "/" & stopChar with stopChar in theData
  #--replace "//" with "/" in theData
  
  put "|" into stopChar
  put empty into replaceString
  repeat
    put random(999) after replaceString
    if replaceString is not in theData then exit repeat
    if the length of replaceString > 30 then put empty into replaceString
  end repeat
  replace stopChar & stopChar with replaceString in theData
  if char 1 to 9 of theData is "<![CDATA[" and char -3 to -1 of theData is "]]>" then
    put char 10 to -4 of theData into theData
    replace stopChar & "]" & stopChar & "]" with "]]" in theData
  else
    replace stopChar & "[" with "<" in theData
  end if
  replace replaceString with stopChar in theData
  return theData
end decode
     ?     4?   test  this is property testtest2  these are the contents of test2 testset    testsettwo  this is testsettwotestsetone  this is testsetone  ?  ?  ?  ?  ?          	  
      ? Rip ?E?p?--Ripper Script
--this script creates an XML file based on a stack

global ripText, theStack

on mouseUp
  put fld "stack" into theMainStack
  if theMainStack is empty then
    put askStack("Choose a stack to rip...") into theMainStack
    put theMainStack into fld "stack"
  end if
  if theMainStack is empty then
    answer "You must specify a stack to rip"
    exit to top
  end if
  put "" into fld "description"
  put "                                " into rawIndent
  put 4 into indentVal
  put "" into indentSpace["stack"]
  put char 1 to (1*indentVal) of rawIndent into indentSpace["background"]
  put char 1 to (1*indentVal) of rawIndent into indentSpace["card"]
  put "<?xml version=" & quote & "1.0" & quote & "?>" & cr & "<file>" & cr into ripText
  put cr into groupIDs
  put the subStacks of stack theMainStack into theStackList
  if theStackList is empty then
    put theMainStack into theStackList
  else
    if theMainStack is not among the lines of theStackList then
      put theMainStack & cr before theStackList
    end if
  end if
  repeat for each line theStack in theStackList
    put "stack" && kwote(theStack) into theStackObject
    rip ("stack" && kwote(theStack)),""
    repeat with i = 1 to (the number of bgs of stack theStack)
      put "bg" && i && "of" && theStackObject into theBG
      put the name of theBG into theBGName
      put theBGName into bgList
      put "   " into theBGSpaces
      rip (theBG),theBGSpaces
      repeat with j = 1 to (the number of controls of bg i of stack theStack)
        put "control" && j && "of bg" && i && "of" && theStackObject into theControl
        repeat until the owner of theControl is theBGName
          put theBGSpaces & "</background>" & cr after ripText
          delete char 1 to 3 of theBGSpaces
          delete the last line of bgList
          put the last line of bgList into theBGName
        end repeat
        rip (theControl),("   "&theBGSpaces)
        put the name of theControl into theControlName
        put word 1 of theControlName into theObjectType
        if theObjectType is "group" then
          put "background" into theObjectType
          put "   " before theBGSpaces
          put theControlName into theBGName
          if bgList is not empty then put cr after bgList
          put theBGName after bgList
        else
          put theBGSpaces & "   </" & theObjectType & ">" & cr after ripText
        end if
      end repeat
      put "   </background>" & cr after ripText
    end repeat
    repeat with i = 1 to (the number of cds of stack theStack)
      rip ("cd" && i && "of" && theStackObject),"   "
      repeat with j = 1to (the number of controls of cd i of stack theStack)
        put the name of control j of cd i of stack theStack into theObject
        if word 1 of the owner of control j of cd i of stack theStack is "card" then
          if word 1 of theObject is "group" then
            put "      <group name=" & (word 2 to -1 of theObject) & "></group>"& cr after ripText
          else
            rip ("control" && j && "of cd" && i && "of" && theStackObject),"      "
            put "      </" & word 1 of theObject & ">" & cr after ripText
          end if
        else
          if word 1 of theObject is "field" then
            put the htmlText of control j of cd i of stack theStack into fldText
            put "      <bgField name=" & (word 2 to -1 of theObject) & ">" & cr after ripText
            put "         <htmlText>" & encode(fldText) & "</htmlText>" & cr & "      </bgField>" & cr after ripText
          end if
        end if
      end repeat
      put "   </card>" & cr after ripText
    end repeat
    put "</stack>" & cr after ripText
  end repeat
  put "</file>" & cr after ripText
  put ripText into fld "description"
  put the length of ripText
  put "" into ripText
  beep
end mouseUp


on rip theObject theSP
  put theObject & cr after fld "commands" of stack "mcRipper"
  put the properties of theObject into props
  put the keys of props into theKeys
  put the name of theObject  into theName
  if word 1 of theObject is "bg" then
    put "background" into word 1 of theName
  end if
  if word 4 of theObject is "bg" and word 1 of theName is "group" then
    put "background" into word 1 of theName
  end if
  put word 1 of theName into theType
  put word 2 to -1 of theName into theShortName
  
  
  --put the opening tag of the object after the ripText
  put theSP & "<" & theType after ripText
  --Test if the object actually have the name, or is the name returning the id
  if theName contains quote then --it has a name
    put " name=" & theShortName after ripText
  else
    put "" into props["name"] --get rid of the id
  end if
  put ">" & cr after ripText
  
  
  --if it's an image then
  if word 1 of theName is "image" then
    put "" into props["colors"] --don't record colors
  end if
  
  --if it's a stack then
  if word 1 of theName is "stack" then
    put "" into props["substacks"] --don't record substacks
  end if
  
  
  --get script
  do ("put the script of" && theObject && "into theScript")
  put (theSP & "   <script>" & encode(theScript) & "</script>" & cr) after ripText
  
  
  --do ("put the contents of" && theObject && "into theContents")
  --put ("contents" && encode(theContents) & cr) after ripText
  
  
  --get the basic properties of the object
  put theSP & "   <properties>" & cr after ripText
  repeat for each line i in theKeys
    put theSP & "      <" & i & ">" & encode(props[i]) & "</" & i & ">" & cr  after ripText
  end repeat
  put theSP & "   </properties>" & cr after ripText
  
  
  --get the custom properties of the default set of the object
  #do ("set the customPropertySet of" && theObject && "to empty")
  #do ("put the customProperties of" && theObject && "into customProps")
  #put the keys of customProps into theCustomKeys
  #repeat for each line i in theCustomKeys
  #put theSP & "   <" & i & ">" & encode(customProps[i]) & "</" & i & ">" & cr after ripText
  #end repeat
  
  
  --get the custom properties of each of the custom property sets of the object
  do ("put the customPropertySets of" && theObject && "into customPropSets")
  if customPropSets is empty then
    put cr after customPropertySets
  else
    put cr & cr after customPropSets
  end if
  repeat for each line L in customPropSets
    put theSP & "   <customPropertySet name=" & quote & encode(L) & quote & ">" & cr after ripText
    --do ("set the customPropertySet of" && theObject && "to L")
    set the customPropertySet of theObject to L
    --do ("put the customProperties of" && theObject && "into customProps")
    put the customProperties of theObject into customProps
    put the keys of customProps into theCustomKeys
    repeat for each line i in theCustomKeys
      put theSP & "      <" & i & ">" & encode(customProps[i]) & "</" & i & ">" & cr after ripText
    end repeat
    put theSP & "   </customPropertySet>" & cr after ripText
  end repeat
  
end rip

function askStack comment
  -- version 7.0
  if comment is empty then
    put "Select a stack." into comment
  end if
  put empty into longStackName
  answer file comment of type "MSTK"
  if the result is empty then
    put line 1 of it into longStackName
  end if
  return longStackName
end askStack

function kwote string
  -- version latest,15/4/01
  return quote & string & quote
end kwote
     ?     @      /Click here to rip the stack named to the right          	     
  ? description  ?)`    ?  X P? ?     ,The description of a stack and its contents         ?    ?    `       Q  ?  ?    a       Y ??   ? Burn ?E?p*--Burner Script
--this creates a stack based on XML input

on mouseUp
  
  put "" into fld "commands"
  put fld "description" into burnText
  --put lineOffset("<stack name=",burnText) into theLine
  --put line theLine to -1 of burnText into burnText
  put "" into cDataText
  put "" into theObject
  put "" into theObjectEnd
  put "" into theObjectStack
  put "" into theProp
  put "" into logText
  put "" into bgList
  put false into gatheringBGField
  put "<stack,<background,<card,<button,<field,<scrollbar,<graphic,<player,<eps,<bgField" into newObjectList
  put ",<stack>,<background>,<card>,<button>,<field>,<scrollbar>,<graphic>,<player>,<eps>,<bgField>" after newObjectList
  put "</stack>,</background>,</card>,</button>,</field>,</scrollbar>,</graphic>,</player>,</eps>,</bgField>" into endObjectList
  put "size,layer,number,id" into readOnlyProps
  
  
  --lock messages, since we don't need them
  lock messages
  
  --get a line
  repeat for each line L in burnText
    
    --if the line isn't empty
    if L is not "" then
      
      --switch based on what L is and what we're doing
      switch
        
        
        
        -------------------------
        --if collecting a cdata
      case cDataText is not empty
        
        --add it to the cdata
        put L & cr after cDataText
        
        --if line ends cdata
        put offset("]]>",L) into theOffset
        if theOffset > 0 then
          
          --get rid of the end tags
          put char 1 to (theOffset - 1) of L into the last line of cDataText
          
          --decode it
          put decode(cDataText) into cDataText
          
          --set it
          put "set the" && theProp && "of theObject to cDataText" into theCommand
          put  theObject & ":" && theProp && "=" && cDataText & cr after logText
          put  theObject & ":" && theProp && "=" && cDataText
          put  theCommand && cDataText & cr after logText
          --put  theCommand && cDataText
          try
            do theCommand
          catch someErr
            put someErr & cr after logText
          end try
          
          
          --empty the holding variable (ends the cdata process)
          put "" into cDataText
          
          --end if
        end if
        
        --break
        break
        
        
        
        -------------------------
        --else if L is the opening or closing tags for properties
      case word 1 of L is among the items of "<properties>,</properties>,</customPropertySet>"
        
        --break, to discard it
        break
        
        
        
        -------------------------
        --else if line starts an object
      case word 1 of L is among the items of newObjectList
        
        --get the type of the object
        put char 2 to -1 of word 1 of L into theObjectType
        
        --if the object didn't have a name, then we have something like "card>"
        if the last char of theObjectType is ">" then
          delete the last char of theObjectType
        end if
        
        --if it's a stack, background, or a background field, get the name
        if theObjectType is among the items of "stack,bgField,background" then
          put offset("name=",L) + 6 into theNameStart
          
          --make sure it has a name, otherwise can't refer to it
          if theNameStart > 0 then
            put char theNameStart to -3 of L into theObjectName
          else
            answer "Stack, BG, or BG Field with no name error:" && L
          end if
        end if
        
        --if it's not a bg field, create the object
        --answer "Creating:" && L
        if theObjectType is "bgField" then
          put "field" && quote & theObjectName & quote into theObject
          
        else
          
          try
            if theObjectType is among the items of "stack,background" then
              do ("create" && theObjectType && quote & theObjectName & quote)
              set the name of it to theObjectName
              put theObjectType && quote & theObjectName & quote into theObject
            else
              do ("create" && theObjectType)
              put it into theObject
              put word 1 to 3 of theObject into theObject
              if theObjectType is "background" then
                put "background" into word 1 of theObject
              end if
              if theObjectType is "card" then
                repeat (the number of groups of this cd)
                  put the name of group 1 of this cd into theRemoveBG
                  put "background" into word 1 of theRemoveBG
                  remove theRemoveBG from this cd
                end repeat
              end if
            end if
          catch someErr
            put someErr & cr after logText
          end try
          put "create" && theObject & cr after logText
        end if
        
        --put the object name after the object stack
        if theObjectStack is empty then
          put theObject into theObjectStack
        else
          put cr & theObject after theObjectStack
        end if
        --answer theObjectStack
        
        --if it's a stack, go to it and make it default
        if "stack" is theObjectType then
          try
            do ("go" && theObject)
            set the defaultStack to theObjectName
          catch someErr
            put someErr & cr after logText
          end try
        end if
        
        
        --if it's a background, start editing it
        if "background" is theObjectType then
          try
            --add the background to the background list
            if bgList is not empty then put cr after bgList
            put theObject after bgList
            stop editing
            start editing theObject
          catch someErr
            put someErr & cr after logText
          end try
        end if
        
        
        --break
        break
        
        
        
        -------------------------
        --else if it ends an object
      case word 1 of L is among the items of endObjectList
        
        --get the type of the item specified in L
        put char 3 to -2 of word 1 of L into theObjectEnd
        
        --check to see if its the last item on the list
        --and raise an alert if it isn't
        if theObjectType is not theObjectEnd then
          answer "XML mismatch -- start:" && theObjectType && "end:" && theObjectEnd
        end if
        
        --if it's a background, stop editing it
        if theObjectType is "background" then
          try
            stop editing
            delete the last line of bgList
            if bgList is not empty then
              put the last line of bgList into theBG
              start editing theBG
            end if
          catch someErr
            put someErr & cr after logText
          end try
        end if
        
        --if it's a stack then delete the first card
        if theObjectType is "stack" then
          try
            --answer theObject
            delete cd 1
          catch someErr
            put someErr & cr after logText
          end try
        end if
        
        --remove it from the object stack
        delete line -1 of theObjectStack
        
        --make the next item on the object stack the current object
        if theObjectStack is empty then
          put empty into theObject
        else
          put line -1 of theObjectStack into theObject
          put word 1 of theObject into theObjectType
        end if
        
        --break
        break
        
        
        
        -------------------------
        --else if it's a custompropertyset
      case (word 1 of L) is "<customPropertySet"
        put "" into theCustomPropSetName
        put offset("name=",L) + 6 into theNameStart
        put char theNameStart to -1 of L into theCustomPropSetName
        put offset(quote,theCustomPropSetName) -1 into theNameEnd
        if theNameEnd > 0 then
          put char 1 to theNameEnd of theCustomPropSetName into theCustomPropSetName
        end if
        put decode(theCustomPropSetName) into theCustomPropSetName
        try
          set the customPropertySet of theObject to theCustomPropSetName
        catch someErr
          put someErr & cr after logText
        end try
        
        --break
        break
        
        
        
        -------------------------
        --else if it's a group
      case (word 1 of L) is "<group"
        put "" into theGroupName
        put offset("name=",L) + 6 into theNameStart
        put char theNameStart to -1 of L into theGroupName
        put offset(quote,theGroupName) -1 into theNameEnd
        if theNameEnd > 0 then
          put char 1 to theNameEnd of theGroupName into theGroupName
        end if
        put decode(theGroupName) into theGroupName
        put "background" && quote & theGroupName & quote into theBackground
        put "place:" && theBackground & cr after logText
        try
          --do ("place" && theBackground && "onto this cd")
          place theBackground onto this cd
        catch someErr
          put someErr & cr after logText
        end try
        
        --break
        break
        
        
        
        -------------------------
        --else assume it's a property
      default
        
        --if it starts a cdata then
        if matchText(L,"^ *<(.*)><!\[CDATA\[(.*)",theProp,cDataText) then
          
          --start collecting it (populate the holding variable)
          put cr after cDataText --got the rest just above
          
          --else
        else
          
          --if it seems to be a property, decode it
          if matchText(L,"^ *<(.*)>(.*)</.*>",theProp,theValue) then
            
            --set it if it isn't read only
            if theProp is not among the items of readOnlyProps then
              put "set the" && theProp && "of theObject to theValue" into theCommand
              put decode(theValue) into theValue
              put  theObject & ":" && theProp && "=" && theValue & cr after logText
              put  theObject & ":" && theProp && "=" && theValue
              try
                do theCommand
              catch someErr
                put someErr & cr after logText
              end try
              
              --end if
            end if
            
            --end if
          end if
          
          --end if
        end if
        
        --end switch
      end switch
      
      --end if
    end if
    
    --end repeat
  end repeat
  
  --put logText into the commands field
  go stack "mcRipper"
  set the defaultStack to "mcRipper"
  put logText into fld "commands" of stack "mcRipper"
  
end mouseUp
     ?   h @      /Creates a stack based on the stack description          	     
  ? stack  )`    ?  X ?      (Enter the name of the stack to rip here         ?       
  ? 	commands  ?)`    ?  X? ?     +Describes steps taken during stack burning         ?    ?    `        ?  ?    a       Y?? 
          ?    P X                Stack Description:    line   K    ?   ?$            @* @
          ?     X                Stack Name: 
          ?    X                
Burn Log:   	 Version .5 (click for details) ?E?x   3on mouseUp
  show fld "version notes"
end mouseUp
     ?  ? ?      /Creates a stack based on the stack description          	     
  
 version notes  ?x   "on mouseUp
  hide me
end mouseUp
   ??????  ?  ? $?p      mcRipper info -- click to hide.         ? )Click anywhere in this field to hide it.    *Version -- This is version .5 of mcRipper   ?History -- Brief -- version .1 was a first shot. Version .2 handled custom properties (including custom property sets!) and substacks. Version .3 changes the file format, so all bets are off. On the other hand, it does XML. <<mmmm, XML>> Version 4 handles stack names with spaces in them, has buttons to open and save xml files, handles contents of background fields, and takes a stab at nested backgrounds. Version 5 handles nested backgrounds and cleans up the code.    3What it Does -- It rips and burns MetaCard stacks.    ?What is "Ripping a MetaCard stack?" -- It goes through the stack and notes all the objects contained in the stack, and most of their properties. It records all this information in XML text format, where it can be modified easily.    ?What is "Burning a MetaCard stack?" -- It can take the XML text it outputs and use it to recreate the stack from scratch, creating the stack, the backgrounds, the cards, and the objects.    ?Warning -- This hasn't been tested well yet -- please use only on copies of stacks. It hasn't done anything harmful to any of my test stacks, but I don't want you to be the first casualty.    =Does it also work on Revolution stacks? -- yes, it seems to.   !What good is it? -- You need to ask? :-) MetaCard stacks in XML -- it can be used as a way of editing MetaCard stacks in any of the available XML editors or text editors, without their scripts running. It was inspired by SuperEdit, which edits SuperCard files without running any scripts.   How do I use it? -- Open mcRipper. Open the stack you want to rip. Enter the name (not the file name, but the stack name) in the top field. Click the Rip button. Click the save button or copy out the text and save it as a text file with .xml on the end of it.    tBugs -- Could be many. Seems to work so far, but check the web page at http://www.inspiredlogic.com/mc/ripper.html.    ?Open Source -- mcRipper is open source, under no license. Feel free to do whatever you like with it. I request that if you make improvments, you flow that code back to me to be incorporated into mcRipper    EmcRipper can be found at http://www.inspiredlogic.com/mc/ripper.html    2Comments can be sent to gcanyon@inspiredlogic.com         	`       % _      a       ???    Load ?E?x   ?on mouseUp
  answer file "File to open:"
  if the result is empty then
    --put it
    put url ("file:" & it) into fld "description"
  end if
end mouseUp
        0 ? $          	        Save ?E?x   ?on mouseUp
  ask file "Save results as:" with (fld "stack" &".xml")
  if the result is empty then
    --put it
    put fld "description" into url ("file:" & it)
  end if
end mouseUp
         ? $          	       ? 	MCRipper    w         ??????  ??????  ?????? white ??????  ??????     ? 4?            ????      ?    	@          4? 