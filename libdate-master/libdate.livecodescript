local sSystemMonthNames,sSystemWeekdayNames,sAbbreviatedSystemMonthNames,sAbbreviatedSystemWeekdayNames
local sEnglishMonthNames,sEnglishWeekdayNames,sAbbreviatedEnglishMonthNames,sAbbreviatedEnglishWeekdayNames

local slibDateMonthNames,slibDateAbbrevMonthNames,sLibDateWeekdayNames,sLibDateAbbrevWeekdayNames
local sLibDateFormats,sLibDateLongFormats,sLibDateAbbrevFormats
local sLibDateLanguages

--Get list of all languages avaliable
function libDate_listlangs
   libDate_initNamesAndFormats #initialise names
   put sLibDateLanguages into temp
   combine temp using CR and comma
   return temp
end libDate_listlangs

-- monthnames and weekdaynames for different languages
on libDate_initNamesAndFormats
   #put your language format here
   --USA
   put "American" into sLibDateLanguages["USA"]   
   put "%m/%d/%y" into sLibDateFormats["USA"]
   put "%A, %B %d, %Y" into sLibDateLongFormats["USA"]
   put "%a, %d. %b %Y" into sLibDateAbbrevFormats["USA"]
   put "Jannuary" & cr & "February" & cr & "March" & cr & "April" & cr & "May" & cr & "June" & cr & "July" & cr & "August" & cr & "September" & cr & "October" & cr & "November" & cr & "Dicember" into sLibDateMonthNames["USA"]
   put "Jan." & cr & "Feb." & cr & "Mar." & cr & "Apr." & cr & "May" & cr & "Jun." & cr & "Jul." & cr & "Aug." & cr & "Sep." & cr & "Oct." & cr & "Nov." & cr & "Dic." into sLibDateAbbrevMonthNames["USA"]
   put "Sunday" & cr & "Monday" & cr & "Tuesday" & cr & "Wednesday" & cr & "Thursday" & cr & "Friday" & cr & "Saturday" into sLibDateWeekdayNames["USA"]
   put "Sun." & cr & "Mon." & cr & "Tue." & cr & "Wed." & cr & "Thu." & cr & "Fri." & cr & "Sat."  into sLibDateAbbrevWeekdayNames["USA"]
   
   
   --English
   put "English" into sLibDateLanguages["EN"]   
   put "%d/%m/%y" into sLibDateFormats["EN"]
   put "%A, %B %d, %Y" into sLibDateLongFormats["EN"]
   put "%a, %d. %b %Y" into sLibDateAbbrevFormats["EN"]
   put "Jannuary" & cr & "February" & cr & "March" & cr & "April" & cr & "May" & cr & "June" & cr & "July" & cr & "August" & cr & "September" & cr & "October" & cr & "November" & cr & "Dicember" into sLibDateMonthNames["EN"]
   put "Jan." & cr & "Feb." & cr & "Mar." & cr & "Apr." & cr & "May" & cr & "Jun." & cr & "Jul." & cr & "Aug." & cr & "Sep." & cr & "Oct." & cr & "Nov." & cr & "Dic." into sLibDateAbbrevMonthNames["EN"]
   put "Sunday" & cr & "Monday" & cr & "Tuesday" & cr & "Wednesday" & cr & "Thursday" & cr & "Friday" & cr & "Saturday" into sLibDateWeekdayNames["EN"]
   put "Sun." & cr & "Mon." & cr & "Tue." & cr & "Wed." & cr & "Thu." & cr & "Fri." & cr & "Sat."  into sLibDateAbbrevWeekdayNames["EN"]
   
   -- Swedish
   put "Swedish" into sLibDateLanguages["SE"]
   put "%Y-%m-%d" into sLibDateFormats["SE"]
   put "den %#d %B %Y" into sLibDateLongFormats["SE"]
   put "den %#d %b %Y" into sLibDateAbbrevFormats["SE"]
   put "januari" & cr & "februari" & cr & "mars" & cr & "april" & cr & "maj" & cr & "juni" & cr & "juli" & cr &"augusti" & cr & "september" & cr & "oktober" & cr & "november" & cr & "december" into sLibDateMonthNames["SE"]
   put "jan" & cr & "feb" & cr & "mar" & cr & "apr" & cr & "maj" & cr & "jun" & cr & "jul" & cr &"aug" & cr & "sep" & cr & "okt" & cr & "nov" & cr & "dec" into sLibDateAbbrevMonthNames["SE"]
   put "s??ndag" & cr & "m??ndag" & cr & "tisdag" & cr & "onsdag" & cr & "torsdag" & cr & "fredag" & cr & "l??rdag" into sLibDateWeekdayNames["SE"]
   put "s??" & cr & "m??" & cr & "ti" & cr & "on" & cr & "to" & cr & "fr" & cr & "l??" into sLibDateAbbrevWeekdayNames["SE"]
   
   -- German
   put "Deutsch" into sLibDateLanguages["DE"]
   put "%d.%m.%y" into sLibDateFormats["DE"]
   put "%A, %d. %B %Y" into sLibDateLongFormats["DE"]
   put "%a, %d. %b %Y" into sLibDateAbbrevFormats["DE"]
   put "Januar" & cr & "Februar" & cr & "M??rz" & cr & "April" & cr & "Mai" & cr & "Juni" & cr & "Juli" & cr & "August" & cr & "September" & cr & "Oktober" & cr & "November" & cr & "Dezember" into sLibDateMonthNames["DE"]
   put "Jan." & cr & "Feb." & cr & "M??r." & cr & "Apr." & cr & "Mai" & cr & "Juni" & cr & "Juli" & cr & "Aug." & cr & "Sep." & cr & "Okt." & cr & "Nov." & cr & "Dez." into sLibDateAbbrevMonthNames["DE"]
   put "Sonntag" & cr & "Montag" & cr & "Dienstag" & cr & "Mittwoch" & cr & "Donnerstag" & cr & "Freitag" & cr & "Samstag" into sLibDateWeekdayNames["DE"]
   put "So." & cr & "Mo." & cr & "Di." & cr & "Mi." & cr & "Do." & cr & "Fr." & cr & "Sa."  into sLibDateAbbrevWeekdayNames["DE"]
   
   -- Italian
   put "Italiano" into sLibDateLanguages["IT"]
   put "%d.%m.%y" into sLibDateFormats["IT"]
   put "%A, %d %B %Y" into sLibDateLongFormats["IT"]
   put "%a, %d/%b/%Y" into sLibDateAbbrevFormats["IT"]
   put "Gennaio" & cr & "Febbraio" & cr & "Marzo" & cr & "Aprile" & cr & "Maggio" & cr & "Giugno" & cr & "Luglio" & cr & "Agosto" & cr & "Settembre" & cr & "Ottobre" & cr & "Novembre" & cr & "Dicembre" into sLibDateMonthNames["IT"]
   put "Gen." & cr & "Feb." & cr & "Mar." & cr & "Apr." & cr & "Mag." & cr & "Giu." & cr & "Lug." & cr & "Ago." & cr & "Set." & cr & "Ott." & cr & "Nov." & cr & "Dic." into sLibDateAbbrevMonthNames["IT"]
   put "Domenica" & cr & "Luned??" & cr & "Marted??" & cr & "Mercoled??" & cr & "Gioved??" & cr & "Venerd??" & cr & "Sabato" into sLibDateWeekdayNames["IT"]
   put "Dom." & cr & "Lun." & cr & "Mar." & cr & "Mer." & cr & "Gio." & cr & "Ven." & cr & "Sab."  into sLibDateAbbrevWeekdayNames["IT"]
   
   --French
   put "Fran??ais" into sLibDateLanguages["FR"]
   put "%d.%m.%y" into sLibDateFormats["FR"]
   put "%A, %d %B %Y" into sLibDateLongFormats["FR"]
   put "%a, %d/%b/%Y" into sLibDateAbbrevFormats["FR"]
   put "Janvier" & cr & "F??vrier" & cr & "Mars" & cr & "Avril" & cr & "Mai" & cr & "Juin" & cr & "Juillet" & cr & "Ao??t" & cr & "Septembre" & cr & "Octobre" & cr & "Novembre" & cr & "D??cembre" into sLibDateMonthNames["FR"]
   put "Jan." & cr & "Fev." & cr & "Mar." & cr & "Avr." & cr & "Mai" & cr & "Juin" & cr & "Juil." & cr & "Ao??." & cr & "Sep." & cr & "Oct." & cr & "Nov." & cr & "D??c." into sLibDateAbbrevMonthNames["FR"]
   put "Dimanche" & cr & "Lundi" & cr & "Mardi" & cr & "Mercredi" & cr & "Jeudi" & cr & "Vendredi" & cr & "Samedi" into sLibDateWeekdayNames["FR"]
   put "Dim." & cr & "Lun." & cr & "Mar." & cr & "Mer." & cr & "Jeu." & cr & "Ven." & cr & "Sam." into sLibDateAbbrevWeekdayNames["FR"]
   
end libDate_initNamesAndFormats

on libDate_reset
   #reset language and format
   local tClear
   put the localNames into tClear
   repeat for each item theItem in tClear
      if "Names" is in theItem then delete variable theItem
   end repeat
end libDate_reset

function libDate_SanityCheck pYear,pMonth,pDay
   #returns true if the supplied date is a valid date
   if pMonth<1 or pMonth>12 then return false
   if pDay<1 then return false
   if pDay > libDate_DaysInMonth(pYear,pMonth) then return false
   return true
end libDate_SanityCheck

function libDate_AbbrevEnglishWeekdayName pYear,pMonth,pDay
   #returns "Sat"
   local tWeekday
   put libDate_DayOfWeek(pYear,pMonth,pDay) + 1 into tWeekDay
   return line tWeekDay of the abbrev english weekdaynames
end libDate_AbbrevEnglishWeekdayName

function libDate_AbbrevSystemWeekdayName pYear,pMonth,pDay
   #depends on your system and language
   #libDate_AbbrevSystemWeekdayName(2012,12,10)  = "mon"
   local tWeekday
   put libDate_DayOfWeek(pYear,pMonth,pDay) + 1 into tWeekDay
   return line tWeekDay of the abbrev system weekdaynames
end libDate_AbbrevSystemWeekdayName

function libDate_EnglishWeekdayName pYear,pMonth,pDay
   #returns the english name of the supplied date
   #example:
   #libDate_EnglishWeekdayName(2012,12,25) = "Tuesday"
   local tWeekday
   put libDate_DayOfWeek(pYear,pMonth,pDay) + 1 into tWeekDay
   return line tWeekDay of the english weekdaynames
end libDate_EnglishWeekdayName

function libDate_SystemWeekdayName pYear,pMonth,pDay
   #depends on your system
   #example on windows italian:
   # libDate_SystemWeekdayName(2015,12,25) = "venerd??"
   local tWeekday
   put libDate_DayOfWeek(pYear,pMonth,pDay) + 1 into tWeekDay
   return line tWeekDay of the system weekdaynames
end libDate_SystemWeekdayName

function libDate_ShortSystemDate pYear,pMonth,pDay,pAddLeadingZeros
   #depends on system
   #example:
   # libDate_ShortSystemDate(2015,12,25) = "25/12/2015"
   local tDateFormatted
   put the short system dateFormat into tDateFormatted
   if pAddLeadingZeros then
      replace "%d" with "%#d" in tDateFormatted
      replace "%m" with "%#m" in tDateFormatted
      replace "%y" with "%Y" in tDateFormatted
   end if
   return libDate_replaceFormatSystem(pYear,pMonth,pDay,tDateFormatted)
end libDate_ShortSystemDate

function libDate_LongSystemDate pYear,pMonth,pDay,pAddLeadingZeros
   #depending on system/language
   #example:
   # libDate_LongSystemDate(2013,12,1) = "domenica 01 dicembre 2013"
   local tDateFormatted
   put the long system dateFormat into tDateFormatted
   if pAddLeadingZeros then
      replace "%d" with "%#d" in tDateFormatted
      replace "%m" with "%#m" in tDateFormatted
      replace "%y" with "%Y" in tDateFormatted
   end if
   return libDate_replaceFormatSystem(pYear,pMonth,pDay,tDateFormatted)
end libDate_LongSystemDate

function libDate_SystemDate pYear,pMonth,pDay,pAddLeadingZeros
   #depends on your system
   #example:
   # libDate_SystemDate(2015,12,25) = "25/12/15"
   local tDateFormatted
   if not libDate_SanityCheck(pYear,pMonth,pDay) then return "libDate error: invalid date."
   put the system dateFormat into tDateFormatted
   if pAddLeadingZeros then
      replace "%d" with "%#d" in tDateFormatted
      replace "%m" with "%#m" in tDateFormatted
      replace "%y" with "%Y" in tDateFormatted
   end if
   return libDate_replaceFormatSystem(pYear,pMonth,pDay,tDateFormatted)
end libDate_SystemDate

function libDate_AbbrevSystemDate pYear,pMonth,pDay,pAddLeadingZeros
   #depending on your system and language
   #on windows italian returns:  "mer 12 dic 2012"
   local tDateFormatted
   put the abbrev system dateFormat into tDateFormatted
   if pAddLeadingZeros then
      replace "%d" with "%#d" in tDateFormatted
      replace "%m" with "%#m" in tDateFormatted
      replace "%y" with "%Y" in tDateFormatted
   end if
   return libDate_replaceFormatSystem(pYear,pMonth,pDay,tDateFormatted)
end libDate_AbbrevSystemDate

function libDate_ShortEnglishDate pYear,pMonth,pDay
   #example:
   # libDate_ShortEnglishDate(2013,12,15) = "12/15/13"
   local tDateFormatted
   put the short english dateFormat into tDateFormatted
   return libDate_replaceFormatEnglish(pYear,pMonth,pDay,tDateFormatted)
end libDate_ShortEnglishDate

function libDate_LongEnglishDate pYear,pMonth,pDay,pAddLeadingZeros
   #example:
   #libDate_LongEnglishDate(2013,12,1) = "Sunday, December 01, 2013"
   local tDateFormatted
   put the long english dateFormat into tDateFormatted
   if pAddLeadingZeros then
      replace "%d" with "%#d" in tDateFormatted
      replace "%m" with "%#m" in tDateFormatted
      replace "%y" with "%Y" in tDateFormatted
   end if
   return libDate_replaceFormatEnglish(pYear,pMonth,pDay,tDateFormatted)
end libDate_LongEnglishDate

function libDate_EnglishDate pYear,pMonth,pDay,pAddLeadingZeros
   #returns date in format  mm/dd/yy
   #if pAddLeadingZeros is true, the date format is mm/dd/yyyy
   local tDateFormatted
   put the english dateFormat into tDateFormatted
   if pAddLeadingZeros then
      replace "%d" with "%#d" in tDateFormatted
      replace "%m" with "%#m" in tDateFormatted
      replace "%y" with "%Y" in tDateFormatted
   end if
   return libDate_replaceFormatEnglish(pYear,pMonth,pDay,tDateFormatted)
end libDate_EnglishDate

function libDate_AbbrevEnglishDate pYear,pMonth,pDay,pAddLeadingZeros
   #returns "Sat, Dec 12, 2015"
   local tDateFormatted
   put the abbrev english dateFormat into tDateFormatted
   if pAddLeadingZeros then
      replace "%d" with "%#d" in tDateFormatted
      replace "%m" with "%#m" in tDateFormatted
      replace "%y" with "%Y" in tDateFormatted
   end if
   return libDate_replaceFormatEnglish(pYear,pMonth,pDay,tDateFormatted)
end libDate_AbbrevEnglishDate

function libDate_replaceFormatSystem pYear,pMonth,pDay,pDateFormatted
   #example:
   # libDate_replaceFormatSystem(2015,12,25,"%d-%m-%Y") = "25-12-2015"
   if sSystemMonthNames[1] is empty then
      libDate_initSystemNames
   end if
   add 0 to pDay
   add 0 to pMonth
   add 0 to pYear
   if pYear<100 then
      -- current century
      put char 1 to 2 of word -1 of the long  english date before pYear
   end if
   local tWeekDay,tDayWithTrailingZero,tMonthWithTrailingZero
   set the caseSensitive to true
   put libDate_dayOfWeek(pYear,pMonth,pDay)+1 into tWeekday
   -- See dateformat in the dictionary
   replace "%a" with sAbbreviatedSystemWeekdayNames[tWeekDay] in pDateFormatted
   replace "%A" with sSystemWeekdayNames[tWeekDay] in pDateFormatted
   replace "%b" with  sAbbreviatedSystemMonthNames[pMonth] in pDateFormatted
   replace "%B" with sSystemMonthNames[pMonth] in pDateFormatted
   replace "%d" with pDay in pDateFormatted
   -- not documented, but possible
   if pDay<10 then 
      put "0"&pDay into tDayWithTrailingZero
   else
      put pDay into tDayWithTrailingZero
   end if
   replace "%#d" with tDayWithTrailingZero in pDateFormatted
   replace "%m" with pMonth in pDateFormatted
   -- not documented, seemingly NOT supported by the engine, but you never know
   if pMonth<10 then 
      put "0"&pMonth into tMonthWithTrailingZero
   else
      put pMonth into tMonthWithTrailingZero
   end if
   replace "%#m" with tMonthWithTrailingZero in pDateFormatted
   replace "%y" with char -2 to -1 of pYear in pDateFormatted
   replace "%Y" with pYear in pDateFormatted
   replace "%#Y" with pYear in pDateFormatted
   replace "%w" with tWeekday in pDateFormatted
   return pDateFormatted
end libDate_replaceFormatSystem

function libDate_replaceFormatEnglish
   #Change the dateformat to "%d/%m/%Y"
   local tParams
   local tYear,tMonth,tDay,tDateformat
   repeat with i=1 to paramCount()
      put param(i)&"," after tParams
   end repeat
   put item 1 of tParams into tYear
   put item 2 of tParams into tMonth
   put item 3 of tParams into tDay
   put item 4 to -1 of tParams into tDateformat   
   if sEnglishMonthNames[1] is empty then
      libDate_initEnglishNames
   end if
   add 0 to tDay
   add 0 to tMonth
   add 0 to tYear
   if tYear<100 then
      -- current century
      put char 1 to 2 of word -1 of the long  english date before tYear
   end if
   local tWeekDay,tDayWithTrailingZero,tMonthWithTrailingZero
   set the caseSensitive to true
   put libDate_dayOfWeek(tYear,tMonth,tDay)+1 into tWeekday
   -- See dateformat in the dictionary
   replace "%a" with sAbbreviatedEnglishWeekdayNames[tWeekDay] in tDateformat
   replace "%A" with sEnglishWeekdayNames[tWeekDay] in tDateformat
   replace "%b" with  sAbbreviatedEnglishMonthNames[tMonth] in tDateformat
   replace "%B" with sEnglishMonthNames[tMonth] in tDateformat
   replace "%d" with tDay in tDateformat
   -- not documented, but possible
   if tDay<10 then 
      put "0"&tDay into tDayWithTrailingZero
   else
      put tDay into tDayWithTrailingZero
   end if
   replace "%#d" with tDayWithTrailingZero in tDateformat
   replace "%m" with tMonth in tDateformat
   -- not documented, seemingly NOT supported by the engine, but you never know
   if tMonth<10 then 
      put "0"&tMonth into tMonthWithTrailingZero
   else
      put tMonth into tMonthWithTrailingZero
   end if
   replace "%#m" with tMonthWithTrailingZero in tDateformat
   replace "%y" with char -2 to -1 of tYear in tDateformat
   replace "%Y" with tYear in tDateformat
   replace "%#Y" with tYear in tDateformat
   replace "%w" with tWeekday in tDateformat
   return tDateformat
end libDate_replaceFormatEnglish

function libDate_LongFormat pYear,pMonth,pDay,pLanguage
   #depending on language
   #example:
   #  libDate_LongFormat(2013,12,1,"IT") = "Dom., 1 Dicembre 2013"
   local tReplace
   if sLibdateMonthNames[pLanguage] is empty then
      libDate_initNamesAndFormats
   end if
   if sLibdateMonthNames[pLanguage] is empty then
      return "libDateError: Unknown language"
   end if
   add 0 to pDay
   add 0 to pMonth
   add 0 to pYear
   if pYear<100 then
      -- current century
      put char 1 to 2 of word -1 of the long  english date before pYear
   end if
   put sLibDateLongFormats[pLanguage] into tReplace
   local tWeekDay,tDayWithTrailingZero,tMonthWithTrailingZero
   set the caseSensitive to true
   put libDate_dayOfWeek(pYear,pMonth,pDay)+1 into tWeekday
   -- See dateformat in the dictionary
   replace "%a" with line tWeekDay of sLibDateAbbrevWeekdayNames[pLanguage] in tReplace
   replace "%A" with line tWeekDay of sLibDateAbbrevWeekdayNames[pLanguage] in tReplace
   replace "%b" with line pMonth of sLibDateAbbrevMonthNames[pLanguage] in tReplace
   replace "%B" with line pMonth of sLibDateMonthNames[pLanguage] in tReplace
   replace "%d" with pDay in tReplace
   -- not documented, but possible
   if pDay<10 then 
      put "0"&pDay into tDayWithTrailingZero
   else
      put pDay into tDayWithTrailingZero 
   end if
   replace "%#d" with tDayWithTrailingZero in tReplace
   replace "%m" with pMonth in tReplace
   -- not documented, seemingly NOT supported by the engine, but you never know
   if pMonth<10 then 
      put "0"&pMonth into tMonthWithTrailingZero
   else
      put pMonth into tMonthWithTrailingZero
   end if
   replace "%#m" with tMonthWithTrailingZero in tReplace
   replace "%y" with char -2 to -1 of pYear in tReplace
   replace "%Y" with pYear in tReplace
   replace "%#Y" with pYear in tReplace
   replace "%w" with tWeekday in tReplace
   return tReplace
end libDate_LongFormat

function libDate_AbbrevFormat pYear,pMonth,pDay,pLanguage
   #example:  put libDate_AbbrevFormat(2015,12,12,"IT")
   #returns:  "Sab., 12/Dic./2015"
   local tReplace
   if sLibdateMonthNames[pLanguage] is empty then
      libDate_initNamesAndFormats
   end if
   if sLibdateMonthNames[pLanguage] is empty then
      return "libDateError: Unknown language"
   end if
   add 0 to pDay
   add 0 to pMonth
   add 0 to pYear
   if pYear<100 then
      -- current century
      put char 1 to 2 of word -1 of the long  english date before pYear
   end if
   put sLibDateAbbrevFormats[pLanguage] into tReplace
   local tWeekDay,tDayWithTrailingZero,tMonthWithTrailingZero
   set the caseSensitive to true
   put libDate_dayOfWeek(pYear,pMonth,pDay)+1 into tWeekday
   -- See dateformat in the dictionary
   replace "%a" with line tWeekDay of sLibDateAbbrevWeekdayNames[pLanguage] in tReplace
   replace "%A" with line tWeekDay of sLibDateAbbrevWeekdayNames[pLanguage] in tReplace
   replace "%b" with line pMonth of sLibDateAbbrevMonthNames[pLanguage] in tReplace
   replace "%B" with line pMonth of sLibDateMonthNames[pLanguage] in tReplace
   replace "%d" with pDay in tReplace
   -- not documented, but possible
   if pDay<10 then 
      put "0"&pDay into tDayWithTrailingZero
   else
      put pDay into tDayWithTrailingZero 
   end if
   replace "%#d" with tDayWithTrailingZero in tReplace
   replace "%m" with pMonth in tReplace
   -- not documented, seemingly NOT supported by the engine, but you never know
   if pMonth<10 then 
      put "0"&pMonth into tMonthWithTrailingZero
   else
      put pMonth into tMonthWithTrailingZero
   end if
   replace "%#m" with tMonthWithTrailingZero in tReplace
   replace "%y" with char -2 to -1 of pYear in tReplace
   replace "%Y" with pYear in tReplace
   replace "%#Y" with pYear in tReplace
   replace "%w" with tWeekday in tReplace
   return tReplace
end libDate_AbbrevFormat

function libDate_shortFormat pYear,pMonth,pDay,pLanguage
   #depends on language
   #example:
   # libDate_shortFormat(2015,12,25,"IT") = "25.12.15"
   local tReplace
   if sLibdateMonthNames[pLanguage] is empty then
      libDate_initNamesAndFormats
   end if
   if sLibdateMonthNames[pLanguage] is empty then
      return "libDateError: Unknown language"
   end if
   add 0 to pDay
   add 0 to pMonth
   add 0 to pYear
   if pYear<100 then
      -- current century
      put char 1 to 2 of word -1 of the long  english date before pYear
   end if
   put sLibDateFormats[pLanguage] into tReplace
   local tWeekDay,tDayWithTrailingZero,tMonthWithTrailingZero
   set the caseSensitive to true
   put libDate_dayOfWeek(pYear,pMonth,pDay)+1 into tWeekday
   -- See dateformat in the dictionary
   replace "%a" with line tWeekDay of sLibDateAbbrevWeekdayNames[pLanguage] in tReplace
   replace "%A" with line tWeekDay of sLibDateAbbrevWeekdayNames[pLanguage] in tReplace
   replace "%b" with line pMonth of sLibDateAbbrevMonthNames[pLanguage] in tReplace
   replace "%B" with line pMonth of sLibDateMonthNames[pLanguage] in tReplace
   replace "%d" with pDay in tReplace
   -- not documented, but possible
   if pDay<10 then 
      put "0"&pDay into tDayWithTrailingZero
   else
      put pDay into tDayWithTrailingZero 
   end if
   replace "%#d" with tDayWithTrailingZero in tReplace
   replace "%m" with pMonth in tReplace
   -- not documented, seemingly NOT supported by the engine, but you never know
   if pMonth<10 then 
      put "0"&pMonth into tMonthWithTrailingZero
   else
      put pMonth into tMonthWithTrailingZero
   end if
   replace "%#m" with tMonthWithTrailingZero in tReplace
   replace "%y" with char -2 to -1 of pYear in tReplace
   replace "%Y" with pYear in tReplace
   replace "%#Y" with pYear in tReplace
   replace "%w" with tWeekday in tReplace
   return tReplace
end libDate_shortFormat

function libDate_dayOfWeek pYear,pMonth,pDay
   #returns the number of the day (0-6) of the week
   #Sunday is 0
   #Monday is 1
   #Tuesday is 2
   #...
   local tMonthNum,tDayNum,tYearNum,tCenturyNum,tCentury,tWeekDay,tYear
   add 0 to pMonth
   put pDay mod 7 into tDayNum
   put 0 into tMonthNum[1]
   put 3 into tMonthNum[2]
   put 3 into tMonthNum[3]
   put 6 into tMonthNum[4]
   put 1 into tMonthNum[5]
   put 4 into tMonthNum[6]
   put 6 into tMonthNum[7]
   put 2 into tMonthNum[8]
   put 5 into tMonthNum[9]
   put 0 into tMonthNum[10]
   put 3 into tMonthNum[11]
   put 5 into tMonthNum[12]
   if pYear>99 then
      put char -2 to -1 of pYear into tYear
   end if
   put (tYear +(tYear div 4)) mod 7 into tYearNum
   if pYear<100 then
      -- current century
      put char 1 to 2 of word -1 of the long  english date into tCentury
   else
      if pYear>=1000 then
         put char 1 to 2 of pYear into tCentury
      else
         put char 1 of pYear into tCentury
      end if
   end if
   put (3 - (tCentury mod 4))*2 into tCenturyNum
   put (tCenturyNum+tYearNum+tMonthNum[pMonth]+tDayNum) into tWeekDay
   if libDate_isLeapYear(pYear) and pMonth <3 then add 6 to tWeekDay
   put tWeekDay mod 7 into tWeekDay
   return tWeekDay
end libDate_dayOfWeek

function libDate_isLeapYear pYear
   #returns true if the supplied year is a leap year
   if pYear<100 then
      -- current century
      put char 1 to 2 of word -1 of the long  english date before pYear
   end if
   if (pYear mod 400 = 0) or (pYear mod 100 <> 0) and (pYear mod 4 = 0) then
      return true
   else
      return false
   end if
end libDate_isLeapYear

on libDate_initSystemNames
   #internal
   -- just here to speed stuff up
   local tCounter
   
   put 0 into tCounter
   repeat for each line theLine in the system monthNames
      add 1 to tCounter
      put theLine into sSystemMonthNames[tCounter]
   end repeat
   
   put 0 into tCounter
   repeat for each line theLine in the abbreviated system monthNames
      add 1 to tCounter
      put theLine into sAbbreviatedSystemMonthNames[tCounter]
   end repeat
   
   put 0 into tCounter
   repeat for each line theLine in the system weekDayNames
      add 1 to tCounter
      put theLine into sSystemWeekdayNames[tCounter]
   end repeat
   
   put 0 into tCounter
   repeat for each line theLine in the abbreviated system weekDayNames
      add 1 to tCounter
      put theLine into sAbbreviatedSystemWeekdayNames[tCounter]
   end repeat
end libDate_initSystemNames

on libDate_initEnglishNames
   #internal
   -- just here to speed stuff up
   local tCounter
   
   put 0 into tCounter
   repeat for each line theLine in the english monthNames
      add 1 to tCounter
      put theLine into sEnglishMonthNames[tCounter]
   end repeat
   
   put 0 into tCounter
   repeat for each line theLine in the abbreviated english monthNames
      add 1 to tCounter
      put theLine into sAbbreviatedEnglishMonthNames[tCounter]
   end repeat
   
   put 0 into tCounter
   repeat for each line theLine in the english weekDayNames
      add 1 to tCounter
      put theLine into sEnglishWeekdayNames[tCounter]
   end repeat
   
   put 0 into tCounter
   repeat for each line theLine in the abbreviated english weekDayNames
      add 1 to tCounter
      put theLine into sAbbreviatedEnglishWeekdayNames[tCounter]
   end repeat
end libDate_initEnglishNames

function libDate_DaysInMonth pYear,pMonth
   #returns the number of days of the supplied month, 
   #you must forurnish also year, because of leap years
   switch pMonth
      case 4
      case 6
      case 9
      case 11
         return 30
         break
      case 2 
         if libDate_isLeapYear(pYear) then
            return 29
         else
            return 28
         end if
         break
      default 
         return 31
         break
   end switch
end libDate_DaysInMonth

function libDate_DayofYear pYear,pMonth,pDay
   #returns the number of the day, the respect the year
   #examples:
   # libDate_DayofYear(2016,1,1) = 1
   # libDate_DayofYear(2016,2,3) = 34
   # libDate_DayofYear(2016,12,31) = 366  , because 2016 is leap year
   local tDayOfYear
   repeat with i=1 to pMonth - 1
      add libDate_DaysInMonth(pYear,i) to tDayOfYear
   end repeat
   add pDay to tDayOfYear
   return tDayOfYear
end libDate_DayofYear

function libDate_CalendarWeekISO pYear,pMonth,pDay
   #example:
   # libDate_CalendarWeekISO(2012,12,12) = "2012 - 50"
   local tWeek,tJan1St,tDaysPassed,tPrevious
   put libDate_DayOfWeek(pYear,1,1) - 1  into tJan1St -- offset for monday = 0
   if tJan1St<0 then put 6 into tJan1St
   put libDate_DayOfYear(pYear,pMonth,pDay) - 1 into tDaysPassed
   put 0 into tWeek
   if tJan1St>3 then
      put tDaysPassed - (7 - tJan1St) into tDaysPassed
   else
      put tDaysPassed+tJan1st into tDaysPassed
   end if
   if tDaysPassed < 0 then
      put true into tPrevious
      if libDate_DayOfWeek(pYear - 1,1,1)=4 then
         put 53 into tWeek
      else
         put 52 into tWeek
      end if
   else
      put tDayspassed div 7 + 1 into tWeek
   end if
   
   if (tDayspassed > 360 and tWeek > 52) then
      if tJan1St = 3 then
         put 53 into tWeek
      else
         put 1 into tWeek
      end if
   end if
   if not tPrevious then
      return pYear &&"-" && tWeek
   else
      return pYear - 1 &&"-" && tWeek
   end if
end libDate_CalendarWeekISO

function libDate_DaysOfCalendarWeekISO pYear,pWeek
   #returns a list of dates (one per line) of the dates of the supplied week
   local tJan4th,tFirstMonday,tMonday,tReturn
   -- the 4th of January is ALWAYS in ISOWeek 1
   -- need to find first monday in a year
   put libDate_DayOfWeek(pYear,1,4) - 1  into tJan4th -- offset for monday = 0
   if tJan4th<0 then put 6 into tJan4th
   put libDate_DayNumber(pYear,1,4) into tFirstMonday
   put tFirstMonday - tJan4th into tFirstMonday
   put tFirstMonday + (pWeek - 1) * 7 into tMonday
   repeat with i=0 to 6
      put libDate_dateFromNumber(tMonday + i) & cr after tReturn
   end repeat
   delete char -1 of tReturn
   return tReturn
end libDate_DaysOfCalendarWeekISO

function libDate_DaysBetween pYear1,pMonth1,pDay1,pYear2,pMonth2,pDay2
   #returns the number of days between two dates
   return libDate_DayNumber(pYear2,pMonth2,pDay2) - libDate_DayNumber(pYear1,pMonth1,pDay1)
end libDate_DaysBetween

function libDate_DateInDaysFrom pYear,pMonth,pDay,pDays
   #return the new date adding pdays
   #example:
   # libDate_DateInDaysFrom(2012,12,12,5) = "2012,12,17"
   return libDate_dateFromNumber(libDate_DayNumber(pYear,pMonth,pDay)+pDays)
end libDate_DateInDaysFrom

-- taken from http://alcor.concordia.ca/~gpkatch/gdate-algorithm.html

function libDate_DayNumber pYear,pMonth,pDay
   #from a date returns number of days counting from year 0 AC/DC, useful for difference or days calculations
   put  (pMonth + 9) mod 12 into pMonth
   put pYear - pMonth div 10 into pYear
   return 365*pYear + pYear div 4 - pYear div 100 + pYear div 400 + (pMonth*306 + 5) div 10 + ( pDay - 1 )
end libDate_DayNumber

function libDate_dateFromNumber pNumber
   #return date from day number starting from 0 year AC/DC
   #example: 
   # libDate_dateFromNumber(702527) = "1923,8,15"
   local tYear,tMonth,tDay,tDays,tMonths
   put (10000*pNumber + 14780) div 3652425 into tYear
   put pNumber - (365*tYear + tYear div 4 - tYear div 100 + tYear div 400) into tDays
   if (tDays < 0) then
      put tYear - 1 into tYear
      put  pNumber - (365* tYear + tYear div 4 - tYear div 100 + tYear div 400) into tDays
   end if
   put  (100*tDays + 52) div 3060 into tMonths
   put  (tMonths + 2) mod 12 + 1 into tMonth
   put tYear + (tMonths + 2) div 12into tYear
   put tDays - (tMonths*306 + 5) div 10 + 1 into tDay
   return tYear, tMonth, tDay
end libDate_dateFromNumber

function libDate_DayOffset pYear,pMonth,pDay,pOffsetInDays
   #return date adding pOffsetDays days
   #example:
   # libDate_DayOffset(2012,10,25,10) = "2012,11,4"
   return libDate_DateFromNumber(libDate_DayNumber(pYear,pMonth,pDay+pOffsetInDays))
end libDate_DayOffset

function libDate_dateFromFormat pFormatString,pFormattedString
   #example:
   #libDate_dateFromFormat("%y-%m-%d","2015-11-22") = "2015,11,22"
   local tTokens,tYear,tMonth,tDay
   put libDate_findTokens(pFormatString,pFormattedString) into tTokens
   repeat for each key theToken in tTokens
      switch tTokens[theToken]["token"]
         case "%y"
            put tTokens[theToken]["value"] into tYear
            if the number of chars of tYear <3 then 
               put char 1 to 2 of word -1 of the long english date before tYear
            end if
            break
         case "%m"
         case "%#m"
            put tTokens[theToken]["value"] into tMonth
            break
         case "%d"
         case "%#d"
            put tTokens[theToken]["value"] into tDay
            break
         case "%b"
            -- parser needs to be forgiving, thus check everything
            put lineOffset(tTokens[theToken]["value"],the system monthnames) into tMonth
            if tMonth = 0 then
               put lineOffset(tTokens[theToken]["value"],the monthnames) into tMonth
            end if
            if tMonth = 0 then
               put lineOffset(tTokens[theToken]["value"],the abbrev system monthnames) into tMonth
            end if
            if tMonth= 0 then
               put lineOffset(tTokens[theToken]["value"],the abbrev monthnames) into tMonth
            end if
            if tMonth = 0 then
               repeat for each key theKey in sLibDateMonthNames
                  put lineOffset(tTokens[theToken]["value"],sLibDateMonthNames[theKey]) into tMonth
                  if tMonth <> 0  then 
                     exit repeat
                  end if
               end repeat
            end if
            if tMonth= 0  then
               put "Monthname is ambiguous" into tMonth
            end if
            if the number of chars of tMonth < 2 then put 0 before tMonth
            break
      end switch
   end repeat
   return tYear,tMonth,tDay
end libDate_dateFromFormat

function libDate_findTokens pString,pString2
   #internal function
   local tOffsets,tCounter,tToken,tTokens,tSort,tResult
   
   repeat for each char theChar in pString
      add 1 to tCounter
      if theChar="%" then
         add 1 to tToken
         if tOffsets is empty then
            put tCounter into tOffsets
         else
            put cr & tCounter after tOffsets
         end if
         if char tCounter + 1 of pString ="#" then
            put "," & tCounter +2 after tOffsets
            put char tCounter to tCounter + 2 of pString into tTokens[tToken]["token"]
            put tCounter & "," & tCounter +2 into tTokens[tToken]["offset"]
         else
            put "," & tCounter +1 after tOffsets
            put char tCounter to tCounter + 1 of pString into tTokens[tToken]["token"]
            put tCounter & "," & tCounter +1 into tTokens[tToken]["offset"]
         end if
         if tToken > 1 then
            put char (item 2 of tTokens[tToken-1]["offset"]) + 1 to (item 1 of tTokens[tToken]["offset"]) -1 of pString into tTokens[tToken-1]["delimiter"]
         end if
      end if
   end repeat
   
   -- garbage collection at the end
   put the number of lines of the keys of tTokens into tCounter
   if tCounter >1 then
      put char (item 2 of tTokens[tCounter]["offset"]) +1 to -1 of pString into tTokens[tCounter]["delimiter"]
   end if
   
   put the keys of tTokens into tSort
   sort tSort ascending numeric
   repeat for each line theToken in tSort
      if tTokens[theToken]["delimiter"] is not empty then
         repeat with i=1 to the number of chars of pString2
            --put char i to i + (the number of chars of tTokens[theToken]["delimiter"] -1) of pString2 & cr after msg
            if char i to i + (the number of chars of tTokens[theToken]["delimiter"] -1) of pString2 = tTokens[theToken]["delimiter"] then
               --answer char 1 to i-1 of pString2 && theToken&cr&pString2
               put char 1 to i-1 of pString2 into tTokens[theToken]["value"]
               delete char 1 to i+the number of chars of tTokens[theToken]["delimiter"] -1 of pString2
               exit repeat
            end if
         end repeat
      else
         if theToken = line (the number of lines of tSort) of tSort then
            put pString2 into tTokens[theToken]["value"]
         else
            -- uuuuuhhh this is getting ugly
            
         end if
      end if
   end repeat
   return tTokens
end libDate_findTokens


-- contribution by Mats Wilstrand

function libDate_today
   #example:
   # libDate_today() = "2016,02,23"
   local tDate
   put the english date into tDate
   replace slash with comma in tDate
   put word -1 of the long english date & comma & item 1 of tDate & comma & item 2 of tDate into tDate
   if the number of chars of item 2 of tDate = 1 then put 0 before item 2 of tDate
   if the number of chars of item 3 of tDate = 1 then put 0 before item 3 of tDate
   return tDate
end libDate_Today

-- end Mats

function libDate_dateFromSeconds  tSeconds
   #return date from the seconds (UNIX timestamp)
   #example:
   #libDate_dateFromSeconds(1445495654) = "2015,10,22"
   put  floor(((tSeconds / 60) / 60 ) / 24) into tDays #days from 1970/1/1   
   put libDate_DayNumber(1970,1,1) + tDays into tDays   
   return libDate_dateFromNumber(tDays)   
end libDate_dateFromSeconds

function libdate_TimeFromSeconds  tSeconds
   #return the time from the seconds (UNIX timestamp).
   #hours are in 24 hours format
   #example:
   #libDate_dateFromSeconds(1445495654) = "7:34:14"
   #
   #we know the current time zone
   put (the last word of the internet date ) / 100 into tZone
   put tSeconds mod (86400 ) into myTime # 86400 = 24 *60 *60
   put floor(myTime / 3600) into tHours  # 3600 = 60 * 60
   add tZone to tHours #we must correct time depending on our time zone
   put floor( ( myTime mod 3600 ) / 60)  into tMinutes  # 3600 = 60 * 60
   put (myTime mod 3600 ) mod 60  into tSeconds  # 3600 = 60 * 60
   return tHours &":"& tMinutes &":"& tSeconds
end libdate_TimeFromSeconds

function libDate_addMonths  pyear,pmonth,pday,pMonths
   #Add (or subract) months to date
   #libDate_addMonths (2017,4,5,13) = 2018,5,5
   put pyear,pmonth,pday,0,0,0,0 into temp
   add pMonths to item 2 of temp
   convert temp to date
   convert temp to dateitems
   return (item 1 to 3 of temp)
end libDate_addMonths

function libdate_addMinutes  pTime, pMinutes
   #Usage: libdate_addminutes("18:35",37) = "19:12"
   #pTime format  = "13:15" or 13:15:59"
   #pminutes is a integer positive or negative
   set  itemdel to ":"
   put item 1 of ptime into tOre
   put item 2 of ptime into tMinuti
   put item 3 of ptime into tSecondi
   put tMinuti + pMinutes into tMinuti
   if pMinutes > 0 then 
      put tOre + floor(tMinuti / 60) into tOre
   else 
      put tOre - floor(tMinuti / 60) into tOre
   end if
   put   tMinuti mod 60  into tMinuti
   put tOre mod 24 into tOre
   if the number of chars of tMinuti is 1 then put 0 before tMinuti
   if the number of chars of tOre is 1 then put 0 before tOre
   if tSecondi is empty then
      return (tOre & ":" & tMinuti  )
   else
      return (tOre & ":" & tMinuti & ":" & tSecondi )
   end if
end libdate_addminutes

function libdate_Easter pYear
   /* 
   Syntax:
   libdate_Easter(pYear) 
   
   Examples:
   libdate_Easter() = 2018,4,1
   libdate_Easter(2000) = 2000,4,23
   libdate_Easter(1599) = 1599,4,18
   
   Description:
   This funcion calculates the date of Easter for a given year.
   
   If no year is specified, the current year is used.
   
   It cannot calculate Easter for years before 1583, so will return error for any 
   years earlier than that.   
   Source: 
   Sarah Reichelt, http://www.troz.net/rev/stacks/DateTime.rev
   dateOfEaster */
   
   
   if pYear is empty or pYear is not a number then
      put the seconds into tNow
      convert tNow to dateItems
      put item 1 of tNow into pYear
   end if
   
   if pYear < 1583 then return "Error: date before 1583"
   
   put 0 into wCorrection
   if ( pYear < 1700 ) then put 4 into wCorrection
   else if pYear < 1800 then put 5 into wCorrection
   else if pYear < 1900 then put 6 into wCorrection
   else if pYear < 2100 then put 0 into wCorrection
   else if pYear < 2200 then put 1 into wCorrection
   else if pYear < 2300 then put 2 into wCorrection
   else if pYear < 2500 then put 3 into wCorrection
   
   put (19 * (pYear mod 19) + 24) mod 30 into wDay
   put 22 + wDay + ((2 * (pYear mod 4) + 4 * (pYear mod 7) + 6 * wDay + 5 + wCorrection) mod 7) into wDay
   
   -- jump to next month
   if wDay > 31 then
      put 4 into wMonth
      subtract 31 from wDay
   else
      put 3 into wMonth
   end if
   return (pYear & comma & wMonth &comma & wDay)   
end libdate_Easter 

function libdate_CurrentMonthName pLanguage
   #example: put libdate_CurrentMonthName("IT")
   #returns: "Gennaio"
   if sLibdateMonthNames[pLanguage] is empty then
      libDate_initNamesAndFormats
   end if
   if sLibdateMonthNames[pLanguage] is empty then
      return "libDateError: Unknown language"
   end if
   put item 2 of libDate_today() into curMonth
   return line curMonth of sLibdateMonthNames[pLanguage]
end libdate_CurrentMonthName

function libdate_MonthName tMonth,pLanguage
   #example: put libdate_CurrentMonthName(1,"IT")
   #returns: "Gennaio"
   if sLibdateMonthNames[pLanguage] is empty then
      libDate_initNamesAndFormats
   end if
   if sLibdateMonthNames[pLanguage] is empty then
      return "libDateError: Unknown language"
   end if   
   return line tMonth of sLibdateMonthNames[pLanguage]
end libdate_MonthName

function libdate_AbbrevWeekdayName tDay, pLanguage
   #example: put libdate_AbbrevWeekdayName(1,"IT")
   #return:  "Dom."
   if sLibDateAbbrevWeekdayNames[pLanguage] is empty then
      libDate_initNamesAndFormats
   end if
   if sLibDateAbbrevWeekdayNames[pLanguage] is empty then
      return "libDateError: Unknown language"
   end if     
   return line tDay of sLibDateAbbrevWeekdayNames[pLanguage]
end libdate_AbbrevWeekdayName
