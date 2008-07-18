-- find out what numeric key code is generated by any key on the keyboard
-- usage:
--          ex key

integer code

puts(1, "Testing keyboard codes on ")

if platform() = 1 then
	puts (1, "DOS32 interpreter.\n")
elsif platform() = 2 then
	puts (1, "WIN32 interpreter.\n")
elsif platform() = 3 then
	puts (1, "LINUX or BSD interpreter.\n")
elsif platform() = 4 then
	puts (1, "OS X interpreter.\n")
else 
	puts (1, "unknow interpreter.\n")
end if
	

puts(1, "Press any key. I'll show you the key code. Press q to quit\n\n")
while 1 do
    code = get_key()
    if code != -1 then
	printf(1, "The key code is: %d\n", code)
	if code = 'q' then
	    exit
	end if
    end if
end while
