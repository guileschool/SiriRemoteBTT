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

-- iTunes's screen is on between dual monitors

try
	tell application "System Events"
		if exists process "iTunes" then
			tell application "iTunes"
				
				activate
				set frontmost to true
				
				tell application "Keyboard Maestro Engine"
					set aMonitor to get value of variable "MONITOR"
					
					if aMonitor is equal to "1" then
						make variable with properties {name:"MONITOR", value:2}
						tell application "iTunes" to set bounds of front window to {0, 20, 2560, 1440}
					else if aMonitor is equal to "2" then
						make variable with properties {name:"MONITOR", value:1}
						tell application "iTunes" to set bounds of front window to {2560, 20, 2560 * 2, 1440}
					else
						display dialog "Invalid value : " & aMonitor
					end if
				end tell
			end tell
		end if
	end tell
on error
end try