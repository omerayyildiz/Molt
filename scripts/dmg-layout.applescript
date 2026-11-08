-- Saves the DMG window's look into the mounted Molt disk. Called by release-dmg.sh.
tell application "Finder"
	tell disk "Molt"
		open
		delay 1
		set hadPathbar to pathbar visible of container window
		set hadStatusbar to statusbar visible of container window
		set current view of container window to icon view
		set toolbar visible of container window to false
		set statusbar visible of container window to false
		set pathbar visible of container window to false
		set sidebar width of container window to 0
		set viewOptions to icon view options of container window
		set arrangement of viewOptions to not arranged
		set icon size of viewOptions to 112
		set text size of viewOptions to 13
		set background picture of viewOptions to file ".background:background.tiff"
		set position of item "Molt.app" of container window to {170, 120}
		set position of item "Applications" of container window to {490, 120}
		-- Out of the window for anyone who has Finder show hidden files.
		set position of item ".background" of container window to {1000, 1000}
		close
		-- Finder only keeps the size when it is set with the bars already hidden.
		open
		delay 1
		set bounds of container window to {200, 120, 860, 492}
		update without registering applications
		delay 2
		close
	end tell
	-- Hiding the bars above changes them for every Finder window, so the choice made before comes back.
	set other to make new Finder window
	set pathbar visible of other to hadPathbar
	set statusbar visible of other to hadStatusbar
	close other
end tell
