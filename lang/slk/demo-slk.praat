clearinfo
eadir$=preferencesDirectory$+"\plugin_easyalign\"

Read from file... prince-slk.mp3
Read Strings from raw text file... prince-slk.txt
pause Sound and transcription loaded. Launch step#1 Utterance segmentation ?
select Sound prince-slk
plus Strings prince-slk
execute "'eadir$'utt_seg2.praat" ortho yes
pause Utterance segmentation done. Launch step#2 Phonetisation ?
editor TextGrid prince-slk
 Close
endeditor
execute "'eadir$'phonetize_orthotier2.praat" ortho phono slk yes yes
pause Phonetisation. Launch step#3 Phoneme Segmentation ?
editor TextGrid prince-slk
 Close
endeditor
select Sound prince-slk
plus TextGrid prince-slk
execute "'eadir$'align_sound.praat" ortho phono yes slk "" no yes no 90 yes yes
   
