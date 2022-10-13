id3lib v1.0.2Jan 2008

id3lib is a library for Revolution that allows the reading of all versions of ID3 tags. It can also write the tags, but only in the v2.3 format, so effectively converting any edited tags to v2.3, whatever version they have been before editing. This was a decision based on the fact that it will be a great deal of work to support writing all tag formats, (though I plan to do it), and the fact that v2.3 seems to be the most widely used version. v2.4, being more recent, might seem like the one to support first, but egregious abuse of, and non-compliance with the 2.4 spec by both Apple (in iTunes) and Microsoft (in everything) have made it's wide adoption unlikely. (Note that they've also done 2.3 fairly wrong, but not as badly).

id3lib will also read iTunes (.m4a and .m4p) tags, but cannot write them.

At the moment, this document only describes a subset of what is in id3lib, but I've decided to release it now in order to see how it fairs in use, and because what I suspect is quite a lot of what people might use it for is ready to go.

I'm also fairly close to getting comment frames working properly.

---------------
To start, make sure that you have  id3lib open.To read the tag from a file, get the full path to the file, and pass it to the id3_setFile command, so:id3_setFile someFileid3lib now reads the file, and if it the file is not one that can have an id3 tag, it puts an error message into the result.Now, you can access the various parts of the id3 tag (frames, in the jargon). id3lib provides simple functions for getting the most commonly used frames:Title, Artist, Album, Year, Track Number, Disc Number, Genre, and others.The functions areid3_getTitle()id3_getArtist()id3_getAlbum()id3_getTrackNumber()id3_getDiscNumber()id3_getGenre()
id3_getComposer()
id3_getLyricist()So:put id3_getTitle() into tTitle.id3lib also provides the function id3_getTextFrame(), which you can use to get some of the other, less widely used frames. You have to pass the correct ID for the frame you want as a parameter, soput id3_getTextFrame("TENC") into tEncodedByObviously, you will need to know the various IDs used in the spec, so you can see a list of them here.The full spec can be got from http://www.id3.org/d3v2.3.0The id3v2.3 spec allows the choice of unicode or plain text in many of the text frames, but not in all. Among the frames in which unicode is not allowed are : TrackNumber(TRCK), DiscNumber(TPOS), Year(TYER) and Genre(TCON).The values returned from these text frames can be plain text, or unicode (UTF-16). If you need to know which was returned, you can call id3_IsUnicode(), if it returns true then the last returned value was unicode, plain text if false.
--------------Writing tags.Having read a tag, you can edit the tag using the commands:id3_setTitleid3_setArtistid3_setAlbumid3_setTrackNumberid3_setDiscNumberid3_setGenreid3_setComposer
id3_setLyricist
each command takes an appropriate string as a parameter, and optionally a boolean value to indicate the use of unicode. So:id3_setTitle someTitleid3_setTitle fld "title"id3_setTitle the unicodeText of fld "title",trueIt isn't necessary to include "false" when using plain text, but you can if you want. However, if you pass unicode, but don't include "true", the unicode string will get messed up.Again, for text frames not included in the above list, you can set them using id3_setTextFrame, with the same rules governing unicode.Finally, when you've finished editing the tag, you write it out to the file using id3_updateFile.See the script of the "Samll Tagger" stack for a working example of the various handlers.

------------

Genres

I've included a function id3_getGenreList() which return a list of the genres originally supported in v1 of the id3 spec. (See the script of btn "Genre:" in the demo stack).
These genres are supposed to be stored as numbers (id3lib does the necessary lookups for this), but the spec allows for 'refinements' which can be textual. So it seems to me that you can set any old string you like as a genre, and in practice this seems to be what most implementations do.

------------

v1.0.2 
Pictures.

First, check that there are any:
get id3_getNumberOfPictures()
if it > 0 -- there are pictures

You can now call id3_getPictureData(picNum) -- where pic num is a number not greater than the number the of pictures.
You can also call id3_getPictureDataByType(typeNum) -- where typeNum is an id3.org spec'd picture type. 3 is the type "Cover (front)"

These two functions return the contents of an image file, so you either write it out to a file and reference the file, or <set the text of image "someImage" to it.
