
######################################
#
# ### pragcon stim cx praat script ###
#
# >> extracts bits from big soundfile 
#    containing multiple stims
# >> big soundfile & textgrid are 
#    assumed to already be loaded up  
#    in the objects window
# 
# org of big soundfile's textgrid:
# >> first interval tier: contains 
#    intervals corresponding to each 
#    item and labeled with stim name
#    (target noun, e.g. "umbrella")
# >> second interval tier: contains 
#    either nothing (filler) or onset
#    & offset of target adj & noun
#
# automatically saves output .wavs
# to soundfiles directory with 
# intensity scaled to 60 db
#
######################################


form Name of soundfile+textgrid
    word name pragcon3
endform

outputdir$ = "C:\Users\meredith\Dropbox\Meredith_CenterAppliedResearch_visualworldERP\stimuli\soundfiles\"

### tier 1: divides soundfile by items
select TextGrid 'name$'
numItems = Get number of intervals... 1  

for k from 1 to numItems

    select TextGrid 'name$'
    itemname$ = Get label of interval... 1 k

    ### if this interval corresponds to a labeled item, extract its tier 2 bits
    if length(itemname$) > 1
    
        intervalstart = Get start point... 1 k
        intervalend = Get end point... 1 k
	select Sound 'name$'
        Extract part: intervalstart, intervalend, "rectangular", 1, "no"
        Scale intensity: 60
	Write to WAV file... 'outputdir$''itemname$'.wav
	Remove
 
    endif
endfor

