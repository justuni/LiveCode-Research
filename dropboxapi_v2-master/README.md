# dropboxapi_v2 #
LiveCode scripts for accessing the dropbox service using v2 of the dropbox API.

There are two files in this repo:
DropboxAPI_2.livecode - binary stack, including documentation and code for testing various calls
dropboxapi_2.livecodescript - scipt-only-stack, for use as a library or you can integrate as a submodule, for example in a Levure project.
<br/>

#### NOTE: ####
As of LC9-dp7, LiveCode has its own dropbox library, which was inspired by this one.  I would advise you to use LiveCode's library, as it is directly supported by them, and it allows for asynchronous calls, in LC Indy and above.  In the event that you are using LC8, you can also retrieve a hopefully-current fork of the library at my repo [here.](https://github.com/macMikey/LCDropboxLibrary)
