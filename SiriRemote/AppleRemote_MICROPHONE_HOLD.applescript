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

-- change speaker or voice recording

-- click!
set playsound to POSIX path of ("/System/Library/Sounds/Tink.aiff")
do shell script ("afplay " & playsound & " > /dev/null 2>&1 &")

try
	tell application "System Events"

		if exists process "iTunes" then
			-- PLAY / PAUSE
			tell application "iTunes"
				set state to get player state
				if state is playing then
					-- switch between a speaker and headphone 
					my changeSpeaker()

					--tell application "Keyboard Maestro Engine"
					--	do script "8E2C660F-7ECF-4E04-A865-2207A23A1CFB"
					--end tell
				else
					-- 마이크 음성 녹음
					--tell application "Keyboard Maestro Engine"
					--	do script "2E79FFFC-5903-4C5F-BED3-CF245BE0A12B"
					--end tell
				end if
				return state
			end tell
		end if
	end tell
end try

-- change speaker
on changeSpeaker()
	
	set SPEAKERS to {"Built-in Output", "Built-in Line Output", "Display Audio"}
	set MY_SPEAKERS to {}
	
	-- get speakers list
	repeat with i in SPEAKERS
		set IS_SPEAKER to (do shell script "/usr/local/bin/SwitchAudioSource -a | grep \"" & i & "\" > /dev/null; echo $?") as text
		--display notification IS_SPEAKER
		if IS_SPEAKER is "0" then
			set end of MY_SPEAKERS to i as text
		end if
	end repeat
	
	-- change speaker
	set current to (do shell script "/usr/local/bin/SwitchAudioSource -c") as text
	repeat with n from 1 to count of MY_SPEAKERS
		if current is (item n of MY_SPEAKERS) as text then
			if n is (count of MY_SPEAKERS) then
				set new to item 1 of MY_SPEAKERS
			else
				set new to item (n + 1) of MY_SPEAKERS
			end if
			--display notification new
			do shell script "/usr/local/bin/SwitchAudioSource -s '" & new & "'"
		end if
	end repeat
	
end changeSpeaker