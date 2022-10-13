script "model_Movie"
--> MetaData
-
license: GPLv3
name: model_Movie
type: model
version: 0.1


--> Movie | Metadata
-
on movie_DisplayMetadata movieView
    put the movie_File of movieView into movieFile
    
    put the metadata_View of movieView into metaDataView
    -- set the form_XML [bookMarkTitle] of metaDataView to bookMarkXml
end movie_DisplayMetadata

getprop movie_WebPage [movieSeconds]
   put the movie_File of the target into movieFile
   put the movie_PositionMarks [movieSeconds] of the target into moviePositionMarks
   put movie_GetWebPageUrl(movieFile, moviePositionMarks) into someUrl
   return someUrl
end movie_WebPage

function movie_GetWebPageUrl movieFile, moviePositionMarks
    /*
    This function should take a movie and its current location
    and return a url to a web page contianing the basic metadata
    
    This page can be used for redirects etc
    local processing, could direct different movies to different base urls
    The web page may well be a cgi rather than a static page.
    */
    
    file_Deconstruct someFile, someRoot, shortName, fileExtension
    replace space with "_" in shortName
    put urlencode(shortName) into shortName
    put "http://wiki.architex.tv/Film:" && shortName into someUrl
    return someUrl
     
    if moviePositionMarks is empty then
        put "http://wiki.architex.tv/Film:" && urlencode(shortName) into someUrl
    else if the number of lines of moviePositionMarks = 1 then
        put "http://wiki.architex.tv/Film:" && urlencode(shortName) into someUrl
    else
    end if
end movie_GetWebPageUrl

setprop movie_WebPage someUrl
    put the movie_File of the target into movieFile
    movie_SetWebPageUrl movieFile, someUrl
end movie_WebPage

on movie_SetWebPageUrl movieFile, someUrl
    breakpoint
    -- could use this to override dfault web page
end movie_SetWebPageUrl


--> Movie | Bookmark
-
on movie_ExtractBookmarks movieFile, bookMarkTitle, @inPoint, @outPoint
    put movie_GetMovieXml(movieFile, false) into movieXml
    movie_DeconstructBookmarkXml movieXml, bookMarkTitle, inPoint, outPoint, notes, who, clipType, dateCreated, bookMarkXml
    return bookMarkXml
end movie_ExtractBookmarks

on movie_AddBookmark movieView, bookmarkTitle
    breakpoint
    if bookmarkTitle is empty then
        put the uOPN ["movie_BookMark"] of movieView into bookmarkTitle
        ask "Mark the current selection under the following title?" with bookmarkTitle
        if it is empty then exit to top
        put it into bookmarkTitle
    end if
    set the movie_NewBookMark of movieView to bookmarkTitle
end movie_AddBookmark
 
setprop movie_NewBookMark [markPoints] bookmarkTitle
    put the movie_View of the target into movieView
    if exists(movieView) is false then return empty
    if markPoints is empty then
        put the movie_InPoint of movieView into inPoint
        put the movie_OutPoint of movieView into outPoint
    else
        put item 1 of markPoints into inPoint
        put item 2 of markPoints into outPoint
    end if
    
    /*
    put movie_CheckOverlap(inPoint, outPoint, movieFile) into overlappedMark
    if overlappedMark is not empty then
    end if
    */
     
    set the uOPN ["movie_BookMark"] of movieView to bookmarkTitle
    
    put the movie_XML of movieView into movieXml
    put revCreateXMLTree(movieXml, false, true, false) into movieXmlTreeID
    movie_TreeAddBookMark movieXmlTreeID, bookmarkTitle, inPoint, outPoint, bookmarkTitle
    put revXMLText(movieXmlTreeID) into movieXml
    revDeleteXMLTree movieXmlTreeID
     
    put the movie_File of movieView into movieFile
    movie_SetMovieXml movieFile, movieXml
    
    /*
    -- need to figure out how to update the model in a general way
    -- as menu could be called from differnet types of view
    
    put the playList_View of me into playListView
    if exists(playListView) then
        get the tree_Refresh of playListView
    end if
    */
    return movieXml
end movie_NewBookMark

function movie_BookmarksFromTime movieSeconds, movieFile
    put movie_GetMovieXml(movieFile, false) into movieXml
     
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    -- put movie_TreeGetFile(treeID) into movieUrl
    -- put movie_TreeGetTitle(treeID) into movieName
     
    put revXMLRootNode(treeID) into rootNode
    put revXMLChildNames(treeID, rootNode, CR, "bookmark", true) into childNames
    repeat for each line childName in childNames
        put rootNode & "/" & childName into bookmarkNode
        
        put bookmarkNode & "/inPoint" into inNode
        put revXMLNodeContents(treeID, inNode) into inPoint
        put bookmarkNode & "/outPoint" into outNode
        put revXMLNodeContents(treeID, outNode) into outPoint
         
        if movieSeconds > inPoint and movieSeconds < outPoint then
            put revXMLAttribute(treeID, bookmarkNode, "name") into bookmarkTitle
            put inPoint,outPoint into bookmarkTitleArray [bookmarkTitle]
        end if
    end repeat
    revDeleteXMLTree treeID
    return keys(bookmarkTitleArray)
end movie_BookmarksFromTime
    
function movie_ConstuctBookmarkTimeArray movieXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    -- put movie_TreeGetFile(treeID) into movieUrl
    -- put movie_TreeGetTitle(treeID) into movieName
     
    put revXMLRootNode(treeID) into rootNode
    put revXMLChildNames(treeID, rootNode, CR, "bookmark", true) into childNames
    repeat for each line childName in childNames
        put rootNode & "/" & childName into bookmarkNode
        
        put revXMLAttribute(treeID, bookmarkNode, "name") into bookmarkTitle
         
        put bookmarkNode & "/inPoint" into inNode
        put revXMLNodeContents(treeID, inNode) into inPoint
        put bookmarkNode & "/outPoint" into outNode
        put revXMLNodeContents(treeID, outNode) into outPoint
         
        put inPoint,outPoint into bookmarkTitleArray [bookmarkTitle]
    end repeat
    revDeleteXMLTree treeID
    return bookmarkTitleArray
end movie_ConstuctBookmarkTimeArray

getprop movie_PositionMarks [movieSeconds]
    -- which book marks contin the movieTime
    put the movie_View of the target into movieView
    if exists(movieView) is false then return empty
    
    if movieSeconds is empty then put the movie_Seconds of movieView into movieSeconds
    put the movie_File of movieView into movieFile
    return movie_BookmarksFromTime(movieSeconds, movieFile)
end movie_PositionMarks

getprop movie_BookMark
    -- if a bookmark is selected 
    -- could check in and out points
    
    put the movie_View of the target into movieView
    if exists(movieView) is false then return empty
    
    return the uOPN ["movie_BookMark"] of movieView
end movie_BookMark

setprop movie_BookMark bookmarkTitle
    put the movie_View of the target into movieView
    if exists(movieView) is false then return empty
    put the movie_Player of movieView into moviePlayer
    
    focus on moviePlayer
     
    if bookmarkTitle is empty then
        set the uOPN ["movie_BookMark"] of movieView to empty
        set the movie_ControllerShowing of movieView to false
        set the movie_PlayClip of movieView to false
        return empty
    end if
    
    put the movie_File of movieView into movieFile
    movie_ExtractBookmarks movieFile, bookMarkTitle, inPoint, outPoint
    -- put the result into bookmarkXML
    -- put inPoint, outPoint
    
    if inPoint is not a number then
        set the uOPN ["movie_BookMark"] of movieView to empty
        set the movie_ControllerShowing of movieView to false
        set the movie_PlayClip of movieView to false
    else
        set the uOPN ["movie_BookMark"] of movieView to bookmarkTitle
        
        set the movie_InPoint of movieView to inPoint
        set the movie_OutPoint of movieView to outPoint
        set the movie_Seconds of movieView to inPoint
         
        set the movie_PlayClip of movieView to true
        set the movie_ControllerShowing of movieView to true
         
        -- now do the displaystuff
        try
            put the metadata_View of movieView into metaDataView
            if exists(metaDataView) then
                set the form_XML [bookMarkTitle] of metaDataView to bookMarkXml
            end if
        end try
         
        /*
        -- not sure how to store movie urls as they can move
        -- lets reset the file info just in case its moved
        -- in which case at  the moment the old bookmark is lost?
        -- could delete as its not trustworthy
        put movie_GetMovieXml(movieFile) into movieXml
        put movie_GetMovieUrl
        movie_SetMovieUrl movieFile, movieXML
        movie_SetMovieXml movieFile, movieXml
        */
        
        return movieXml
    end if
end movie_BookMark

getprop movie_Bookmarks
    put the movie_View of the target into movieView
    put the model_Object of movieView into modelObject
    put the movie_File of movieView into movieFile
    
    return movie_BookmarksFromFile(movieFile, movieUrl, movieName)
end movie_Bookmarks


--> Movie | Bookmark | Indexes
-
function movie_FolderOutline someFolder, @infoArray, tabBit, excludeExtensionList
    /*
    Based on "folder_ConstructFileOutline" but improved structure
    To do: copy new structure over to "folder_ConstructFileOutline"
    */
    
    local shortFileOutline
    folder_Format someFolder
     
    put the directory into oDirectory
    set the directory to someFolder
    put the files into shortFiles
    filter shortFiles without ".*"
    if excludeExtensionList is not empty then
        repeat for each item excludeExtension in excludeExtensionList
            filter shortFiles without ("*." & excludeExtension)
        end repeat
    end if
     
    put empty into tabSection
    put tabBit & tab into nextTabBit
    repeat for each line shortFile in shortFiles
        put someFolder & shortFile into filePath
        if file_IsVideo(filePath) then
            set the cursor to busy
            put filePath & CR after filePaths
            put nextTabBit & html_ConstructNameLink(shortFile, filePath) & CR after tabSection
        end if
    end repeat
    delete char -1 of filePaths
    delete char -1 of tabSection
     
    put the folders into newShortFolders
    filter newShortFolders without ".*"
     
    if filePaths is empty and newShortFolders is empty then return empty
    
    put infoArray["FolderIndex"] into folderIndex
    line_Insert someFolder, folderIndex
    put folderIndex into infoArray["FolderIndex"]
     
    -- what else needs escaping?
    replace "/" with ":" in newShortFolders
     
    set the itemdelimiter to "/"
    put item -1 of someFolder into shortFolder
    if char -6 to -1 of shortFolder is ".eyetv" then delete char -6 to -1 of shortFolder
     
    put tabBit & html_ConstructNameLink(shortFolder, someFolder) into folderLine
    line_Insert folderLine, shortFileOutline
    
    if filePaths is not empty then
        put infoArray["FileIndex"] into fileIndex 
        line_Insert filePaths, fileIndex
        put fileIndex into infoArray["FileIndex"]
         
        line_Insert tabSection, shortFileOutline
    end if
     
    repeat for each line newShortFolder in newShortFolders
        put someFolder & newShortFolder & "/" into nestedFolder
        put movie_FolderOutline(nestedFolder, infoArray, nextTabBit, excludeExtensionList) into nestedOutline
        line_Insert nestedOutline, shortFileOutline
    end repeat
     
    set the directory to oDirectory
    return shortFileOutline
end movie_FolderOutline

function movie_BookMarkOutline someFolder, tabBit, excludeExtensionList, useShortNames, bookColour, displayNonVideo
   /*
   a recursive function
   Based on "folder_ConstructFileOutline" but improved structure
   To do: copy new structure over to "folder_ConstructFileOutline"
   */
   
   local shortFileOutline
   folder_Format someFolder
   put tabBit & tab into nextTabBit
   put nextTabBit & tab into bookmarkTabBit
   
   put the directory into oDirectory
   set the directory to someFolder
   put the files into shortFiles
   filter shortFiles without ".*"
   if excludeExtensionList is not empty then
      repeat for each item excludeExtension in excludeExtensionList
         filter shortFiles without ("*." & excludeExtension)
      end repeat
   end if
   
   -- work out nestest newShortFolders
   put the folders into newShortFolders
   filter newShortFolders without ".*"
   -- what else needs escaping?
   replace "/" with ":" in newShortFolders
   
   set the itemdelimiter to "/"
   put item -1 of someFolder into shortFolder
   
   put file_IsEyeTvBundle(someFolder) into isEyeTvFolder
   if isEyeTvFolder is false then
      put empty into tabSection
      repeat for each line shortFile in shortFiles
         put someFolder & shortFile into movieFile
         if displayNonVideo is not true then
            if file_IsVideo(movieFile) is false then next repeat
         end if
         
         set the cursor to busy
         put html_ConstructNameLink(shortFile, movieFile) into titleLink
         if bookColour is not empty then
            put html_ConstructColouredText(titleLink, bookColour) into titleLink 
         end if
         put nextTabBit & titleLink & CR after tabSection
         
         put movie_GetMovieXml(movieFile, false) into movieXml
         if movieXml is not empty then
            put movie_ConstructBookmarkNameLinks(movieXml, bookmarkTabBit) & CR after tabSection
         end if
      end repeat
      delete char -1 of tabSection
      
      if useShortNames is not false then
         put tabBit & html_ConstructNameLink(shortFolder, someFolder) into folderLine
      else
         put tabBit & html_ConstructNameLink(someFolder, someFolder) into folderLine
      end if
      line_Insert folderLine, shortFileOutline
      line_Insert tabSection, shortFileOutline
      
   else if isEyeTvFolder is true then
      delete char -6 to -1 of shortFolder
      
      put someFolder into eyeTvBundle
      put movie_GetMovieXml(eyeTvBundle, false) into movieXml
      if movieXml is not empty then
         put movie_ConstructBookmarkNameLinks(movieXml, bookmarkTabBit, eyeTvBundle) into tabSection
         if tabSection is empty then
            put tabBit & eyetv_ConstructTitleLink(eyeTvBundle) into folderLine
         else
            put tabBit & eyetv_ConstructTitleLink(eyeTvBundle, bookColour) into folderLine
         end if
         
         line_Insert folderLine, shortFileOutline
         line_Insert tabSection, shortFileOutline
      end if
   end if
   
   -- the recursive bit
   repeat for each line newShortFolder in newShortFolders
      put someFolder & newShortFolder & "/" into nestedFolder
      put movie_BookMarkOutline(nestedFolder, nextTabBit, excludeExtensionList, useShortNames, bookColour, displayNonVideo) into nestedOutline
      line_Insert nestedOutline, shortFileOutline
   end repeat
   
   set the directory to oDirectory
   return shortFileOutline
end movie_BookMarkOutline

function movie_ConstructBookMarkOutline
    put movie_BookMarkMovieFiles() into xmlFiles
    put empty into someOutline
    repeat for each line xmlFile in xmlFiles
        set the cursor to busy
        put url ("file:" & xmlFile) into movieXml
        movie_AddXmlToOutline movieXml, someOutline
    end repeat
    return someOutline
end movie_ConstructBookMarkOutline

function movie_AddBookmarksFromFolder shortFiles, movieFolder
    folder_Format movieFolder
    put empty into someOutline
    sort shortFiles
    repeat for each line shortFile in shortFiles
        put movieFolder & shortFile into movieFile
        index_AddFileToOutline movieFile, someOutline
    end repeat
    return someOutline
end movie_AddBookmarksFromFolder

on movie_AddXmlToOutline movieXml, @someOutline, tabBit
    put tabBit & tab into nextTabBit
    put movie_GetTitle(movieXml) into movieTitle
    put tabBit & html_ConstructNameLink(movieTitle, movieUrl) into bookMarkSection
    get movie_ConstructBookmarkNameLinks(movieXml, nextTabBit) 
    line_Insert it, bookMarkSection
    line_Insert bookMarkSection, someOutline
end movie_AddXmlToOutline

function movie_ConstructBookmarkNameLinks movieXml, tabBit, eyeTvBundle
    put movie_ExtractBookmarksFromXml(movieXml, movieBookMarkUrl, movieName) into movieBookmarks
    if movieBookmarks is empty then return empty
    
    if eyeTvBundle is empty then
        put movieBookMarkUrl into movieUrl
    else
        -- we know the movieUrl already
        -- for instance form the enclosing folder ie the eyeTvBundle
        put eyeTvBundle into movieUrl
    end if
     
    repeat for each line movieBookmark in movieBookmarks
        put tabBit & html_ConstructNameLink(movieBookmark, movieUrl) & CR after bookMarkSection
    end repeat
    delete char -1 of bookMarkSection
    return bookMarkSection
end movie_ConstructBookmarkNameLinks


--> Movie | Bookmark | Model
-
function movie_GetBookMarkTags bookMarkTitle, movieFile
    put movie_GetBookMarkData("tags", bookMarkTitle, movieFile) into notes
    return notes
end movie_GetBookMarkTags

on movie_SetBookMarkTags bookMarkTitle, movieFile, tagList
    movie_SetBookMarkData "tags", bookMarkTitle, movieFile, tagList
end movie_SetBookMarkTags

function movie_GetBookMarkNotes bookMarkTitle, movieFile
    put movie_GetBookMarkData("comment", bookMarkTitle, movieFile) into notes
    return notes
end movie_GetBookMarkNotes

on movie_SetBookMarkNotes bookMarkTitle, movieFile, notes
    movie_SetBookMarkData "comment", bookMarkTitle, movieFile, notes
end movie_SetBookMarkNotes

function movie_GetAllTags movieFile
    local allTags
    
    put movie_GetMovieXml(movieFile) into movieXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    put revXMLRootNode(treeID) into rootNode
    put revXMLNumberOfChildren(treeID, "movie", "bookMark", 0) into maxNum
    repeat with childNum = 1 to maxNum
        put "movie[1]/bookmark[" & childNum & "/tags[1]" into someNode
        
        put revXMLNodeContents(treeID, someNode) into newTags
        if item 1 of newTags is "xmlerr" then next repeat
        list_Add newTags, allTags
    end repeat
     
    revDeleteXMLTree treeID
    return allTags
end movie_GetAllTags

function movie_GetBookMarkData bookmarkTag, bookMarkTitle, movieFile
    put movie_GetMovieXml(movieFile) into movieXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    
    put revXMLMatchingNode(treeID, "movie", "bookMark", "name", bookMarkTitle, 1) into foundNode
    put foundNode & "/" & bookmarkTag into someNode
    put revXMLNodeContents(treeID, someNode) into bookmarkData
    xml_BlankError bookmarkData
    revDeleteXMLTree treeID
    return bookmarkData
end movie_GetBookMarkData

on movie_SetBookMarkData bookmarkTag, bookMarkTitle, movieFile, bookmarkValue
    put movie_GetMovieXml(movieFile) into movieXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    
    put revXMLMatchingNode(treeID, "movie", "bookMark", "name", bookMarkTitle, 1) into foundNode
    xml_TreeAddChild bookmarkTag, foundNode, bookmarkValue, treeID
     
    put revXMLText(treeID) into movieXml
    revDeleteXMLTree treeID
    movie_SetMovieXml movieFile, movieXml
end movie_SetBookMarkData

on movie_DeleteBookMark bookMarkTitle, movieFile
    put movie_GetMovieXml(movieFile) into movieXml
     
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    put revXMLMatchingNode(treeID, "movie", "bookMark", "name", bookMarkTitle, 1) into foundNode
    if foundNode is not empty then
        revDeleteXMLNode treeID, foundNode
    end if
    put revXMLText(treeID) into movieXml
    revDeleteXMLTree treeID
    
    movie_SetMovieXml movieFile, movieXml
end movie_DeleteBookMark

function movie_BookmarksFromFile movieFile, @movieUrl, @movieName
    put movie_GetMovieXml(movieFile) into movieXml
    return movie_ExtractBookmarksFromXml(movieXml, movieUrl, movieName)
end movie_BookmarksFromFile

function movie_ExtractBookmarksFromXml movieXml, @movieUrl, @movieName
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    put revXMLRootNode(treeID) into rootNode
    
    put movie_TreeGetFile(treeID) into movieUrl
    put movie_TreeGetTitle(treeID) into movieName
     
    get revXMLAttributeValues(treeID, rootNode, "bookmark", "name", CR, 1)
    revDeleteXMLTree treeID
    return it
end movie_ExtractBookmarksFromXml

on movie_DeconstructBookmarkXml movieXml, bookMarkTitle, @inPoint, @outPoint, @notes, @who, @clipType, @dateCreated, @bookMarkXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    movie_TreeDeconstructBookmark treeID, bookMarkTitle, inPoint, outPoint, notes, who, clipType, dateCreated, bookMarkXml
    revDeleteXMLTree treeID
end movie_DeconstructBookmarkXml

on movie_SaveBookMarkData movieFile, bookMarkTitle, inPoint, outPoint, notes
    put movie_GetMovieXml(movieFile) into movieXml
    
    if movieXml is empty then
        put movie_ConstructFirstBookMark(movieFile, bookMarkTitle, inPoint, outPoint, notes) into movieXml
        movie_SetMovieXml movieFile, movieXml
    else
        put revCreateXMLTree(movieXml, false, true, false) into treeID
        xml_CheckRevError treeID
         
        put revXMLMatchingNode(treeID, "movie", "bookMark", "name", bookMarkTitle, 1) into foundNode
        if foundNode is empty then
            -- not found
            movie_TreeAddBookMark treeID, bookMarkTitle, inPoint, outPoint, notes
        else
            xml_TreeAddChild "inPoint", foundNode, inPoint, treeID
            xml_TreeAddChild "outPoint", foundNode, outPoint, treeID
            xml_TreeAddChild "comment", foundNode, notes, treeID
        end if
        put revXMLText(treeID) into movieXml
        movie_SetMovieXml movieFile, movieXml
        revDeleteXMLTree treeID
    end if
end movie_SaveBookMarkData

function movie_ConstructFirstBookMark movieFile, bookMarkTitle, inPoint, outPoint, notes
    put xml_Tag(empty, "movie") into movieXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
     
    set the itemdelimiter to "/"
    put the last item of movieFile into movieShortFile
     
    put revXMLRootNode(treeID) into rootNode
    revSetXMLAttribute treeID, rootNode, "file", movieShortFile
    xml_CheckRevError the result
     
    movie_TreeAddBookMark treeID, bookMarkTitle, inPoint, outPoint, notes
    put revXMLText(treeID) into someXML
    revDeleteXMLTree treeID
    return someXML
end movie_ConstructFirstBookMark

function movie_GetBookMarkXml bookMarkTitle, movieFile
    put movie_GetMovieXml(movieFile) into movieXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    put revXMLMatchingNode(treeID, "movie", "bookMark", "name", bookMarkTitle, 1) into foundNode
    if foundNode is empty then
        return empty
    else
        return revXMLText(treeID, foundNode)
    end if
end movie_GetBookMarkXml

on movie_SaveBookMarkXml movieFile, bookMarkTitle, bookMarkXml
    put movie_GetMovieXml(movieFile) into movieXml
    if movieXml is empty then
        set the itemdelimiter to "/"
        put the last item of movieFile into movieShortFile
        put xml_Tag(bookMarkXml, "movie", "file", movieShortFile) into movieXml
    else
        put revCreateXMLTree(movieXml, false, true, false) into treeID
        xml_CheckRevError treeID
        put revXMLMatchingNode(treeID, "movie", "bookMark", "name", bookMarkTitle, 1) into foundNode
        if foundNode is not empty then
            revDeleteXMLNode treeID, foundNode
        end if
        put revXMLRootNode(treeID) into rootNode
        revAppendXML treeID, rootNode, bookMarkXml
        put revXMLText(treeID) into movieXml
        revDeleteXMLTree treeID
    end if
    movie_SetMovieXml movieFile, movieXml
end movie_SaveBookMarkXml


--> Movie | Xml | Model
-
function movie_GetTitle movieXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    put movie_TreeGetTitle(treeID) into someTitle
    revDeleteXMLTree treeID
    return someTitle
end movie_GetTitle

on movie_SetMovieTitle someTitle, @movieXML
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    movie_TreeSetTitle someTitle, treeID
    put revXMLText(treeID) into movieXml
    revDeleteXMLTree treeID
end movie_SetMovieTitle

on movie_SetMovieUrl urlOrFile, @movieXML
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    movie_TreeSetUrl urlOrFile, treeID
    put revXMLText(treeID) into movieXml
    revDeleteXMLTree treeID
end movie_SetMovieUrl

getprop movie_XML
    put the movie_View of the target into movieView
    put the movie_File of movieView into movieFile
    return movie_GetMovieXml(movieFile)
end movie_XML

setprop movie_SetMovieXml movieXML
    put the movie_View of the target into movieView
    put the movie_File of movieView into movieFile
    movie_SetMovieXml movieFile, movieXml
    return the result
end movie_SetMovieXml
    
function movie_GetMovieXml urlOrFile, constructIfEmpty
    put movie_LocalBookMarkUrl(urlOrFile) into someUrl
    put url someUrl into movieXML
    if constructIfEmpty is not false then
        if movieXML is empty then put movie_ConstructBaseXml(urlOrFile) into movieXML
    end if
    return movieXML
end movie_GetMovieXml

on movie_SetMovieXml movieFile, movieXml
    -- was "movie_SaveMovieXml"
    put movie_LocalBookMarkUrl(movieFile) into someUrl
    put movieXml into url someUrl
    return the result
end movie_SetMovieXml

function movie_ConstructBaseXml urlOrFile
    put "<?xml version=" & "1.0" & "?>" into movieXML
     
    url_Deconstruct urlOrFile, someProtocol, urlDomain, urlPath, shortName, fileExtension, userName, pissWord
    set the itemdelimiter to "/"
    put last item of urlOrFile into shortFile
    put xml_Tag(shortFile, "title") into titleTag
    if the result is true then
        put CR & xml_Tag(titleTag, "movie", "url", urlOrFile) after movieXML
    else
        put CR & xml_Tag(titleTag, "movie", "file", urlOrFile) after movieXML
    end if
    return movieXML
end movie_ConstructBaseXml

function movie_BookMarkMovieFiles
    put movie_LocalBookMarkFolder() into localBookMarkFolder
    put folder_FilesInside(localBookMarkFolder) into xmlFiles
    filter xmlFiles with "*.xml"	# just in case
    return xmlFiles
end movie_BookMarkMovieFiles
    
function movie_LocalBookMarkUrl urlOrFile
    -- change to place where local xml cache is going to reside!
    -- all a bit of a hack
     
    put movie_LocalBookMarkFile(urlOrFile) into xmlFile
    return "file:" & xmlFile
end movie_LocalBookMarkUrl

function movie_LocalBookMarkFile urlOrFile
    -- change to place where local xml cache is going to reside!
    -- all a bit of a hack
    put eyetv_ExtractBundle(urlOrFile) into eyeTvBundle
    if eyeTvBundle is not empty then
        return eyeTvBundle & "opn_Bookmark.xml"
    else
        -- this is the dodgy bit
        -- the (file) name that is its unique key, should be based on something like a fingerprint
        -- and not based on its file name which can be changed
        -- Need a new naming structure and rename the old bookmark files!
         
        url_Deconstruct urlOrFile, someProtocol, urlDomain, urlPath, shortName, fileExtension, userName, pissWord
        if the result is true then
            replace "." with "_" in UrlDomain
            get UrlDomain 
            if urlPath is not empty then
                replace "/" with "_" in urlPath
                put "|" & urlPath after it
            end if
            if shortName is not empty then put "|" & shortName after it
            put it into shortName
        else
            put urlOrFile into movieFile
            file_Deconstruct movieFile, someRoot, shortName, fileExtension
        end if
         
        put movie_LocalBookMarkFolder() into xmlFile
        if shortName is not empty then put shortName & ".xml" after xmlFile
        return xmlFile
    end if
end movie_LocalBookMarkFile

function movie_LocalBookMarkFolder
    put folder_GetDocuments() into docFolder
    folder_Format docFolder
    put docFolder & "MovieBookMarks/" into someFolder
    folder_CreateNested someFolder
    return someFolder
end movie_LocalBookMarkFolder


--> Movie | Bookmark | Model | TreeID
-
on movie_TreeConstruct movieFile, @treeID
    put movie_GetMovieXml(movieFile) into movieXml
    put revCreateXMLTree(movieXml, false, true, false) into treeID
    return the result
end movie_TreeConstruct

on movie_TreeSave treeID
    put movie_TreeGetFile(treeID) into movieFile
    put revXMLText(treeID) into movieXml
    revDeleteXMLTree treeID
    movie_SetMovieXml movieFile, movieXml
end movie_TreeSave

function movie_TreeGetFile treeID
    put revXMLRootNode(treeID) into rootNode
    put revXMLAttribute(treeID, rootNode, "file") into movieFile
    if char 1 to 6 of the result is "xmlerr" then
        put revXMLAttribute(treeID, rootNode, "url") into movieUrl
        if char 1 to 6 of the result is "xmlerr" then
            return empty
        else
            return movieUrl
        end if
    else
        return movieFile
    end if
end movie_TreeGetFile

function movie_TreeGetTitle treeID
    put revXMLRootNode(treeID) into rootNode
    put rootNode & "/" & "title" into someNode
    get revXMLNodeContents(treeID, someNode)
    if char 1 to 6 of the result is "xmlerr" then
        return empty
    else
        return it
    end if
end movie_TreeGetTitle

on movie_TreeSetUrl urlOrFile, treeID
    put revXMLRootNode(treeID) into rootNode
    set the itemdelimiter to ":"
    put item 1 of urlOrFile into someProtocol
    if someProtocol is among the items of "file:binFile:ftp:http:https" then
        revSetXMLAttribute treeID, rootNode, "url", urlOrFile
    else
        revSetXMLAttribute treeID, rootNode, "file", urlOrFile
    end if
    return the result
end movie_TreeSetUrl

on movie_TreeSetTitle someTitle, treeID
    put revXMLRootNode(treeID) into rootNode
    put rootNode & "/title" into someNode
    --  revPutIntoXMLNode treeID, someNode, someTitle
    xml_TreeAddNode someNode, someTitle, treeID
    return the result
end movie_TreeSetTitle

on movie_TreeAddBookMark treeID, bookMarkTitle, inPoint, outPoint, notes
    put revXMLRootNode(treeID) into rootNode
    
    revAddXMLNode treeID, rootNode, "bookmark", empty
    put the result into bookMarkNode
    xml_CheckRevError bookMarkNode
    revSetXMLAttribute treeID, bookMarkNode, "name", bookMarkTitle
    xml_CheckRevError the result
     
    revAddXMLNode treeID, bookMarkNode, "inPoint", inPoint
    xml_CheckRevError the result
    revAddXMLNode treeID, bookMarkNode, "outPoint", outPoint
    xml_CheckRevError the result
    if notes is not empty then 
        revAddXMLNode treeID, bookMarkNode, "comment", notes
        xml_CheckRevError the result
    end if
end movie_TreeAddBookMark

on movie_TreeDeconstructBookmark treeID, bookMarkTitle, @inPoint, @outPoint, @notes, @who, @clipType, @dateCreated, @bookMarkXml
    put revXMLMatchingNode(treeID, "movie", "bookMark", "name", bookMarkTitle, 1) into foundNode
    put revXMLText(treeID, foundNode) into bookMarkXml
    
    put foundNode & "/inPoint" into someNode
    put revXMLNodeContents(treeID, someNode) into inPoint
    
    put foundNode & "/outPoint" into someNode
    put revXMLNodeContents(treeID, someNode) into outPoint
    
    put foundNode & "/comment" into someNode
    put revXMLNodeContents(treeID, someNode) into notes
    xml_BlankError notes
    
    put foundNode & "/who" into someNode
    put revXMLNodeContents(treeID, someNode) into who
    xml_BlankError who
    
    put foundNode & "/type" into someNode
    put revXMLNodeContents(treeID, someNode) into clipType
    xml_BlankError clipType
    
    put foundNode & "/date" into someNode
    put revXMLNodeContents(treeID, someNode) into dateCreated
    xml_BlankError dateCreated
end movie_TreeDeconstructBookmark

on xml_BlankError @xmlResult
    if item 1 of xmlResult = "xmlerr" then put empty into xmlResult
end xml_BlankError


--> Movie | Bookmarks | Apple
-
on movie_LoadDvdBookmarks targetObject
    revDeleteAllXMLTrees
    put the movie_View of targetObject into movieView
    put the metadata_View of movieView into metaDataView
     
    set the itemdelimiter to "/"
    put specialfolderpath("pref") into appSupportFolder
    put "Application Support/DVD Player/Settings/" into last item of appSupportFolder
     
    answer file "Select DVD Bookmark file..." with appSupportFolder -- of type "PLIST" 
    put it into dvdBookmarkFile
    if dvdBookmarkFile is empty then exit to top
    
    put dvdBookmarkFile
    exit to top
    
    put url ("file:" & dvdBookmarkFile) into pList
    
    put revCreateXMLTree(pList, false, true, false) into pListTreeID
    put revXMLRootNode(pListTreeID) into rootNode
    -- put revXMLTree(pListTreeID, startNode, CR, tab, true, -1)
    
    -- put startNode & "/dict[1]/key[3]" into someNode -- Video Clip List
    put rootNode & "/dict[1]/array[1]" into startNode
    put revXMLChildNames(pListTreeID, startNode, CR, "dict", true) into childNames
    -- put childNames
    
    put the movie_File of movieView into movieFile
    put movie_GetMovieXml(movieFile) into movieXml
    put revCreateXMLTree(movieXml, false, true, false) into movieXmlTreeID
     
    repeat for each line childName in childNames
        put startNode & "/" & childName into dictNode
         
        put dictNode & "/integer[1]" into someNode -- End Time
        get revXMLNodeContents(pListTreeID, someNode)
        put time_SecondsToHMSF(it) into outPoint
         
        put dictNode & "/dict[1]/string[1]" into someNode -- Bookmark title
        put revXMLNodeContents(pListTreeID, someNode) into bookmarkTitle
         
        put dictNode & "/dict[1]/integer[2]" into someNode -- Start Time
        get revXMLNodeContents(pListTreeID, someNode)
        put time_SecondsToHMSF(it) into inPoint
         
        put inPoint && outPoint into bookMarkArray [bookMarkTitle]
        movie_TreeAddBookMark movieXmlTreeID, bookmarkTitle, inPoint, outPoint, bookmarkTitle
    end repeat
    
    -- movie_TreeDeconstructBookmark movieXmlTreeID, bookmarkTitle, inPoint, outPoint, notes, who, clipType, dateCreated, bookMarkXml
    
    put revXMLText(movieXmlTreeID) into movieXml
    movie_SetMovieXml movieFile, movieXml
     
    revDeleteXMLTree movieXmlTreeID
    revDeleteXMLTree pListTreeID
    
    -- put keys (bookMarkArray)
    -- movie_DeconstructBookmarkXml movieXml, bookmarkTitle, inPoint, outPoint, notes, who, clipType, dateCreated, bookMarkXml
    
    -- set the form_XML [bookMarkTitle] of metaDataView to bookMarkXml
    --  movie_DisplayBookMark inPoint, outPoint, movieView
end movie_LoadDvdBookmarks

function movie_AppleBookMarkFile dvdKey
    -- how do you get the dvdKey from a DVD???
    
    -- put "a66380ba4b02e2b4" into dvdKey
    put dvdKey & ".plist" into shortFile
    
    set the itemdelimiter to "/"
    put specialfolderpath("pref") into appSupportFolder
    put "Application Support/DVD Player/Settings/" into last item of appSupportFolder
    put appSupportFolder & shortFile into dvdBookmarkFile
    return dvdBookmarkFile
end movie_AppleBookMarkFile


--> SMIL
-
function smil_ConstructAmageFileArray
     if defaultDuration is empty then put 5 into defaultDuration
   
end smil_ConstructAmageFileArray

function smil_ConstructSlideShow imageTimingTable, regionName, audioSection, fitType, vWidth, vHeight, imageBackColour
    put the uOPN_SMIL ["BasicSlideShow"] of me into smilTemplate
    if fitType is empty then put "" into fitType
    if vWidth is empty then put 500 into vWidth
    if vHeight is empty then put 375 into vHeight
     
    put "<img src='[[photoSource]]' region='[[regionName]]' dur='[[imageDuration]]' />" into imageLineTemplate
    replace "'" with quote in imageLineTemplate
    if imageBackColour is empty then put "black" into imageBackColour
    
    put empty into imageLines
    set the itemdelimiter to tab
    put tab & tab & tab & tab into tabBit
    repeat for each line someLine in imageTimingTable
        put item 1 of someLine into photoTitle
        put item 2 of someLine into photoSource
        put item 3 of someLine into howManySeconds
         
        put howManySeconds & "sec" into imageDuration
        put merge(imageLineTemplate) & CR & tabBit after imageLines
    end repeat
    delete last line of imageLines
     
    return merge(smilTemplate)
end smil_ConstructSlideShow

getprop fit_Types
    get "hidden,fill,meet,slice"
    replace comma with CR in it
    return it
end fit_Types

