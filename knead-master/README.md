# knead
A tool for livecode to break binary stacks down into script-only stacks and text files of properties

It is based on LiveCode's "Scriptify" script-only stack, which walks a stack, strips out the scripts into script-only stacks, and assigns those SOS's as behaviors to their original objects.




to do:
--------------
field to set minimum script lines

#determine naming convention
#check for object name uniqueness before proceeding
#if have an issue then prompt user, go to card, bring up properties for the object
#breakdown the UI into properties and a script - compare to template objects.



What do I want my notation to look like?
existing:
<stackName><objectName><objectType>behavior


My vote is
stack_stackname.sub_substackname.card_cardname.objecttype_objectname?
	stack_test.card_test.button_test
	stack_test.substack_test.card_test.group_test.button_test


Alternatives
stack.stackname.substack.substackname.card.cardname.objecttype.name?
	stack.test.card.test.button.test
stackname.substack.substackname.card.cardname.objecttype.objectname?
	test.card.test.button.test
name.objecttype.cardname.card.substackname.substack.stackname.stack?
	test.button.test.card.test.stack


If I organize into folders then this seems easier but I'm going to get hosed on unique names.  HOWEVER it's not the stack name that's the problem, it's the script name.  So you can name the stacks whatever you want, but the script needs to have a unique name.
	test
		+ card test
			button_test 
		+ card test2
			button_test


what do i do about unnamed objects that just have numbers or id's?
what do I do about groups?
what if a group appears on multiple cards?
