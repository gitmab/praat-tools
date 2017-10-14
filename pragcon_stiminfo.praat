#---- SCRIPT TO EXTRACT TEXTGRID INFO ----#
#
# extracts time info from critical & filler items
# file onset, {adj onset, n onset, n offset}, file offset (dur)
#
# this version assumes multiple recording files each containing multiple stimuli,
# annotated with textgrids with two interval tiers: 
# (1) intervals delimiting start and end of each stimulus, each labeled with stim name;
# (2) for each critical item, two intervals delimiting start and end of words of interest
#     (in this case, an adjective labeled "a" and a noun labeled "n"
#
# writes item label, type, and duration information to a text file for all items

#---- SETUP ----#

# location of recordings and textgrids
inputdir$ = "C:\Users\mbrown07\Dropbox\Meredith_CenterAppliedResearch_visualworldERP\stimuli\recordings\"

# saves text file in output folder
directory$ = "C:\Users\mbrown07\Dropbox\Meredith_CenterAppliedResearch_visualworldERP\stimuli\"
filename$ = "measurements.txt"

# removes any existing instance of filename$
filedelete 'directory$''filename$'

# clear info window
clearinfo

# print headers to info window 
	print soundfile
	printtab
	print itemtype
	printtab
	print adjonset
	printtab
	print nonset
	printtab
	print noffset
	printtab
	print totalduration
	printline

#---- CRITICAL ITEMS ----#

# iterates through all soundfiles in directory
Create Strings as file list... list 'inputdir$'*.wav
filenum = Get number of strings

for stimfilenum from 1 to filenum

	# get both soundfile and textgrid
	select Strings list
	soundfile$ = Get string... 'stimfilenum'
	Read from file... 'inputdir$''soundfile$'
	stimname$ = selected$ ("Sound")
	Read from file... 'inputdir$''stimname$'.TextGrid

	# get number of intervals in first tier of textgrid
	numItems = Get number of intervals... 1

	# iterate thru items
	for k from 1 to numItems
		
		select TextGrid 'stimname$'
		itemname$ = Get label of interval... 1 k

		if length(itemname$) > 1

			intervalstart = Get start point... 1 k
        		intervalend = Get end point... 1 k
			Extract part: intervalstart, intervalend, "no"
			dur = Get total duration
			isCrit = Get number of intervals... 2
			itemtype$ = "filler"

			# identify critical items based on interval labels
			if isCrit > 1
	    		    isDefCrit$ = Get label of interval: 2, 2
	    		    if isDefCrit$="a"
				itemtype$ = "crit"
				adjonset = Get start point: 2, 2
				nonset = Get start point: 2, 3
				noffset = Get end point: 2, 3
			    endif
			endif
			
			Remove

			print 'itemname$'
			printtab
			print 'itemtype$'
			printtab

			# different output for critical & filler
			if itemtype$ = "crit"
				print 'adjonset:3'
				printtab
				print 'nonset:3'
				printtab
				print 'noffset:3'
				printtab
			else
				printtab
				printtab
				printtab
			endif

			print 'dur:3'
			printline

	    	endif
	endfor

	select TextGrid 'stimname$'
	plus Sound 'stimname$'
	Remove

endfor

select Strings list
Remove


#---- write to file ----#

fappendinfo 'directory$''filename$'