id3lib v1.0.2

id3lib is a library for Revolution that allows the reading of all versions of ID3 tags. It can also write the tags, but only in the v2.3 format, so effectively converting any edited tags to v2.3, whatever version they have been before editing. This was a decision based on the fact that it will be a great deal of work to support writing all tag formats, (though I plan to do it), and the fact that v2.3 seems to be the most widely used version. v2.4, being more recent, might seem like the one to support first, but egregious abuse of, and non-compliance with the 2.4 spec by both Apple (in iTunes) and Microsoft (in everything) have made it's wide adoption unlikely. (Note that they've also done 2.3 fairly wrong, but not as badly).

id3lib will also read iTunes (.m4a and .m4p) tags, but cannot write them.

At the moment, this document only describes a subset of what is in id3lib, but I've decided to release it now in order to see how it fairs in use, and because what I suspect is quite a lot of what people might use it for is ready to go.

I'm also fairly close to getting comment frames working properly.

---------------

id3_getComposer()
id3_getLyricist()

id3_setLyricist


------------

Genres

I've included a function id3_getGenreList() which return a list of the genres originally supported in v1 of the id3 spec. (See the script of btn "Genre:" in the demo stack).
These genres are supposed to be stored as numbers (id3lib does the necessary lookups for this), but the spec allows for 'refinements' which can be textual. So it seems to me that you can set any old string you like as a genre, and in practice this seems to be what most implementations do.

------------

v1.0.2 


First, check that there are any:
get id3_getNumberOfPictures()
if it > 0 -- there are pictures

You can now call id3_getPictureData(picNum) -- where pic num is a number not greater than the number the of pictures.
You can also call id3_getPictureDataByType(typeNum) -- where typeNum is an id3.org spec'd picture type. 3 is the type "Cover (front)"

These two functions return the contents of an image file, so you either write it out to a file and reference the file, or <set the text of image "someImage" to it.