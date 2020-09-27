eadir$=preferencesDirectory$+"/plugin_easyalign/"

form Operation
  word op all
  word language en
  sentence sound_path sample.wav
  sentence transcript_path sample.txt
  sentence output_path output.tg
  word ortho_tier ortho
endform


if (left$:sound_path$,1)!="/"
  sound_path$=shellDirectory$ + "/" + sound_path$
endif


if (left$:transcript_path$,1)!="/"
  transcript_path$=shellDirectory$ + "/" + transcript_path$
endif

# Ask for parameters according to the type of operation,
# then call the respective procedures

if op$="macrosegmentation"
  sound = Read from file: sound_path$
  transcript = Read Strings from raw text file: transcript_path$
  @macroSegmentation: sound, transcript, output_path$
elsif op$="phonetization"
  transcript = Read from file: transcript_path$
  @phonetization: language$, transcript, output_path$
elsif op$="phonesegmentation"
  sound = Read from file: sound_path$
  transcript = Read from file: transcript_path$
  @phoneSegmentation: language$, sound, transcript, output_path$
else
  sound = Read from file: sound_path$
  transcript = Read Strings from raw text file: transcript_path$
  @macroSegmentation: sound, transcript, output_path$
  transcript = selected("TextGrid")
  @phonetization: language$, transcript, output_path$
  @phoneSegmentation: language$, sound, transcript, output_path$
endif

# Methods for each case

procedure macroSegmentation: .sound, .transcript, .output_path$ 
  selectObject: .sound
  plusObject: .transcript
  execute "'eadir$'utt_seg2.praat" ortho no
  .textGrid = selected("TextGrid")
  @saveTextGrid: .textGrid, .output_path$
endproc

procedure phonetization: .language$, .transcript, .output_path$ 
  selectObject: .transcript
  execute "'eadir$'phonetize_orthotier2.praat" ortho phono '.language$' yes  no
  @saveTextGrid: .transcript, .output_path$
endproc

procedure phoneSegmentation: .language$, .sound, .transcript, .output_path$ 
  selectObject: .sound
  plusObject: .transcript
  execute "'eadir$'align_sound.praat" ortho phono yes '.language$' }^}-':;(),.?� no yes no 90 yes no
  @saveTextGrid: .transcript, .output_path$
endproc

# Utility procedures

procedure saveTextGrid: .tg, .path$
  select .tg
  if (left$:sound_path$,1)!="/"
    Save as text file: shellDirectory$+"/"+.path$
  else
    Save as text file: .path$
  endif
  writeInfoLine:  "TextGrid saved in ", .path$
endproc