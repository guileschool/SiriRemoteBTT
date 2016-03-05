(*
The MIT License (MIT)

Copyright (c) 2015 guileschool

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

http://github.com/guileschool/SiriRemoteBTT
*)

-- ScreenShot( Main monitor )   

-- get Screens infomation
set resolutions to {}
repeat with p in paragraphs of ¬
	(do shell script "system_profiler SPDisplaysDataType | awk '/Resolution:/{ printf \"%s %s\\n\", $2, $4 }'")
	set resolutions to resolutions & {{word 1 of p as number, word 2 of p as number}}
end repeat
# `resolutions` now contains a list of size lists;
# e.g., with 2 displays, something like {{2560, 1440}, {1920, 1200}}

set screen to item 1 of resolutions
set width to item 1 of screen
set height to item 2 of screen

--display dialog "width:" & width & ", height:" & height

-- click!
set playsound to POSIX path of ("/System/Library/Sounds/Tink.aiff")
do shell script ("afplay " & playsound & " > /dev/null 2>&1 &")

do shell script "screencapture -T 0 -R0,0," & width & "," & height & " -c"

tell application "Notes" to activate
tell application "System Events"
	tell process "Notes"
		set IS_ITUNES_PLAYING to my isPlayingITUNES()
		
		-- screen paste
		keystroke "v" using command down
		keystroke return

		delay 0.5
		
		-- text paste
		if IS_ITUNES_PLAYING is true then
			set the clipboard to my infoTrack()
			keystroke "v" using command down
			keystroke return
		end if
	end tell
end tell

(* 숫자의 앞에 zero 을 입력해 주는 함수 *)
on pad_with_zero(the_number)
	if (the_number as integer) < 10 then
		return "0" & the_number
	else
		return the_number as text
	end if
end pad_with_zero

(* 숫자(정수값)을 입력 받아 이를 Time(시간) 포맷으로 변환하는 함수 *)
on timeToText(theTime)
	set myString to ""
	set myString to theTime
	set min to myString div 60 as string
	set min to my pad_with_zero(min)
	set sec to myString mod 60
	set sec to my pad_with_zero(sec)
	
	set answer to min & sec
	--display dialog answer
	return answer
end timeToText

(* 현재 재생중인 트랙의 재생위치정보와 트랙번호를 텍스트 정보로 리턴 *)
on infoTrack()
	-- "next" command moves to next track.
	try
		tell application "iTunes"
			set _trackname to the name of the current track
			set _trackno to the track number of the current track
			set _trackno to my pad_with_zero(_trackno)
			set _time to get player position
			set _time to _time as integer
			
			set _playtime to my timeToText(_time)
			--display dialog "E" & _trackno & "T" & _playtime
		end tell
	on error
		display alert "심각한 장애가 발생하였습니다! : 화면캡쳐"
	end try
	
	return "▲ " & _trackname & "_E" & _trackno & "T" & _playtime
end infoTrack

(* 현재 음악이나 동영상이 재생중인지 여부를 확인 *)
on isPlayingITUNES()
	tell application "System Events"
		if exists process "iTunes" then
			-- PLAY / PAUSE
			tell application "iTunes"
				set state to get player state
				if state is playing then
					return true
				else
					return false
				end if
			end tell
		end if
		return false
	end tell
end isPlayingITUNES
