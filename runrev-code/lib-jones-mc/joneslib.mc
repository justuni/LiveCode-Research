#!/bin/sh
# MetaCard 2.3 stack
# The following is not ASCII text,
# so now would be a good time to q out of more
exec mc $0 "$@"
                                                                                                                                  ? 	jonesLib ݵ--                                                    Dave's Stack Script
--              Handlers and User Functions for Numerical Analysis & Computational Geometry
--                                by David L. Jones, 1998-2000 (djones@rsmas.miami.edu)
--
-- *denotes methods modified after Duffett-Smith, Peter. 1988. Practical astronomy with your calculator, 3rd Ed.
--  Cambridge Univ. Press; 185 pp.
-- **denotes methods modified after "Win95 Game Programmer's Ency., by Mark Feldman, 1997"
-------------------------------------   TABLE OF CONTENTS:  ----------------------------------------------------------------------------
------------MISC:----------
-- function deleteExtraTokens inputVar, tokenVar -- returns inputVar stripped of > 1 contiguous tokens
----------ASSOCIATIVE ARRAY HANDLERS:----------
-- on buildArray rawMatrix, @arrayVar -- builds an associative array from a csv input matrix
-- on arrayRowLabels @inputArray, @rowLabelsVar -- returns a sorted list of an array's row labels
-- on arrayColLabels @inputArray, @colLabelsVar -- returns a sorted list of an array's col labels
-- on transposeArray @arrayVar, @transArrayVar -- tranposes an array
-- on copyArray @inputArray, @outputArray -- makes a copy of an array
-- on exportArray @inputArrayVar, @outputVar, numberFormatVar --creates csv export of array elements, with labels
-- on triangularArray @arrayVar -- reduces a symmetric array to a tridiagonal
-- on symmetricArray @arrayVar, @symmArrayVar -- creates a symmetrical array
-- on unfoldArray @ArrayVar, @unfoldedVector  -- unfolds a 2-D triangular association array into a 1-D vector
-- on unfoldArrayLabels @ArrayVar, @unfoldedVector -- same as unfoldArray, but includes row & col labels
----------STATISTICAL:----------
-- function randomTTest A, B, permVar -- returns the probability that 2 sample means are different; after Manly, 1994 & "Resampling Stats"
-- function randomTTest2 A, B, permVar -- returns the probability that sample mean A > B;
-- function bootstrapCI dataList -- returns the 95% CI using the Bootstrap Method as explained by Dr. Craig Brown, NMFS-SEFSC, Miami
-- function spearman vectorA, vectorB -- returns Sperman correlation coefficient for 2 vectors
-- function wtSpearman vectorA, vectorB -- returns weighted Sperman correlation coefficient for 2 vectors
-- on transformArray @arrayVar, methodVar -- transforms an array according to method specified
-- on normalizeArray @arrayVar -- normalizes an array row-wise
-- function stdv dataList -- returns the standard deviation of a sample for a comma-separated list of numbers
-- function sterr dataList -- returns the standard error of a sample for a comma-separated list of numbers
-- function variance dataList -- returns the variance a sample for a comma-separated list of numbers
-- on euclidDist @arrayVar, @euclidArray -- returns a symmetrical array of Euclidean distances
-- on brayCurtis @arrayVar, @brayCurtisArray -- returns a symmetrical array of Bray-Curtis distances
-- function rankData rawData -- use to transform raw data into ranks for Nonparametric statistics
-- function rankArray rawDataVar -- use to transform raw data in a triangular array into ranks for Nonparametric statistics
-- function vistaFormat arrayVar  -- returns an array formatted as a ViSta dissimilarity matrix (*.lsp) file
-- on minSpanningTree @arrayVar, rescaleVar, @mstVar -- creates a minimal spanning tree from an array of dissimilarities
----------MATHEMATICAL:----------
-- on combiObjects rawData, @subsetArray -- returns ARRAY with all possible subsets of rawData
-- function combinatorial n -- returns all possible subsets of a set, where n = #  of objects in the set
-- function nComb n, r -- returns the # of combinations of n objects taken r at a time
-- function factorial x -- returns x!
----------GRAPHICAL:----------
-- function vectorMagDir uVar, vVar -- returns magnitude & direction 2-dimensional vectors components
-- function xyzDist x, y, z, x2, y2, z2 -- returns the distance b/n 2 points in 3D space
-- function xyzMidpoint x, y, z, x2, y2, z2 -- returns the midpoint of a 3D line
-- function translateToOrigin x, y, z, x2, y2, z2 -- returns coordinates for a line translated to 0,0,0
-- **function transMat xyzVar, matrixVar -- returns transformed xyz coordinates after a transformation matrix
----------OCEANOGRAPHIC:----------
-- function meanDepthOfOccurrence rawData, findSD -- returns the mean Depth-of-Occurrence of fish larvae (after Brodeur & Rugen, 1994)
-- function sdDepthOfOccurrence @stnArray, stnList, depthOfOccurrence -- returns the Standard Deviation for the mean Depth-of-Occurrence of fish larvae (after Brodeur & Rugen, 1994)
-- function ekman v -- returns "Cross-shore Ekman transport" in cm/sec
-- function sigmaTee salinity, temp, depth -- returns density of seawater in mg/cm? based on "Eckart's equation"
-- function zCM stationVar -- calculate center of mass & standard error for a return-separated csv list: mean depth, width, stdev of depth, density
-- function latLongDist lat1, long1, lat2, long2 -- returns distance b/n 2 geographic points in kilometers
----------DATE & TIME:----------
-- function hmsToDec hmsHrs -- returns decimal hrs from "hrs:min:sec"; also converts DMS to decimal degrees
-- *function decToHms decHrs (sect. 8)
-- *function decToDMS decHrs (sect. 8)
--*function dayNum month, day, yr  -- p. 5
--*function leapYr yr -- returns TRUE if it is a leap year
-- *function julianDate month, day, yr (sect. 4)
-- *function gregorianDate JD (sect. 5)
-- function numToMonth numVar -- returns the Month spelled out
----------Old Array Handlers: (used in WinPlus before we had associative arrays) ----------
-- function arrayColumns arrayVar -- returns a list of column labels of a csv matrix
-- function arrayRows arrayVar -- returns a list of row labels of a csv matrix
-- function deleteLabelsArray arrayVar -- returns a csv matrix with row and column labels deleted
-- function insertLabelsArray arrayVar, colVar, rowsVar -- returns a csv matrix with row and column labels inserted
-- function transpose arrayVar -- returns a transposed csv matrix
-- function matrixMultiply matrix_A, matrix_B -- returns [A]*[B]; generally you transform [B] with [A]
-- function matrixInversion rawMatrix -- returns the inverse of a matrix
-- function matrixSubtraction A, B -- returns [A] - [B]
-- function matrixAddition A, B -- returns [A] + [B]
-- **function multiplyArrays array_A, array_B -- multiply 2 csv matrices <------ REPLACED WITH matrixMultiply
###################-----END TABLE OF CONTENTS-----###################

----------MISC:----------
on beeper -- custom beep handler
  beep
end beeper

function deleteExtraTokens inputVar, tokenVar -- returns inputVar stripped of > 1 contiguous tokens
  put offset(tokenVar & tokenVar , inputVar) into offsetVar -- initialize varaible
  if offsetVar <> 0 then
    repeat until offsetVar = 0
      replace tokenVar & tokenVar with tokenVar in inputVar
      put offset(tokenVar & tokenVar, inputVar) into offsetVar
    end repeat
  end if
  return inputVar
end deleteExtraTokens

----------ASSOCIATIVE ARRAY HANDLERS:----------
on buildArray rawMatrix, @arrayVar -- builds an associative array from a csv input matrix
  repeat for each item i in line 1 of rawMatrix
    put i & cr after colLabels
  end repeat
  delete line 1 of rawMatrix
  repeat for each line k in rawMatrix
    put item 1 of k & cr after rowLabels
    put k into lineVar
    delete item 1 of lineVar
    put lineVar & cr after rawMatrix2
  end repeat
  put 0 into r
  repeat for each line k in rawMatrix2
    add 1 to r
    put 0 into c
    repeat for each item i in k
      add 1 to c
      put i into arrayVar[line r of rowLabels,line c of colLabels] --THIS IS WHAT IS RETURNED
    end repeat
  end repeat
end buildArray

on arrayRowLabels @inputArray, @rowLabelsVar -- returns a sorted list of an array's row labels
  put keys(inputArray) into rowKeys
  sort lines of rowKeys by item 1 of each
  put item 1 of line 1 of rowKeys into rowLabelsVar -- initialize variable
  repeat for each line l in rowKeys
    if item 1 of l = the last line of rowLabelsVar then -- skip duplicates
      next repeat
    else
      put return & item 1 of l after rowLabelsVar -- THIS IS WHAT IS RETURNED
    end if
  end repeat
end arrayRowLabels

on arrayColLabels @inputArray, @colLabelsVar -- returns a sorted list of an array's col labels
  put keys(inputArray) into colKeys
  sort lines of colKeys by item 2 of each
  put item 2 of line 1 of colKeys into colLabelsVar -- initialize variable
  repeat for each line l in colKeys
    if item 2 of l = the last line of colLabelsVar then -- skip duplicates
      next repeat
    else
      put return & item 2 of l after colLabelsVar -- THIS IS WHAT IS "RETURNED"
    end if
  end repeat
end arrayColLabels

on transposeArray @arrayVar, @transArrayVar -- tranposes an array
  arrayRowLabels arrayVar, arrayRows
  arrayColLabels arrayVar, arrayCols
  repeat for each line r in arrayRows
    put "Transposing..." & r into cd fld msgBox
    repeat for each line c in arrayCols
      put arrayVar[r,c] into transArrayVar[c,r] -- TRANSPOSE THE ARRAY
    end repeat
  end repeat
  delete arrayVar --cleanup
end transposeArray

on copyArray @inputArray, @outputArray -- makes a copy of an array
  arrayRowLabels arrayVar, arrayRows
  arrayColLabels arrayVar, arrayCols
  repeat for each line r in arrayRows
    repeat for each line c in arrayCols
      put inputArray[r,c] into outputArray[r,c] -- COPY THE ARRAY
    end repeat
  end repeat
end copyArray

on exportArray @inputArrayVar, @outputVar, numberFormatVar --creates csv export of array elements, with labels
  if numberFormatVar <> empty then set the numberFormat to numberFormatVar --makes this parameter "optional"
  arrayRowLabels inputArrayVar, Rows -- puts row labels into Rows
  arrayColLabels inputArrayVar, Cols -- puts column labels into Cols
  repeat for each line c in Cols
    put c & comma after rowOne -- set up comma separated list of column labels
  end repeat
  repeat for each line r in Rows
    put "Exporting..." & r into cd fld msgBox
    repeat for each line c in Cols
      put inputArrayVar[r,c] & comma after thisRow
    end repeat
    put comma & return & r & comma & thisRow after csvDataVar
    put empty into thisRow -- cleanup
  end repeat
  put rowOne before csvDataVar
  put "," after csvDataVar -- allows cleanup of last line
  replace comma & comma with "" in csvDataVar -- clean up
  replace comma & cr with cr in csvDataVar -- cleanup of tridiagonals
  put csvDataVar into outputVar --THIS IS WHAT IS "RETURNED"
end exportArray

on triangularArray @arrayVar -- reduces a symmetric array to a tridiagonal
  arrayRowLabels arrayVar, arrayRows -- compiles list of rows
  arrayColLabels arrayVar, arrayCols -- compiles list of cols
  delete line 1 of arrayCols -- initialize container, no deletions in first column
  repeat for each line r in arrayRows
    repeat for each line c in arrayCols
      delete arrayVar[r,c]  -- DELETE REDUNDANT ELEMENTS OF SYMMETRIC ARRAY
    end repeat
    delete line 1 of arrayCols  -- with each successive row, there is 1 less column of data to delete
  end repeat
end triangularArray

on symmetricArray @arrayVar, @symmArrayVar -- creates a symmetrical array
  arrayRowLabels arrayVar, arrayRows
  arrayColLabels arrayVar, arrayCols
  repeat for each line r in arrayRows
    repeat for each line c in arrayCols
      if arrayVar[r,c] is empty then  -- CREATES SYMMETRICAL ELEMENTS
        put arrayVar[c,r] into symmArrayVar[r,c]
      else
        put arrayVar[r,c] into symmArrayVar[r,c]
      end if
    end repeat
  end repeat
  delete arrayVar --cleanup
end symmetricArray

on unfoldArray @ArrayVar, @unfoldedVector -- unfolds a 2-D triangular association array into a 1-D vector
  arrayRowLabels arrayVar, arrayRows
  arrayColLabels arrayVar, arrayCols
  ---------- BEGIN CHECK INPUT: ----------
  if (arrayVar[(line 1 of arrayRows), (line 1 of arrayCols)] <> 0) Or (arrayRows <> arrayCols) then
    answer "ERROR: *Unfolding* requires a triangular association matrix"
    exit to MetaCard
  end if
  ---------- END CHECK INPUT ----------
  ---------- BEGIN EXTRACTING EACH COLUMN ----------
  put empty into unfoldedVector -- initialize variable
  repeat for each line c in arrayCols
    repeat for each line r in arrayRows
      if arrayVar[r,c] is empty then -- skip these
        next repeat
      else
        put arrayVar[r,c] & cr after thisColumn -- extract a column at a time
      end if
    end repeat
    delete the first line in thisColumn -- first value should be a 0
    delete the last char in thisColumn -- remove unwanted cr
    put thisColumn & return after unfoldedVector -- THIS IS WHAT IS RETURNED
    delete thisColumn -- cleanup
    ---------- END EXTRACTING EACH COLUMN ----------
  end repeat
  delete the last char in unfoldedVector -- remove unwanted cr
end unfoldArray

on unfoldArrayLabels @arrayVar, @unfoldedVector -- same as unfoldArray, but includes row & col labels
  arrayRowLabels arrayVar, arrayRows
  arrayColLabels arrayVar, arrayCols
  ---------- BEGIN CHECK INPUT: ----------
  if (arrayVar[(line 1 of arrayRows), (line 1 of arrayCols)] <> 0) Or (arrayRows <> arrayCols) then
    answer "ERROR: *Unfolding* requires a triangular association matrix"
    exit to MetaCard
  end if
  ---------- END CHECK INPUT ----------
  ---------- BEGIN EXTRACTING EACH COLUMN ----------
  put empty into unfoldedVector -- initialize variable
  repeat for each line c in arrayCols
    repeat for each line r in arrayRows
      if arrayVar[r,c] is empty then -- skip these
        next repeat
      else
        put arrayVar[r,c] & "," & r & "," & c & cr after thisColumn -- extract a column at a time
      end if
    end repeat
    delete the first line in thisColumn -- first value should be a 0
    delete the last char in thisColumn -- remove unwanted cr
    put thisColumn & return after unfoldedVector -- THIS IS WHAT IS RETURNED
    delete thisColumn -- cleanup
    ---------- END EXTRACTING EACH COLUMN ----------
  end repeat
  delete the last char in unfoldedVector -- remove unwanted cr
end unfoldArrayLabels

----------STATISTICAL:----------
function randomTTest A, B, permVar -- returns the probability that 2 sample means are different; after Manly, 1994 & "Resampling Stats"
  put average(A) into meanA
  put average(B) into meanB
  put the number of items in A into sizeA
  put the number of items in B into sizeB
  put abs(meanA - meanB) into tStat -- the test statistic, the mean difference
  put A & comma & B into C -- combine into 1 variable
  put the number of items in C into sizeC
  put empty into A; put empty into B -- cleanup
  put tStat into scoreCard -- initialize with the test statisitc
  ----- BEGIN RANDOMIZATIONS -----
  put 0 into counter -- initialize variable
  repeat for permVar -- run for the number of randomizations specified
    add 1 to counter
    put "Processing randomization" && counter && "of" && permVar into cd fld msgBox
    sort items of C by random(the ticks) -- randomly shuffle
    put item 1 to sizeA of C into A$
    put item (sizeA + 1) to sizeC of C into B$
    put comma & abs(average(A$) - average(B$)) after scoreCard -- keep list of randomized tStat
  end repeat
  ----- END RANDOMIZATIONS -----
  sort items of scoreCard numeric
  put itemOffset(tStat, scoreCard) into whichItem -- determine where tStat lines in random distribution
  put the number of items of scoreCard into noItems
  put ((noItems - whichItem) + 1)/(permVar + 1) into prob -- formula in Legendre & Legendre (1998) p. 23
  return prob
end randomTTEST

function randomTTest2 A, B, permVar -- returns the probability that sample mean A > B; after Manly, 1994 & "Resampling Stats"
  put average(A) into meanA
  put average(B) into meanB
  put the number of items in A into sizeA
  put the number of items in B into sizeB
  put (meanA - meanB) into tStat -- the test statistic, the mean difference
  put A & comma & B into C -- combine into 1 variable
  put the number of items in C into sizeC
  put empty into A; put empty into B -- cleanup
  put tStat into scoreCard -- initialize with the test statisitc
  ----- BEGIN RANDOMIZATIONS -----
  put 0 into counter -- initialize variable
  repeat for permVar -- run for the number of randomizations specified
    add 1 to counter
    put "Processing randomization" && counter && "of" && permVar into cd fld msgBox
    sort items of C by random(the ticks) -- randomly shuffle
    put item 1 to sizeA of C into A$
    put item (sizeA + 1) to sizeC of C into B$
    put comma & (average(A$) - average(B$)) after scoreCard -- keep list of randomized tStat
  end repeat
  ----- END RANDOMIZATIONS -----
  sort items of scoreCard numeric
  put itemOffset(tStat, scoreCard) into whichItem -- determine where tStat lines in random distribution
  put the number of items of scoreCard into noItems
  put ((noItems - whichItem) + 1)/(permVar + 1) into prob -- formula in Legendre & Legendre (1998) p. 23
  return prob
end randomTTEST2

function bootstrapCI dataList -- returns the 95% CI using the Bootstrap Method as explained by Craig Brown
  -- dataList is a comma-separated list of data
  put the number of items in dataList into noItems
  ----- BEGIN CHECK IF ALL VALUES ARE 0 -----
  repeat with i = 1 to noItems
    put abs(item i of dataList) into item i of checkDataList
  end repeat
  if sum(checkDataList) = 0 then put "yes" into allAreZero
  if allAreZero = "yes" then return "0,0,0"
  ----- END CHECKIF ALL VALUES ARE 0 -----
  repeat for 1000 -- hardwired for 1000 iterations
    repeat for noItems
      put any item of dataList & comma after randomList
    end repeat
    put average(randomList) & cr after averageList
    put empty into randomList
  end repeat
  sort averageList numeric
  put rankData(averageList) into rankList
  ----- BEGIN FIND LOWER CI -----
  put 25 into rankVar -- initialize variable
  put 0 into lowerRank
  repeat until lowerRank <> 0
    if rankVar = 0 then exit repeat -- exit loop if can't find a CI
    put lineOffset(rankVar, rankList) into lowerRank
    if lowerRank = 0 then put rankVar - 0.5 into rankVar -- work your way down
  end repeat
  ----- END FIND LOWER CI -----
  ----- BEGIN FIND UPPER CI -----
  put 975 into rankVar -- initialize variable
  put 0 into upperRank
  repeat until upperRank <> 0
    if rankVar = 0 then exit repeat -- exit loop if can't find a CI
    put lineOffset(rankVar, rankList) into upperRank
    if upperRank = 0 then put rankVar + 0.5 into rankVar -- work your way up
  end repeat
  ----- END FIND UPPER CI -----
  ----- BEGIN FIND MEDIAN -----
  put 500 into rankVar -- initialize variable
  ---------- BEGIN WORK YOUR WAY UP ----------
  put 0 into medianRankUp
  repeat until medianRankUp <> 0
    if rankVar = 0 then exit repeat -- exit loop if can't find a median
    put lineOffset(rankVar, rankList) into medianRankUp
    if medianRankUp = 0 then put rankVar + 0.5 into rankVar
  end repeat
  ---------- BEGIN WORK YOUR WAY UP ----------
  ---------- BEGIN WORK YOUR WAY DOWN ----------
  put 0 into medianRankDn
  repeat until medianRankDn <> 0
    if rankVar = 0 then exit repeat -- exit loop if can't find a median
    put lineOffset(rankVar, rankList) into medianRankDn
    if medianRankDn = 0 then put rankVar - 0.5 into rankVar
  end repeat
  ---------- BEGIN WORK YOUR WAY DOWN ----------
  ---------- BEGIN SEE IF WORKING UP OR DN IS BETTER ----------
  put abs(500 - medianRankUp) into upVar
  put abs(500 - medianRankDn) into dnVar
  if upVar < dnVar then put medianRankUp into medianRank else put medianRankDn into medianRank
  ---------- END SEE IF WORKING UP OR DN IS BETTER ----------
  ----- END FIND MEDIAN -----
  put line lowerRank of averageList into lowerCI
  put line upperRank of averageList into upperCI
  put line medianRank of averageList into medianCI -- median of Bootstrapped distribution, compare with your average to see performance of this method
  return round(lowerCI, 2) & comma & round(upperCI, 2) & comma & "(" & round(medianCI, 2) &")"
end bootstrapCI

function spearman vectorA, vectorB -- returns Sperman correlation coefficient for 2 vectors (YOU NEED TO OPTIMIZE THIS LIKE wtSpearman2)
  put the number of lines in vectorA into vectorASize
  put the number of lines in vectorB into vectorBSize
  if vectorBSize <> VectorASize then
    answer "ERROR in function wtSpearman: vectors not same size"
    exit to MetaCard
  end if
  repeat with z = 1 to vectorASize
    put line z of vectorA into r
    put line z of vectorB into s
    put (r - s)^2 & comma after summationVar
  end repeat
  put 6 * sum(summationVar) into numeratorVar
  put vectorASize * (vectorASize^2 - 1) into denominatorVar
  if denominatorVar = 0 then put 0.000001 into denominatorVar --DO I REALLY NEED THIS TO PREVENT DIVIDE BY ZERO???
  return 1 - (numeratorVar/denominatorVar) -- unweighted Spearman Rank correlation coefficient
end spearman

function wtSpearman vectorA, vectorB -- returns weighted Sperman correlation coefficient for 2 vectors
  put the number of lines in vectorA into vectorASize
  put the number of lines in vectorB into vectorBSize
  if vectorBSize <> VectorASize then
    answer "ERROR in function wtSpearman: vectors not same size"
    exit to MetaCard
  end if
  put 0 into lineCounter -- initialize variable
  repeat for each line r in vectorA
    add 1 to lineCounter
    put line lineCounter of vectorB into s
    put 2/(r^-1 + s^-1) & comma after summationVar
  end repeat
  put (1/vectorASize)*(sum(summationVar)) into hBar
  return (1/(vectorASize - 1)) * ((12*hBar) - (5*vectorASize) - 7) -- Weighted Spearman Rank correlation coefficient
end wtSpearman

on transformArray @arrayVar, methodVar -- transforms an array according to method specified
  arrayRowLabels arrayVar, arrayRows -- compiles list of rows
  arrayColLabels arrayVar, arrayCols -- compiles list of cols
  switch methodVar
  case "Square Root"
    repeat for each line r in arrayRows
      repeat for each line c in arrayCols
        put sqrt(arrayVar[r,c]) into arrayVar[r,c] -- TRANSFORM THE ARRAY
      end repeat
    end repeat
    exit switch
  case "Fourth Root"
    repeat for each line r in arrayRows
      repeat for each line c in arrayCols
        put (arrayVar[r,c])^0.25 into arrayVar[r,c] -- TRANSFORM THE ARRAY
      end repeat
    end repeat
    exit switch
  case "Log (y+1)"
    repeat for each line r in arrayRows
      repeat for each line c in arrayCols
        put log10(arrayVar[r,c] + 1) into arrayVar[r,c] -- TRANSFORM THE ARRAY
      end repeat
    end repeat
    exit switch
  case "Natural Log"
    repeat for each line r in arrayRows
      repeat for each line c in arrayCols
        put ln(arrayVar[r,c]) into arrayVar[r,c] -- TRANSFORM THE ARRAY
      end repeat
    end repeat
    exit switch
  end switch
end transformArray

on normalizeArray @arrayVar -- normalizes an array row-wise
  arrayRowLabels arrayVar, arrayRows -- compiles list of rows
  arrayColLabels arrayVar, arrayCols -- compiles list of cols
  repeat for each line r in arrayRows
    repeat for each line c in arrayCols
      put arrayVar[r,c] & comma after thisRow
    end repeat
    put average(thisRow) into rowAverage
    put stdv(thisRow) into rowStdv
    repeat for each line c in arrayCols
      put (arrayVar[r,c] - rowAverage)/rowStdv into arrayVar[r,c]
    end repeat
    delete thisRow -- cleanup
  end repeat
end normalizeArray

function stdv pDataList -- returns the standard deviation of a sample for a comma-separated list of numbers
  put the number of items in pDataList into countVar
  if countVar = 1 then
    return 0
  else
    put 0 into SumVar --initialize variable
    put average(pDataList) into averageVar
    repeat with i = 1 to countVar
      put (item i of pDataList) - (averageVar) into differenceVar
      put sumVar + differenceVar^2 into sumVar
    end repeat
    put sqrt(sumVar/(countVar - 1)) into stdvVar
    return stdvVar
  end if
end stdv

function sterr dataList -- returns the standard error of a sample for a comma-separated list of numbers
  put the number of items in dataList into sampleSize
  put stdv(dataList) into standardDeviation
  return standardDeviation/(sqrt(sampleSize))
end sterr

function variance dataList -- returns the variance a sample for a comma-separated list of numbers
  return (stdv(dataList))^2
end variance

on euclidDist @arrayVar, @euclidArray -- returns a symmetrical array of Euclidean distances
  arrayRowLabels arrayVar, arrayRows
  arrayColLabels arrayVar, arrayCols
  repeat for each line c in arrayCols
    repeat for each line d in arrayCols
      repeat for each line r in arrayRows
        put ((arrayVar[r,c]) - (arrayVar[r,d]))^2 & comma after summationVar
      end repeat
      put sqrt(sum(summationVar)) into euclidArray[c,d]  --THIS IS WHAT IS "RETURNED"
      put empty into summationVar -- cleanup
    end repeat
  end repeat
end euclidDist

on brayCurtis @arrayVar, @brayCurtisArray -- returns a symmetrical array of Bray-Curtis distances
  arrayRowLabels arrayVar, arrayRows
  arrayColLabels arrayVar, arrayCols
  repeat for each line c in arrayCols -- DO FOR EACH COL
    --    put "Calculating Bray-Curtis distance for..." && c into cd fld msgBox
    repeat for each line d in arrayCols -- DO FOR EACH COL
      repeat for each line r in arrayRows -- DO FOR EACH ROW
        put abs(arrayVar[r,c] - arrayVar[r,d]) & comma after summationNum
        put (arrayVar[r,c] + arrayVar[r,d]) & comma after summationDen
      end repeat
      if sum(summationDen) = 0 then put 0.00001 into sumOfDen else put sum(summationDen) into sumOfDen -- prevents divide by 0
      put ((sum(summationNum))/sumOfDen)* 100 into brayCurtisArray[c,d] -- THIS IS WHAT IS "RETURNED"C
      delete summationNum -- cleanup
      delete summationDen -- cleanup
    end repeat
  end repeat
end brayCurtis

function rankData rawData -- use to transform raw data into ranks for Nonparametric statistics
  --------------- BEGIN SPECIFY ORIGINAL ORDER: ---------------
  put 0 into orderCounter -- initialize variable
  repeat for each line i in rawData -- this allows sorting to original order later
    add 1 to orderCounter
    put i & comma & orderCounter & cr after rawData2 -- puts "order variable" after raw datum
  end repeat
  delete rawData -- cleanup
  --------------- END SPECIFY ORIGINAL ORDER ---------------
  --------------- BEGIN BUILD RANKING ARRAY: ---------------
  sort lines of rawData2 numeric by item 1 of each -- sort according to raw data before ranking
  put 0 into rawRank -- initialize variable
  repeat for each line j in rawData2 -- determine rank of each datum
    add 1 to rawRank
    put item 2 of j & comma after line 1 of rankArray[item 1 of j] -- build list of "order variables" for each class of raw data
    put rawRank & comma after line 2 of rankArray[item 1 of j] -- build list of rawRanks for each class of raw data
  end repeat
  delete rawData2 -- cleanup
  --------------- BEGIN BUILD RANKING ARRAY ---------------
  --------------- BEGIN EXTRACT RANKS: ---------------
  put keys(rankArray) into rankArrayKeys
  repeat for each line k in rankArrayKeys
    put sum(line 2 of rankArray[k])/(the number of items in line 2 of rankArray[k]) into avRank
    repeat for each item m in line 1 of rankArray[k]
      put avRank & comma & m & cr after exportData
    end repeat
  end repeat
  --------------- END EXTRACT RANKS ---------------
  sort lines of exportData numeric by item 2 of each
  repeat for each line o in exportData
    put item 1 of o & cr after exportData2
  end repeat
  delete the last char of exportData2 -- removes unneeded cr
  return exportData2
end rankData

function rankArray rawDataVar -- use to transform raw data into ranks for Nonparametric statistics
  put the number of items in line 1 of rawDataVar into noItems -- item 1 will be ranked, other items are "along for the ride"
  --------------- BEGIN SPECIFY ORIGINAL ORDER  ---------------
  put 0 into orderCounter -- initialize variable
  put the number of lines in rawDataVar into noLines
  repeat with i = 1 to noLines -- this allows resorting to original order later
    add 1 to orderCounter
    put comma & orderCounter after line i of rawDataVar
  end repeat
  --------------- END SPECIFY ORIGINAL ORDER  ---------------
  --------------- BEGIN DETERMINE RANK ORDER  ---------------
  sort lines of rawDataVar numeric by item 1 of each -- sort data before ranking
  put 0 into rankCounter -- initialize variable
  repeat with j = 1 to noLines -- this allows resorting to original order later
    add 1 to rankCounter
    put rankCounter & comma before line j of rawDataVar
  end repeat
  --------------- END DETERMINE RANK ORDER  ---------------
  --------------- BEGIN AVERAGE TIES  ---------------
  put return & "END" after rawDataVar -- needed so last datum will be processes
  add 1 to noLines
  put item 2 of line 1 of rawDataVar into rankName -- initialize variable
  repeat with k = 1 to noLines
    if item 2 of line k of rawDataVar = rankName then
      put line k of rawDataVar & return after thisRankVar
    else
      ---------- BEGIN PROCESSING THIS RANK ----------
      put the number of lines in thisRankVar into noLinesRank
      repeat with m = 1 to noLinesRank
        add item 1 of line m of thisRankVar to sumRankVar
      end repeat
      put sumRankVar/noLinesRank into avRank
      delete sumRankVar -- cleanup
      repeat with n = 1 to noLinesRank
        put avRank into item 1 of line n of thisRankVar
      end repeat
      put thisRankVar & return after rawDataVar2
      delete thisRankVar -- cleanup
      ---------- END PROCESSING THIS RANK ----------
      put line k of rawDataVar & return into thisRankVar -- prepare for next rank
      put item 2 of line k of rawDataVar into rankName -- prepare for next rank
    end if
  end repeat
  --------------- END AVERAGE TIES  ---------------
  replace cr&cr with cr in rawDataVar2 -- removes empty lines
  delete the last char in rawDataVar2 -- removes extra cr
  sort lines of rawDataVar2 numeric by item (3 - (noItems-1)) of each -- return to original order using last item
  repeat for each line z in rawDataVar2
    put z into eachLine
    delete the second item of eachLine
    delete the last item of eachLine
    put eachLine & return after exportDataVar
  end repeat
  delete the last char of exportDataVar -- removes extra cr
  return exportDataVar
end rankArray

function vistaFormat matrixVar  -- returns a matrix formatted as a ViSta dissimilarity matrix
  answer "Data requiring ViSta format is:" with "Multivariate Data" or "Distance Matrix" or "Cancel"
  put it into dataTypeVar
  if dataTypeVar = "Cancel" then exit to MetaCard
  ask "Please enter a descriptive title..."
  put it into titleVar
  put arrayColumns(matrixVar) into colVar
  put (the number of items in colVar) into noOfColumns
  put arrayRows(matrixVar) into rowVar
  put (the number of items in rowVar) into noOfRows
  put deleteLabelsArray(matrixVar) into matrixVar
  put "(data" && quote & dataTypeVar & quote & return & return into vistaMatrixVar
  put ":about" && quote & "ViSta data exporter written by Dave Jones" & quote & cr & cr after vistaMatrixVar
  put ":title" && quote & titleVar & quote & return & return after vistaMatrixVar
  put colVar into variablesVar
  put colVar into typesVar
  repeat with i = 1 to noOfColumns
    put quote before item i of variablesVar
    put quote after item i of variablesVar
    put quote & "numeric" & quote into item i of typesVar
  end repeat
  replace comma with space in variablesVar
  replace comma with space in typesVar
  repeat with j = 1 to noOfRows
    put quote before item j of rowVar
    put quote after item j of rowVar
  end repeat
  replace comma with space in rowVar
  if dataTypeVar = "Distance Matrix" then
    put ":types '(" & typesVar & ")" & return & return after vistaMatrixVar
    put ":matrices '(" & quote & "Matrix_1" & quote & ")" & return & return after vistaMatrixVar
    put ":shapes '(" & quote & "Symmetric" & quote & ")" & return & return after vistaMatrixVar
  else -- Multivariate Data
    put ":labels '(" & rowVar & ")" & return & return after vistaMatrixVar
  end if
  put ":variables '(" & variablesVar & ")" & return & return after vistaMatrixVar
  put ":data '(" & return after vistaMatrixVar
  replace comma with space in matrixVar
  put matrixVar & return & "))" after vistaMatrixVar
  return vistaMatrixVar
end vistaFormat

on minSpanningTree @arrayVar, rescaleVar, @mstVar -- creates a minimal spanning tree from an array of dissimilarities
  -- specify "Yes" for rescalingVar if you want output rescaled to 0-100%
  triangularArray arrayVar -- reduces symmetric array to triangular
  unfoldArrayLabels arrayVar, vectorVar -- unfolds array out to a vector
  arrayRowLabels arrayVar, objectList -- create list of objects
  put the number of lines in objectList into noObjects
  delete arrayVar -- cleanup
  sort lines of vectorVar ascending numeric by item 1 of each -- SORT BY INCREASING DISTANCE
  ----- BEGIN BUILD MINIMAL SPANNING TREE -----
  put line 1 of vectorVar & cr into mstVar -- initialize mstVar with shortest edge
  put 1 into counter -- initialize variable; already seeded it with 1 edge
  put item 2 of line 1 of vectorVar & cr & item 3 of line 1 of vectorVar & cr into mstList -- initialize mstList with 1st edge
  repeat for each line i in vectorVar
    if counter = (noObjects - 1) then exit repeat -- only need n-1 edges in a MST
    put item 1 of i into distanceVar
    put item 2 of i into A -- just makes it easer to refer to just A
    put item 3 of i into B -- ditto
    if offset(A, mstVar) = 0 then put 0 into mstStatus else put 1 into mstStatus -- 0 = absent, 1 = present
    if offset(B, mstVar) = 0 then put 0 after mstStatus else put 1 after mstStatus -- note this is put AFTER
    switch mstStatus
    case "11" -- both points already in MST, so skip
      exit switch
    case "10"
    case "01" -- for both conditions, one point is already in MST, so just add this edge for linkage
      put i & cr after mstVar -- add edge to MST
      add 1 to counter
      if offset(A, mstList) = 0 then put A & cr after mstList -- add point to list if not already there
      if offset(B, mstList) = 0 then put B & cr after mstList -- ditto
      exit switch
    case "00" -- neither points already in MST
      ----- BEGIN find smallest of the nearest neighbors of A vs. of B that are already in MST -----
      put empty into aNeighbors -- initialize variable
      put empty into bNeighbors -- initialize variable
      repeat for each line z in mstList -- DO THIS FOR A
        put lineOffset(A & comma & z, vectorVar) into whichLine
        if whichLine = 0 then put lineOffset(z & comma & A, vectorVar) into whichLine
        put line whichLine of vectorVar & cr after aNeighbors
      end repeat
      repeat for each line y in mstList -- DO THIS FOR B
        put lineOffset(B & comma & y, vectorVar) into whichLine
        if whichLine = 0 then put lineOffset(y & comma & B, vectorVar) into whichLine
        put line whichLine of vectorVar & cr after bNeighbors
      end repeat
      sort lines of aNeighbors ascending numeric by item 1 of each -- sort so nearest neighbors are at top
      sort lines of bNeighbors ascending numeric by item 1 of each -- sort so nearest neighbors are at top
      if (item 1 of line 1 of aNeighbors) <= (item 1 of line 1 of bNeighbors) then -- put the smallest of the 2
        put line 1 of aNeighbors & cr after mstVar -- add edge to MST
      else
        put line 1 of bNeighbors & cr after mstVar -- add edge to MST
      end if
      ----- END find smallest of the nearest neighbors of A vs. of B that are already in MST -----
      put i & cr before the last line in mstVar -- now you can add this edge to MST
      put A & cr & B & cr after mstList -- add these to the list
      add 2 to counter -- added 2 edges
      exit switch
    end switch
  end repeat
  ----- END BUILD MINIMAL SPANNING TREE -----
  -- delete the last char in mstVar -- remove unnecessary cr (DO I NEED THIS???)
  sort lines of mstVar ascending numeric by item 1 of each -- sort via increasing distance
  if rescaleVar is "Yes" then
    ----- BEGIN RESCALING DISTANCES TO 0 - 100 SCALE -----
    put item 1 of the last line in mstVar into denom
    repeat for each line q in mstVar
      put q into myLine
      set the numberFormat to "0.00"
      put round(item 1 of myLine/denom * 100, 2) into item 1 of myLine
      put myLine & cr after tempMstVar
    end repeat
    put tempMstVar into mstVar -- replaced with rescaled distances
    delete tempMstVar -- cleanup
    ----- END RESCALING DISTANCES TO 0 - 100 SCALE -----
  end if
end minSpanningTree

--========== MATHEMATICAL ==========
on combiObjects rawData, @subsetArray -- returns ARRAY with all possible subsets of rawData
  put the number of lines in rawData into n -- # of objects
  put combinatorial(n) into subsets -- list all possible subsets, uses a numerial code
  ---------- Begin replace numerical code with "object names" ----------
  repeat for each line i in subsets
    repeat for each item j in i
      put j into whichObject
      put line whichObject of rawData & comma after aSubset
    end repeat
    delete the last char in aSubset -- remove unnecessary comma
    put aSubset & cr after subsetObjects
    delete aSubset -- clean up
  end repeat
  delete subsets -- clean up
  ---------- Begin replace numerical code with "object names" ----------
  ---------- Begin build array ----------
  repeat for each line i in subsetObjects
    put i & cr after subsetArray[(the number of items in i)] -- array will have n number of elements
  end repeat
  ---------- End build array ----------
end combiObjects

function combinatorial n -- returns all possible subsets of a set, where n = #  of objects in the set
  if n >= 15 then -- make sure you know what you're in for!
    answer n && "objects will result in" && (2^15 -1) && "subsets" with "Continue" or "Cancel"
    if it is "Cancel" then exit to MetaCard
  end if
  put 1 into subsetsVar -- initialize variable
  repeat until x = n -- this repeats (2^n - 2) times, which is one less than the numer of possible subsets
    put the last line in subsetsVar into x -- each subset is used as input to compute the next subset
    put the number of items in x into noItems
    if item noItems of x = n then
      add 1 to item (noItems -1) of x -- increment 2nd to last item if last item = n
      delete the last item of x -- get rid of last item if it = n
      put return & x after subsetsVar -- add another subset to list of subsets
    else
      put ((item noItems of x) + 1) into item (noItems + 1) of x -- increment last item
      put return & x after subsetsVar -- add another subset to list of subsets
    end if
  end repeat
  return subsetsVar -- return the list of all possible subsets
end combinatorial

function nComb n, r -- returns the # of combinations of n objects taken r at a time
  if (r > 0) And (r <= n) then
    if r = n then
      return 1
    else
      return factorial(n)/(factorial(r) * factorial(n - r))
    end if
  else
    Answer "nComb error:" && r && "is not between 0 and" && n
    exit to MetaCard
  end if
end nComb

function factorial x -- returns x!
  if x <= 1
  then return 1
  else return x * factorial(x-1)
end factorial

----------GRAPHICAL:----------
function vectorMagDir uVar, vVar -- returns magnitude & direction 2-dimensional vectors components
  -- rewrite this to handle 3-d vectors...test # of dimensions by the # of parameters
  -- atan2(y,x) will take into account which quadrant:
  put (atan2(vVar, uVar)*180/PI) + 270 into angleVar -- for vector plots, a vertical arrow pointed up has rotation of 0?
  if angleVar > 360 then subtract 360 from angleVar  --can't have rotation > 360
  put sqrt(uVar^2 + vVar^2) into magVar
  return round(magVar, 2) & comma & round(angleVar, 2)
end vectorMagDir

function xyzDist x, y, z, x2, y2, z2 -- returns the distance b/n 2 points in 3D space
  put sqrt((x - x2)^2 + (y - y2)^2 + (z - z2)^2) into distVar
  return distVar
end xyzDist

function xyzMidpoint x, y, z, x2, y2, z2 -- returns the midpoint of a 3D line
  return ((x + x2)/2 & "," & (y + y2)/2 & "," & (z + z2)/2)
end xyzMidpoint

function translateToOrigin x, y, z, x2, y2, z2 -- returns coordinates for a line translated to 0,0,0
  return "0,0,0," & (-x + x2) & "," & (-y + y2) & "," & (-z + z2)
end translateToOrigin

function transMat xyzVar, matrixVar -- returns transformed xyz coordinates after a transformation matrix
  -- THIS SCRIPT IS NOT REALLY NEED IF YOU USE matrixMultiply()
  if the number of items in xyzVar <> 3 then
    beeper
    answer "ERROR: transMat() requires 3 x,y,z values"
    exit to MetaCard
  end if
  if the number of items in matrixVar <> 9 then
    beeper
    answer "ERROR: transMat() requires 9 matrix values"
    exit to MetaCard
  end if
  put item 1 of xyzVar into xVar
  put item 2 of xyzVar into yVar
  put item 3 of xyzVar into zVar
  put item 1 of matrixVar into m11
  put item 2 of matrixVar into m12
  put item 3 of matrixVar into m13
  put item 4 of matrixVar into m21
  put item 5 of matrixVar into m22
  put item 6 of matrixVar into m23
  put item 7 of matrixVar into m31
  put item 8 of matrixVar into m32
  put item 9 of matrixVar into m33
  put (xVar * m11) + (yVar * m12) + (zVar * m13) into xVarNew
  put (xVar * m21) + (yVar * m22) + (zVar * m23) into yVarNew
  put (xVar * m31) + (yVar * m32) + (zVar * m33) into zVarNew
  return xVarNew & "," & yVarNew & "," & zVarNew
end transMat

----------OCEANOGRAPHIC:----------

function meanDepthOfOccurrence rawData, findSD -- returns the mean Depth-of-Occurrence of fish larvae (after Brodeur & Rugen, 1994)
  ----- BEGIN PARTITION DATA ACCORDING TO STATION -----
  put empty into stnArray -- initialize variable
  repeat for each line n in rawData
    put item 2 to 4 of n & cr after stnArray[item 1 of n] -- build an array
  end repeat
  ----- END PARTITION DATA ACCORDING TO STATION -----
  arrayRowLabels stnArray, stnList  -- create a list of stations
  ----- BEGIN CALCULATE DEPTH-OF-OCCURRENCE -----
  put the number of lines in stnList into noStations
  repeat with i = 1 to noStations
    put the number of lines in stnArray[line i of stnList] into noNets
    repeat with j = 1 to noNets
      put line j of stnArray[line i of stnList] into thisStation
      put (item 2 of thisStation * item 3 of thisStation) & comma after numNetsSum -- numerator
      put (item 3 of thisStation) & comma after denNetsSum -- denominator
    end repeat
    put sum(numNetsSum) & comma after numStnSum
    put sum(denNetsSum) & comma after denStnSum
    put empty into numNetsSum; put empty into denNetsSum -- cleanup
  end repeat
  put sum(numStnSum)/sum(denStnSum) into depthOfOccurrence
  if findSD = "YES" then -- calculate the Standard Deviation
    put comma & sdDepthOfOccurrence (stnArray, stnList, depthOfOccurrence) after depthOfOccurrence
  else -- don't calculate the Standard Deviation
  end if
  ----- END CALCULATE DEPTH-OF-OCCURRENCE -----
  return depthOfOccurrence -- if specified, the standard deviation is returned as item 2
end meanDepthOfOccurrence


function sdDepthOfOccurrence @stnArray, stnList, depthOfOccurrence -- returns the Standard Deviation for the mean Depth-of-Occurrence of fish larvae (after Brodeur & Rugen, 1994)
  put the number of lines in stnList into noStations
  ----- BEGIN CALCULATE VARIANCE -----
  repeat with k = 1 to noStations
    put 0 into stnDensity -- initialize variable
    repeat for each line l in stnArray[line k of stnList]
      add item 3 of l to stnDensity -- total density for this station
    end repeat
    ---------- BEGIN CALCULATE DEPTH-OF-OCCURRENCE JUST FOR THIS STATION ----------
    put the number of lines in stnArray[line k of stnList] into noNets
    repeat with h = 1 to noNets
      put line h of stnArray[line k of stnList] into thisStation
      put (item 2 of thisStation * item 3 of thisStation) & comma after numNetsSum -- numerator
      put (item 3 of thisStation) & comma after denNetsSum -- denominator
    end repeat
    if sum(denNetsSum) <> 0 then
      put sum(numNetsSum)/sum(denNetsSum) into thisDepthOfOccurrence
    else
      put 0 into thisDepthOfOccurrence
    end if
    put empty into numNetsSum; put empty into denNetsSum -- cleanup
    ---------- END CALCULATE DEPTH-OF-OCCURRENCE JUST FOR THIS STATION ----------
    put (stnDensity)^2 * (thisDepthOfOccurrence - depthOfOccurrence)^2 & comma after listCoefficient
    put stnDensity & comma after listDenominator
  end repeat
  put noStations into numerator
  put sum(listCoefficient) into coefficientVar
  put (sum(listDenominator))^2 * (numerator - 1) into denominator
  put empty into listCoefficient; put empty into listDenominator --cleanup
  put (numerator/denominator) * coefficientVar into theVariance
  put sqrt(theVariance) into theStdev -- square root of variance = standard deviation
  ----- END CALCULATE VARIANCE -----
  return theStdev
end sdDepthOfOccurrence

function ekman v -- returns "Cross-shore Ekman transport" in cm/sec
  -- input parameter v = alongshore component of wind vector that has been rotated to align
  -- with the 30 m isobath (from Yeung, C.  1996. Dissertation.  Univ. of Miami)
  return (0.0013 * 0.0015 * v * abs(v))/0.0000007
end ekman

function zCM stationVar -- calculate center of mass & standard error for a return-separated csv list: mean depth, width, stdev of depth, density
  put the number of lines in stationVar into noNets
  ----- BEGIN CALCULATE CENTER OF MASS -----
  ---------- BEGIN CALCULATE "P" ----------
  put 0 into denom -- initialize variable
  repeat for each line i in stationVar
    add (item 4 of i * item 2 of i) to denom
  end repeat
  repeat with j = 1 to noNets
    if denom = 0 then
      -- don't report zCM if density is zero
    else
      put round(((item 4 of line j of stationVar) * (item 2 of line j of stationVar))/denom, 4) into item 5 of line j of stationVar
    end if
  end repeat
  ---------- END CALCULATE "P" ----------
  put 0 into stnZCM -- initialize variable
  repeat for each line k in stationVar
    add (item 5 of k * item 1 of k) to stnZCM
  end repeat
  ----- END CALCULATE CENTER OF MASS -----
  ----- BEGIN CALCULATE STANDARE ERROR OF DEPTH -----
  repeat for each line m in stationVar
    put item 5 of m into Pvar
    if Pvar <> 0 then
      add (Pvar)^2 * (item 3 of m)^2 to numerator -- P^2 * SD^2
    else put noNets - 1 into noNets -- adjust n value for nets with 0 catch
  end repeat
  put sqrt(numerator)/sqrt(noNets) into stnZSE
  ----- END CALCULATE STANDARE ERROR OF DEPTH -----
  return round(stnZCM, 1) & comma & round(stnZSE, 1)
end zCM

function sigmaTee salinity, temp, depth -- returns density of seawater in mg/cm? based on "Eckart's equation"
  -- input is salinity in ppt, temp in ?C, and depth in meters
  put depth/10 into pressure -- converts to pressure in "atmospheres"
  put 1779.5 + (11.25 * temp) - (0.0745 * temp^2) - ((3.8 + (0.01 * temp)) * salinity) into gamma
  put 5890 + (38 * temp) - (0.3757 * temp^2) + (3 * salinity) into Po
  put (gamma/(pressure + Po)) + 0.6980 into alpha
  put (1/alpha - 1) * 1000 into density
  return round(density, 2)
end sigmaTee

function latLongDist lat1, long1, lat2, long2 -- returns distance b/n 2 geographic points in kilometers
  put (lat1 -  lat2) into deltaLat
  put (long1 - long2) into deltaLong
  put (lat1 + lat2)/2 into aveLat
  return (sqrt((deltaLat)^2 + ((deltaLong * cos(aveLat * (PI/180)))^2))) * (60 * 1.852)
end latLongDist

----------DATE & TIME:----------
function hmsToDec hmsHrs -- returns decimal hrs from "hrs:min:sec"; also converts DMS to decimal degrees
  set the itemDelimiter to ":"
  put item 1 of hmsHrs into hrsVar
  put item 2 of hmsHrs into minVar
  put item 3 of hmsHrs into secVar
  return ((secVar/60 + minVar)/60 + hrsVar)  -- add 12 to this number if time given on 12-hr clock & it is pm
end hmsToDec

function decToHms decHrs -- returns "hrs:min:sec" from decimal hrs.
  put trunc(decHrs) into hrsVar -- integer part of decHrs
  put (decHrs - hrsVar) into fVar -- fractional part of decHrs
  put trunc(fVar * 60) into minVar
  put ((fVar * 60) - minVar) * 60 into secVar
  set the numberFormat to 00.#
  return hrsVar & ":" & minVar & ":" & round(secVar) --rounds to nearest sec
end decToHms

function decToDMS decHrs -- converts decimal degrees to deg,min,sec
  put trunc(decHrs) into hrsVar -- integer part of decHrs
  put (decHrs - hrsVar) into fVar -- fractional part  of decHrs
  put trunc(fVar * 60 ) into minVar
  put ((fVar * 60) - minVar) * 60 into secVar
  return hrsVar & "," && minVar & "," && round(secVar) -- rounds to nearest sec
end decToDMS

function dayNum month, day, yr  -- p. 5
  if leapYr(yr) = true then put 62 into var1 else put 63 into var1
  if month <= 2  then
    put ((month -1) * var1)/2 into A
    return trunc(A) + day
  else
    put ((month + 1) * 30.6) into B
    put trunc(B) into C
    put (C - var1) + day into D
    return D
  end if
end dayNum

function leapYr yr  --returns true if it is a leap year
  if (yr < 1901) or (yr > 2999) then
    Answer "Error: year not b/n 1901-2999"
    exit to Metacard
  end if
  if yr/4 - (trunc(yr/4)) = 0 then return true
  else return false
end leapYr

function julianDate month, day, yr  --a modified julian date since = days from 1/1/1900
  if month <= 2 then
    put yr -1 into yr2
    put month + 12 into month2
  else
    put yr into yr2
    put month into month2
  end if
  if yr >= 1900 then
    put trunc(yr2/100) into A
    put (2 - A) + (trunc(A/4)) into B
  else
    Answer "Error: year must be 1900 or later"
    exit to Metacard
  end if
  if yr2 < 0 then put trunc((365.25 * yr2) - 0.75) into C else put trunc(365.25 * yr2) into C
  put trunc(30.6001 * (month2 + 1)) into D
  return (B + C + D + day + 1720994.5) - (2415020.5) --substract julian date for 1/1/1900
end julianDate

function gregorianDate JD   --converts julianDate to gregorianDate for dates > 1 Jan 1900
  put (JD + 0.5) + (2415020.5) into var1 --add julian date for 1/1/1900
  put trunc(var1) into I --integer part
  put var1 - I into F --fractional part
  if I > 2299160 then
    put trunc((I - 1867216.25)/36524.25) into A
    put I + 1 + A - trunc(A/4) into B
  else
    put I into B
  end if
  put B + 1524 into C
  put trunc((C - 122.1)/365.25) into D
  put trunc(D * 365.25) into E
  put trunc((C - E)/30.6001) into G
  put C - E + F - trunc(G * 30.6001) into day
  if G < 13.5 then put G - 1 into month
  if G > 13.5 then put G - 13 into month
  if month > 2.5 then put D - 4716 into yr
  if month < 2.5 then put D - 4715 into yr
  return month &"," & day &"," & yr
end gregorianDate

function numToMonth numVar -- returns the Month spelled out
  put "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" into monthList
  put item numVar of monthList into monthText
  if monthText is empty then
    beep
    answer "ERROR: input paramater for numToMonth out of range"
    exit to MetaCard
  else
    return monthText
  end if
end numToMonth


--========== Old "Array" Handlers (from WinPlus before associative arrays==========
function arrayColumns arrayVar -- returns a list of column labels of a csv matrix
  return line 1 of arrayVar
end arrayColumns

function arrayRows arrayVar -- returns a list of row labels of a csv matrix
  delete line 1 of arrayVar
  repeat for each line i in arrayVar
    put item 1 of i & comma after arrayRowsVar
  end repeat
  return arrayRowsVar
end arrayRows

function deleteLabelsArray arrayVar -- returns a csv matrix with row and column labels deleted
  put the number of items in line 1 of arrayVar into noOfItems
  delete line 1 of arrayVar -- remove column labels
  repeat for each line i in arrayVar
    put i into lineVar
    delete item 1 of lineVar
    put lineVar & cr after newArrayVar
  end repeat
  return newArrayVar
end deleteLabelsArray

function insertLabelsArray arrayVar, col, row -- returns a csv matrix with row and column labels inserted
  repeat with i = 1 to the number of items in col
    put item i of row & comma before item 1 of line i of arrayVar
  end repeat
  put col & return before arrayVar
  return arrayVar
end insertLabelsArray

function transpose arrayVar -- returns a transposed csv matrix
  repeat with n = 1 to the number of items in line 1 of arrayVar
    repeat with m = 1 to the number of lines in arrayVar
      put item n of line m of arrayVar into item m of line n of transposedArrayVar
    end repeat
  end repeat
  return transposedArrayVar
end transpose

function matrixMultiply A, B -- returns [A]*[B]; generally you transform [B] with [A]
  -- after script by Adrian Sutton" <z1419539@cit.gu.edu.au>
  ----- BEGIN CHECK MATRIX SIZE -----
  put the number of items in line 1 of matrix_A into noItemsA
  put the number of lines in matrix_B into noRowsB
  if noItemsA <> noRowsB then --required to perform matrix multiplication
    Answer "Error: # columns in 1st matrix <> # rows in 2nd matrix"
    exit to MetaCard
  end if
  ----- END CHECK MATRIX SIZE -----
  put "" into X -- Our new matrix which equals AxB
  put the number of items in line 1 of A into r
  put the number of lines in A into m
  put the number of items in line 1 of B into c
  repeat with j = 1 to m
    repeat with k = 1 to c
      repeat with i = 1 to r
        add (item i of line j of A * item k of line i of B) to item k of line j of X
      end repeat
    end repeat
  end repeat
  return X
end matrixMultiply

function matrixInversion rawMatrix -- returns the inverse of a matrix
  put the number of lines in rawMatrix into rows -- # rows in matrix
  put the number of items in line 1 of rawMatrix into cols -- # cols in matrix
  ----- BEGIN CHECK IF ANY DIAGONAL = 0 -----
  repeat with z = 1 to rows
    if item z of line z of rawMatrix = 0 then
      answer "Inverse of matix with 0 in diagonal is undefined"
      exit to MetaCard
    end if
  end repeat
  ----- END CHECK IF ANY DIAGONAL = 0 -----
  ----- BEGIN CREATE IDENTITY MATRIX -----
  put 0 into counter -- initialize variable
  repeat with i = 1 to rows
    repeat with j = 1 to cols
      put "0" into item j of line i of idMatrix
    end repeat
    add 1 to counter
    put 1 into item counter of line i of idMatrix
  end repeat
  ----- END CREATE IDENTITY MATRIX -----
  ----- BEGIN CREATE AUGMENTED MATRIX -----
  repeat with i = 1 to rows
    put line i of rawMatrix & comma & line i of idMatrix after line i of augMatrix
  end repeat
  ----- END CREATE AUGMENTED MATRIX -----
  ----- BEGIN INVERSION -----
  put idMatrix into transMatrix -- initialize transMatrix
  repeat with i = 1 to cols
    put idMatrix into transMatrix -- initialize transMatrix
    repeat with j = 1 to rows
      if i = j then
        put 1/(item i of line j of augMatrix) into item i of line j of transMatrix
      else
        put -1 *(item i of line j of augMatrix)/(item i of line i of augMatrix) into item i of line j of transMatrix
      end if
    end repeat
    put matrixMultiply(transMatrix, augMatrix) into augMatrix
  end repeat
  ----- END INVERSION -----
  ----- BEGIN REMOVE ID MATRIX -----
  repeat with m = 1 to rows
    delete item 1 to cols in line m of augMatrix
  end repeat
  ----- END REMOVE ID MATRIX -----
  # if matrixMultiply(augMatrix, rawMatrix) <> idMatrix then
  # answer "There is no inverse to this matrix"
  # exit to MetaCard
  # else
  return augMatrix
end matrixInversion

function matrixSubtraction A, B -- returns [A] - [B]
  put the number of lines in A into rowsA
  put the number of items in line 1 of A into colsA
  put the number of lines in B into rowsB
  put the number of items in line 1 of B into colsB
  if (rowsA <> rowsB) Or (colsA <> colsB) then
    answer "Matrices must have the same dimensions for subtraction"
    exit to MetaCard
  else
    repeat with i = 1 to rowsA
      repeat with j = 1 to colsA
        put (item j of line i of A - item j of line i of B) into item j of line i of C
      end repeat
    end repeat
  end if
  return C
end matrixSubtraction

function matrixAddition A, B -- returns [A] + [B]
  put the number of lines in A into rowsA
  put the number of items in line 1 of A into colsA
  put the number of lines in B into rowsB
  put the number of items in line 1 of B into colsB
  if (rowsA <> rowsB) Or (colsA <> colsB) then
    answer "Matrices must have the same dimensions for addition"
    exit to MetaCard
  else
    repeat with i = 1 to rowsA
      repeat with j = 1 to colsA
        put (item j of line i of A + item j of line i of B) into item j of line i of C
      end repeat
    end repeat
  end if
  return C
end matrixAddition
  w         ??????  ??????  ?????? white ??????  ??????    k           	jonesLib     ??     U 
helvetica  	JonesLib   ?    	@             ?
  ?   	          ? ?        ?,Here is a library of misc. functions and handlers for processing arrays, matrices, dates/times, and statistical multivariate analysis. Please send any comments and suggestions for improvements to Dave Jones (djones@rsmas.miami.edu). Scott, please incorporate any of these you can into the MC engine.       