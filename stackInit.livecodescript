script "stackInit"
command setDefaultFolderToStackFolder
   local tPath
   put the effective filename of this stack into tPath
   set the itemDelimiter to slash
   delete last item of tPath
   set the defaultFolder to tPath
end setDefaultFolderToStackFolder
