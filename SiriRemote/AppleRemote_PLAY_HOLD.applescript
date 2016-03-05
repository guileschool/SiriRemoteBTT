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

-- Mac goes to sleep for low power or ScreenFlow recorder 'STOP'

try
	set is_running_ScreenFlow to is_running("screenflowrecorder")
	tell application "System Events"
		if is_running_ScreenFlow is not true then
		-- Mac goes to sleep for low power
			do shell script "pmset sleepnow"
		else
		-- STOP a Screenflow recording
			key code 19 using {shift down, command down}

			-- get a current volume setting and save it
			set savedSettings to get volume settings
			-- result: {output volume:43, input volume:35, alert volume:78, output muted:false}
			set volume output volume 90
			-- click!
			set playsound to POSIX path of ("/System/Library/Sounds/Pop.aiff")
			do shell script ("afplay " & playsound & " > /dev/null 2>&1 &")

			delay 1

			-- restore a old volume
			set volume output volume (output volume of savedSettings)

--			tell application "Keyboard Maestro Engine"
--				do script "65D11636-6B4A-4FA5-B0E3-C46356B99196"
--			end tell
		end if
	end tell
end try

on is_running(appName)
	tell application "System Events" to (name of processes) contains appName
end is_running