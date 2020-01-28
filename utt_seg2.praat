#jeanphilippegoldman@gmail.com
#mornex-les-bains déc 06
#22déc bug with one-pphrase file

form 1.Macro-segmentation: creates ortho tier from Sound and Strings
  comment select a Sound and a Strings object
  word text_tier ortho
  comment After macro-segmentation,
  boolean open_sound_and_tg 1
endform

include utils.praat
alpha=0.25
silence_detection = -25
minimal_silence_duration = 0.2
minimal_utterance_duration = 0.1
keep_silence_tier = 0

basename$=""
nso=numberOfSelected("Sound")
nst=numberOfSelected("Strings")

if nst=1 and nso=1
  basename$=selected$("Strings")
  stringsID=selected("Strings")
  soundID=selected("Sound")
  sound$=selected$("Sound")
else
  exit Select exactly one Sound and one Strings object
endif

####SILENCE DETECTION
select 'soundID'
d= Get total duration
To TextGrid (silences)... 100 0 'silence_detection' 'minimal_silence_duration' 'minimal_utterance_duration' #
Insert interval tier... 2 'text_tier$'
tgID=selected("TextGrid")
Rename... 'sound$'

####CLEAN TEXT STRINGS
select 'stringsID'
  n = Get number of strings
  lb=0
  la=0
  for i to n
    select 'stringsID'
    s$ = Get string... 'i' 
    lb=lb+length(s$)
    call mystrip 0 0 0 's$'
    la=la+length(mystrip.arg$)
    Set string... 'i' 'mystrip.arg$'
  endfor
printline ###EASYALIGN: Segment in utterances
printline Using Strings 'basename$'...
printline Lines : 'n' strings
printline Length 'la' caracters after cleanup ('lb' before) 

####FINDING BOUNDARIES
timepos=0  ; d=duration
textpos=1  ;la=textlength
curry=1
nv=0
nnv=0
for i to n
  select 'stringsID'
  s$ = Get string... 'i'
  if length(s$)>0
    nv=nv+1
    call getTA timepos 1   ; get remaining articulation time
    estimated_dur = getTA.ta * length(s$) / (la-textpos)
    call gettime timepos estimated_dur 1
    l2=la-textpos
    l3=length(s$)
    t2=timepos+estimated_dur
     #printline timepos la la-textpos length(s$) getTA.ta estimated_dur
     #printline 'timepos' 'la' 'l2' 'l3' 'getTA.ta' 'estimated_dur'
     #printline time 't2' > 'gettime.time'
    estimated_dur = gettime.time 
    estimated_dur = estimated_dur - timepos
     #printline new estim_dur : 'estimated_dur'
    
    t1=timepos+(1-alpha)*estimated_dur
    t2=min(d,timepos+(1+alpha)*estimated_dur)
    i1=Get interval at time... 1 't1'
    i2=Get interval at time... 1 't2'
     #printline 't1' 'i1' 't2' 'i2'
    maxdur=0
    maxdurj=-1
    for j from i1 to i2
      l$ = Get label of interval... 1 'j'
      if l$="#"
        sp=Get starting point... 1 'j'
        ep=Get end point... 1 'j'
        mp=(sp+ep)/2
        # printline textpause 'j' 'sp' 'ep' 'maxdur'
        if ep-sp>maxdur
          maxdurj=j
          maxdurmp=mp
          maxdur=ep-sp
        endif
      endif  
    endfor
     #printline maxdur
     #printline 'maxdurj' 'maxdurmp' 'maxdur' 't1' 't2'
    if maxdurj!=-1
      estimated_dur=maxdurmp-timepos
    endif

    timepos = timepos + estimated_dur
     #printline timepos 'timepos'
     #printline
    select 'tgID'
    if timepos>0 and timepos<d and i<n 
       #printline 'i'/'n' boundary at 'timepos'
      Insert boundary... 2 'timepos'
    endif
    Set interval text... 2 'curry' 's$'
    textpos=textpos+length(s$)
    curry=curry+1 ; miam!
  else 
    nnv=nnv+1
  endif
endfor

if nv>0
  printline Created ortho tier with 'nv' intervals
endif
if nnv>0
  printline 'nnv' non valid lines were ignored (empty or punctuation only)
endif
printline Don't forget to save your new TextGrid !!

if keep_silence_tier==0
  select 'tgID'
  Remove tier... 1
endif

if open_sound_and_tg
  select 'tgID'
  plus 'soundID'
  Edit
endif

exit

procedure getTA .start .tier
  select 'tgID'
  .si= Get interval at time... '.tier' '.start'
  .l$=Get label of interval... '.tier' '.si'
  .ni = Get number of intervals... '.tier'
   if .l$="#"
    .si=.si+1   ; check if not at the end
    if .si<=.ni
      .sp=Get starting point... '.tier' '.si'
      .ep=Get end point... '.tier' '.si'
      .ta=.ep-.sp
#      printline started in silence int '.ta' si in now '.si' 
    else
      .ta=0 
#      printline started in last silence int '.ta'

    endif
  else
    .ep=Get end point... '.tier' '.si'
    .ta=.ep-.start
#    printline started in speech. first int fgives '.ta'
  endif
  
  for .i from .si+1 to .ni
    .l$=Get label of interval... '.tier' '.i'
 #   printline '.i' "'.l$'"
    if .l$!="#"
      .sp=Get starting point... '.tier' '.i'
      .ep=Get end point... '.tier' '.i' 
      .ta=.ta+.ep-.sp
    endif
  endfor
endproc


procedure gettime .start .dur .tier
#get new time provided a duration articulation time
select 'tgID'
.si= Get interval at time... '.tier' '.start'
.l$=Get label of interval... '.tier' '.si'
.ni = Get number of intervals... '.tier'
if .l$="#"
  .si=.si+1		; 1st int is silence
  if .si<=.ni
    .curdur=0
	.time=Get end point... '.tier' '.si'
    #printline gettime1
  else
    .time=Get end time
    #printline gettime2
  endif
else			; 1st int is not silence
  .ep=Get end point... '.tier' '.si'
  if .ep-.start> .dur	;  dur s'arrete avant la fin du 1er intervalle
    .time=.start+.dur
    .si=.ni+1
    #printline gettime3
  else
    .curdur=.ep-.start
    .si=.si+1
    .time=.ep
    #printline gettime4
   endif
endif

while .si<=.ni
  .l$=Get label of interval... '.tier' '.si'
  if .l$!="#"
    .ep=Get end point... '.tier' '.si'
    .sp=Get starting point... '.tier' '.si'
    if .ep-.sp+.curdur> .dur
      .time=.sp+.dur-.curdur
      .si=.ni+1
    else
      .curdur=.ep-.sp+.curdur
     endif
  endif
  .si=.si+1
endwhile

endproc

