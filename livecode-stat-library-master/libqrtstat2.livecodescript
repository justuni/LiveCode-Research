script "libqrtstat2"
/*
Quartam Statistical Functions Library for LiveCode [libqrtstat.livecode]
Copyright (C) 2011-2016 Quartam Software / Jan Schenkel

This program is free software; you can redistribute it and/or modify 
it under the terms of the GNU Lesser General Public License as 
published by the Free Software Foundation, either version 3 of the 
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License 
along with this program.  If not, see <http://www.gnu.org/licenses>.

You can be released from the requirements of the license by purchasing a 
commercial license.

For more information, please contact Quartam Software at this address:
licenses@quartam.com
*/

/*	
ACKNOWLEDGEMENTS:
- Quartile algorithms adapted from: https://en.wikipedia.org/wiki/Quartile
- Control limits, family limits, capability algorithms adapted from: http://www.jlion.com/docs/statscalcs.aspx
*/

--> constants

constant kLibVersion = "2.0.0"
constant kLibErrorPrefix = "qrtstaterr: "

-- comma-separated list of supported algorithms
constant kQuartileAlgorithms = "excludeMedian,includeMedian,weightedAverage"

-- default setting keys	
constant kDefaultQuartileAlgorithm = "QuartileAlgorithm"

--> script local variables

local sDefaultsA
local sLC61OrNewer, sLC66OrNewer

--> engine message handlers

on libraryStack
   if the target is me then
      p_qrtSTAT_ResetAll
   end if
   pass libraryStack
end libraryStack

--> public commands and functions

function qrtSTAT_Version
   return kLibVersion
end qrtSTAT_Version

function qrtSTAT_VersionNumber
   -- deprecated synonym
   return qrtSTAT_Version()
end qrtSTAT_VersionNumber

function qrtSTAT_QuartileAlgorithms
   -- return-delimited list of supported quartile algorithms
   local tQuartileAlgorithms
   put kQuartileAlgorithms into tQuartileAlgorithms
   replace comma with return in tQuartileAlgorithms
   return tQuartileAlgorithms
end qrtSTAT_QuartileAlgorithms

function qrtSTAT_QuartileAlgorithm
   returns sDefaultsA[kDefaultQuartileAlgorithm]
end qrtSTAT_QuartileAlgorithm

command qrtSTAT_SetQuartileAlgorithm pQuartileAlgorithm
   p_qrtSTAT_AssertQuartileAlgorithm pQuartileAlgorithm
   put pQuartileAlgorithm into sDefaultsA[kDefaultQuartileAlgorithm]
end qrtSTAT_SetQuartileAlgorithm

command qrtSTAT_ResetAll
   p_qrtSTAT_ResetAll
end qrtSTAT_ResetAll

function qrtSTAT_AverageDeviation pNumbersList
   -- fast path in case of LiveCode 6.6 or newer
   if sLC66OrNewer then return averageDeviation(pNumbersList)
   -- slow path in older versions
   local tCount
   if pNumbersList is an array then
      put the number of elements in pNumbersList into tCount
   else
      put the number of items in pNumbersList into tCount
   end if
   --
   if tCount is 0 then
      return 0
   else
      local tMean, tAbsDevSum
      put average(pNumbersList) into tMean
      if pNumbersList is an array then
         repeat for each element tNumber in pNumbersList
            add abs(tNumber - tMean) to tAbsDevSum
         end repeat
      else
         repeat for each item tNumber in pNumbersList
            add abs(tNumber - tMean) to tAbsDevSum
         end repeat
      end if
      return tAbsDevSum / tCount
   end if
end qrtSTAT_AverageDeviation

function qrtSTAT_Capability pNumbersList, pSpecLowerLimit, pSpecUpperLimit
   local tSixSigma
   put 6 * standardDeviation(pNumbersList) into tSixSigma
   if tSixSigma <> 0 then
      return (pSpecUpperLimit - pSpecLowerLimit) / tSixSigma
   else
      return 0
   end if
end qrtSTAT_Capability

function qrtSTAT_CapabilityIndex pNumbersList, pSpecLowerLimit, pSpecUpperLimit
   local tAverage, tThreeSigma
   put average(pNumbersList) into tAverage
   put 3 * standardDeviation(pNumbersList) into tThreeSigma
   if tThreeSigma <> 0 then
      local tCPKHigh, tCPKLow
      put (pSpecUpperLimit - tAverage) / tThreeSigma into tCPKHigh
      put (tAverage - pSpecLowerLimit) / tThreeSigma into tCPKLow
      return min(tCPKLow, tCPKHigh)
   else
      return 0
   end if
   return (tAverage - tThreeSigma),(tAverage + tThreeSigma)
end qrtSTAT_CapabilityIndex

function qrtSTAT_ControlLimits pNumbersList
   local tAverage, tThreeSigma
   put average(pNumbersList) into tAverage
   put 3 * standardDeviation(pNumbersList) into tThreeSigma
   return (tAverage - tThreeSigma),(tAverage + tThreeSigma)
end qrtSTAT_ControlLimits

function qrtSTAT_FamilyLimits pNumbersList, pQuartileAlgorithm
   if pQuartileAlgorithm is empty then
      put sDefaultsA[kDefaultQuartileAlgorithm] into pQuartileAlgorithm
   else
      p_qrtSTAT_AssertQuartileAlgorithm pQuartileAlgorithm
   end if
   --
   local tQuartiles, tFirstQuartile, tThirdQuartile, tInterQuartileRange
   put p_qrtSTAT_Quartiles(pNumbersList, pQuartileAlgorithm, true, false, true) into tQuartiles
   put item 1 of tQuartiles into tFirstQuartile
   put item 3 of tQuartiles into tThirdQuartile
   put tThirdQuartile - tFirstQuartile into tInterQuartileRange
   return (tFirstQuartile - 1.5 * tInterQuartileRange),(tThirdQuartile + 1.5 * tInterQuartileRange)
end qrtSTAT_FamilyLimits

function qrtSTAT_GeometricMean pNumbersList
   -- fast path in case of LiveCode 6.1 or newer
   if sLC61OrNewer then return geometricMean(pNumbersList)
   -- slow path in older versions
   local tCount
   if pNumbersList is an array then
      put the number of elements in pNumbersList into tCount
   else
      put the number of items in pNumbersList into tCount
   end if
   --
   if tCount is 0 then
      return 0
   else
      local tGeometricMean, tPower
      put 1 into tGeometricMean
      put 1 / tCount into tPower
      if pNumbersList is an array then
         repeat for each element tNumber in pNumbersList
            multiply tGeometricMean by tNumber ^ tPower
         end repeat
      else
         repeat for each item tNumber in pNumbersList
            multiply tGeometricMean by tNumber ^ tPower
         end repeat
      end if
      return tGeometricMean
   end if
end qrtSTAT_GeometricMean

function qrtSTAT_HarmonicMean pNumbersList
   -- fast path in case of LiveCode 6.1 or newer
   if sLC61OrNewer then return harmonicMean(pNumbersList)
   -- slow path in older versions
   local tCount
   if pNumbersList is an array then
      put the number of elements in pNumbersList into tCount
   else
      put the number of items in pNumbersList into tCount
   end if
   --
   if tCount is 0 then
      return 0
   else
      local tReciprocalSum
      if pNumbersList is an array then
         repeat for each element tNumber in pNumbersList
            add 1 / tNumber to tReciprocalSum
         end repeat
      else
         repeat for each item tNumber in pNumbersList
            add 1 / tNumber to tReciprocalSum
         end repeat
      end if
      return tCount / tReciprocalSum
   end if
end qrtSTAT_HarmonicMean

function qrtSTAT_InterQuartileRange pNumbersList, pQuartileAlgorithm
   if pQuartileAlgorithm is empty then
      put sDefaultsA[kDefaultQuartileAlgorithm] into pQuartileAlgorithm
   else
      p_qrtSTAT_AssertQuartileAlgorithm pQuartileAlgorithm
   end if
   --
   local tQuartiles
   put p_qrtSTAT_Quartiles(pNumbersList, pQuartileAlgorithm, true, false, true) into tQuartiles
   return (item 3 of tQuartiles) - (item 1 of tQuartiles)
end qrtSTAT_InterQuartileRange

function qrtSTAT_Midhinge pNumbersList, pQuartileAlgorithm
   if pQuartileAlgorithm is empty then
      put sDefaultsA[kDefaultQuartileAlgorithm] into pQuartileAlgorithm
   else
      p_qrtSTAT_AssertQuartileAlgorithm pQuartileAlgorithm
   end if
   --
   local tQuartiles
   put p_qrtSTAT_Quartiles(pNumbersList, pQuartileAlgorithm, true, false, true) into tQuartiles
   return ((item 1 of tQuartiles) + (item 3 of tQuartiles)) / 2
end qrtSTAT_Midhinge

function qrtSTAT_Mode pNumbersList
   local tNumber, tNumberOccurencesA
   if pNumbersList is an array then
      repeat for each element tNumber in pNumbersList
         add 1 to tNumberOccurencesA[tNumber]
      end repeat
   else
      repeat for each item tNumber in pNumbersList
         add 1 to tNumberOccurencesA[tNumber]
      end repeat
   end if
   --
   local tMaxOccurences
   put max(tNumberOccurencesA) into tMaxOccurences
   --
   local tMode
   repeat for each key tNumber in tNumberOccurencesA
      if tNumberOccurencesA[tNumber] = tMaxOccurences then
         put tNumber & comma after tMode
      end if
   end repeat
   return char 1 to -2 of tMode -- strip off trailing comma
end qrtSTAT_Mode

function qrtSTAT_PopulationStandardDeviation pNumbersList
   -- fast path in case of LiveCode 6.1 or newer
   if sLC61OrNewer then return populationStandardDeviation(pNumbersList)
   -- slow path in older versions
   return sqrt(qrtSTAT_PopulationVariance(pNumbersList))
end qrtSTAT_PopulationStandardDeviation

function qrtSTAT_PopulationVariance pNumbersList
   -- fast path in case of LiveCode 6.1 or newer
   if sLC61OrNewer then return populationVariance(pNumbersList)
   -- slow path in older versions
   local tCount
   if pNumbersList is an array then
      put the number of elements in pNumbersList into tCount
   else
      put the number of items in pNumbersList into tCount
   end if
   --
   if tCount is 0 then
      return 0
   else
      local tMean, tDeviationSum
      put average(pNumbersList) into tMean
      if pNumbersList is an array then
         repeat for each element tNumber in pNumbersList
            add (tNumber - tMean) ^ 2 to tDeviationSum
         end repeat
      else
         repeat for each item tNumber in pNumbersList
            add (tNumber - tMean) ^ 2 to tDeviationSum
         end repeat
      end if
      return tDeviationSum / tCount
   end if
end qrtSTAT_PopulationVariance

function qrtSTAT_Quartiles pNumbersList, pQuartileAlgorithm
   if pQuartileAlgorithm is empty then
      put sDefaultsA[kDefaultQuartileAlgorithm] into pQuartileAlgorithm
   else
      p_qrtSTAT_AssertQuartileAlgorithm pQuartileAlgorithm
   end if
   --
   return p_qrtSTAT_Quartiles(pNumbersList, pQuartileAlgorithm, true, true, true)
end qrtSTAT_Quartiles

function qrtSTAT_Trimean pNumbersList, pQuartileAlgorithm
   if pQuartileAlgorithm is empty then
      put sDefaultsA[kDefaultQuartileAlgorithm] into pQuartileAlgorithm
   else
      p_qrtSTAT_AssertQuartileAlgorithm pQuartileAlgorithm
   end if
   --
   local tQuartiles
   put p_qrtSTAT_Quartiles(pNumbersList, pQuartileAlgorithm, true, true, true) into tQuartiles
   return ((item 1 of tQuartiles) + 2 * (item 2 of tQuartiles) + (item 3 of tQuartiles)) / 4
end qrtSTAT_Trimean

--> private commands and functions

private command p_qrtSTAT_ResetAll
   set the itemDelimiter to "."
   put (item 1 to 2 of the version) >= 6.1 into sLC61OrNewer
   put (item 1 to 2 of the version) >= 6.6 into sLC66OrNewer
   put "weightedAverage" into sDefaultsA[kDefaultQuartileAlgorithm]
end p_qrtSTAT_ResetAll

private command p_qrtSTAT_AssertQuartileAlgorithm pAlgorithm
   if pAlgorithm is not among the items of kQuartileAlgorithms then	
      throw kLibErrorPrefix & "QuartileAlgorithm must be one of '" & kQuartileAlgorithms & "'"
   end if
end p_qrtSTAT_AssertQuartileAlgorithm

private function p_qrtSTAT_Quartiles @pNumbersList, pQuartileAlgorithm, pCalcQ1, pCalcQ2, pCalcQ3
   local tSortedNumbersList, tCount
   if pNumbersList is an array then
      p_qrtSTAT_ConvertNumbersArrayToList pNumbersList, tSortedNumbersList, tCount
   else
      put pNumbersList into tSortedNumbersList
      put the number of items in pNumbersList into tCount
   end if
   sort tSortedNumbersList ascending numeric
   --
   local tQ1, tQ2, tQ3
   if pCalcQ2 then
      put p_qrtSTAT_SortedNumbersSubListMedian(tSortedNumbersList, 1, tCount) into tQ2
   end if
   local tQ2End, tQ3Start
   if tCount mod 2 = 0 then
      put tCount div 2 into tQ2End
      put tQ2End + 1 into tQ3Start
      if pCalcQ1 then
         put p_qrtSTAT_SortedNumbersSubListMedian(tSortedNumbersList, 1, tQ2End) into tQ1
      end if
      if pCalcQ3 then
         put p_qrtSTAT_SortedNumbersSubListMedian(tSortedNumbersList, tQ3Start, tCount) into tQ3
      end if
   else
      switch pQuartileAlgorithm
         case "excludeMedian"
            -- corresponds to Method 1 in the Wikipedia article
            put tCount div 2 into tQ2End
            put tQ2End + 1 into tQ3Start
            if pCalcQ1 then
               put p_qrtSTAT_SortedNumbersSubListMedian(tSortedNumbersList, 1, tQ2End) into tQ1
            end if
            if pCalcQ3 then
               put p_qrtSTAT_SortedNumbersSubListMedian(tSortedNumbersList, tQ3Start, tCount) into tQ3
            end if
            break
         case "includeMedian"
            -- corresponds to Method 2 in the Wikipedia article
            put tCount div 2 + 1 into tQ2End
            put tQ2End into tQ3Start
            if pCalcQ1 then
               put p_qrtSTAT_SortedNumbersSubListMedian(tSortedNumbersList, 1, tQ2End) into tQ1
            end if
            if pCalcQ3 then
               put p_qrtSTAT_SortedNumbersSubListMedian(tSortedNumbersList, tQ3Start, tCount) into tQ3
            end if
            break
         case "weightedAverage"
            -- corresponds to Method 3 in the Wikipedia article
            local tQIndex
            put tCount div 4 into tQIndex
            if tCount mod 4 = 1 then
               if pCalcQ1 then
                  put (1 / 4) * (item tQIndex of tSortedNumbersList) + (3 / 4) * (item tQIndex + 1 of tSortedNumbersList) into tQ1
               end if
               if pCalcQ3 then
                  put (3 / 4) * (item 3 * tQIndex + 1 of tSortedNumbersList) + (1 / 4) * (item 3 * tQIndex + 1 of tSortedNumbersList) into tQ3
               end if
            else if tCount mod 4 = 3 then
               if pCalcQ1 then
                  put (3 / 4) * (item tQIndex + 1 of tSortedNumbersList) + (1 / 4) * (item tQIndex + 2 of tSortedNumbersList) into tQ1
               end if
               if pCalcQ3 then
                  put (1 / 4) * (item 3 * tQIndex + 2 of tSortedNumbersList) + (3 / 4) * (item 3 * tQIndex + 3 of tSortedNumbersList) into tQ3
               end if
            end if
            break
      end switch
   end if
   return (tQ1,tQ2,tQ3)
end p_qrtSTAT_Quartiles

private command p_qrtSTAT_ConvertNumbersArrayToList @pNumbersArray, @rNumbersList, @rCount
   put empty into rNumbersList
   put 0 into rCount
   repeat for each element tNumber in pNumbersArray
      put tNumber & comma after rNumbersList
      add 1 to rCount
   end repeat
   delete char -1 of rNumbersList
end p_qrtSTAT_ConvertNumbersArrayToList

private function p_qrtSTAT_SortedNumbersSubListMedian @pSortedNumbersList, pStartIndex, pEndIndex
   local tRangeSize, tMidIndex
   put pEndIndex - pStartIndex + 1 into tRangeSize
   put pStartIndex + tRangeSize div 2 into tMidIndex
   if tRangeSize mod 2 = 0 then
      return ((item tMidIndex - 1 of pSortedNumbersList) + (item tMidIndex of pSortedNumbersList)) / 2
   else
      return item tMidIndex of pSortedNumbersList
   end if
end p_qrtSTAT_SortedNumbersSubListMedian
