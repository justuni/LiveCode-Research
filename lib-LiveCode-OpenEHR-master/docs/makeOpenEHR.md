# Make OpenEHR
The 'makeOpenEHR' stack

A makeLibEHR LiveCode stack (a .livecode stack file - used primarily in the LiveCode IDE)

When you drop a .txt file created by the testLibEHR app [for the corresponding openEHR template], it reads in metadata about the openEHR template harvested by the testLibEHR app - it uses this data to create a version of the libOpenEHR scriptOnlyStack as well as a 'test harness' LiveCode stack with corresponding metadata in it to the modified libOpenEHR code library - meaning that the test harness will automatically connect to the modified libOpenEHR and use it to connect to the same openEHR template on the same CDR that the testOpenEHR _app_ used.
