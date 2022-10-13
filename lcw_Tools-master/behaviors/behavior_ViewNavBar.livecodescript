script "behavior_ViewNavBar"
--> MetaData
-
license: GPLv3
name: behavior_ViewNavBar
type: behavior
version: 0.1


--> Header | Props
-
getprop title_Text
   put the label of me into titleText
   return titleText
end title_Text

setprop title_Text titleText
   set the label of me to titleText
   return the long id of me
end title_Text



--> Object
-
getprop navbar_View
   return the long id of me
end navbar_View


--> View
-
getprop view_Object
   return the long id of me
end view_Object

getprop view_Name
   return "View|Navbar"
end view_Name


--> Events
-


--> Navbar | Props
-


