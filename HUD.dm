HUD
	parent_type = /obj
	maptext_height = 32
	maptext_width = 35
	mouse_opacity = 0
	var
		betweenLoc = "1,1"
/*	bg
		icon = 'bg.png'
		screen_loc = "1,1" */
	//Screens
	pausedMap
		icon = 'pause.png'
		screen_loc = "1,1"
		layer = FLY_LAYER
		invisibility = 1

	betweenMap
		icon = 'between.png'
		screen_loc = "1,1"
		layer = FLY_LAYER
		invisibility = 1

	lostMap
		icon = 'lost.png'
		screen_loc = "1,1"
		layer = FLY_LAYER
		invisibility = 1
	winner
		icon = 'winner.png'
		screen_loc = "1,1"
		layer = FLY_LAYER
		invisibility = 1

	//Counters
	smallCounter
		layer = FLY_LAYER+1
		screen_loc = "1:604,1:768"
		betweenLoc = "1:142,1:219"
		maptext_width = 64
	neededCounter
		layer = FLY_LAYER+1
		screen_loc = "1:672,1:768"
		betweenLoc = "1:419,1:177"

	totalCounter
		layer = FLY_LAYER+1
		screen_loc = "1:732,1:768"
		betweenLoc = "1:296,1:89"
		maptext_width = 64

	levelCounter
		layer = FLY_LAYER+1
		screen_loc = "1:36,1:768"
		betweenLoc = "1:333,1:266"

	reactCounter
		layer = FLY_LAYER+1
		screen_loc = "1:297, 1:236"
		invisibility = 1

	//Buttons
	colorSetting
		layer = FLY_LAYER+1
		mouse_opacity = 2
		invisibility = 1
		icon = 'color.dmi'
		screen_loc = "1:368, 1:415"
		Click()
			usr.colour()

	//Labels
	dividerLabel
		layer = FLY_LAYER+1
		screen_loc = "1:670,1:768"
		betweenLoc = 0
		maptext = "<P align=right><font size=4 color=green>/"
		maptext_width = 10

	levelLabel
		layer = FLY_LAYER+1
		screen_loc = "1:1,1:768"
		maptext = "Level"
		betweenLoc = 0

	totalLabel
		layer = FLY_LAYER+1
		screen_loc = "1:752,1:752"
		maptext = "Total"
		betweenLoc = 0

mob
	Login()
		for(var/mob/x)
			if(x != src)
				del src
		..()
		world.log << "[client.connection]"


		smallCounter = HUDItems[1]
		neededCounter = HUDItems[2]
		levelCounter =  HUDItems[3]
		totalCounter = HUDItems[4]
		pausedMap = HUDItems[5]
		betweenMap = HUDItems[6]
		lostMap = HUDItems[7]
		dividerLabel = HUDItems[8]
		levelLabel = HUDItems[9]
		totalLabel = HUDItems[10]
		colorSetting = HUDItems[11]
		winner = HUDItems[12]
		reactCounter = HUDItems[13]

		colour(1)

	//	client.screen += new /HUD/bg
		for(var/HUD/x in HUDItems)
			client.screen += x
		updateHUD()

		spawn(world.tick_lag)
			startGame()
	verb
		pause()
			if(!between && !lost)
				pauseStuff()

		colour()
			tileColor = (args.len && args[1]) ? rgb(rand(255),rand(255),rand(255)) : input("") as color
		//	tileColor =  rgb(255,128,255)
			colorSetting.icon = 'color.dmi'
			colorSetting.color = tileColor
			winset(usr, "map", "background-color=[tileColor]")
	//		winset(usr, "default", "transparent-color=[tileColor]")

		size(t as text)
			var/size = text2num(copytext(winget(usr, "default", "size"),1,4))

			if(t == "up")
				if(size == 800) return
				size += 50
			else
				if(size == 400) return
				size -= 50
			var/icon_size = round(200/800*size,1)
			winset(usr, null, "default.size=[size]x[size];map.icon-size=[icon_size]")
	//	setLevel(n as num)
	//		level = n
proc
	lostLevel(toggle)
		lostMap.invisibility = !toggle
		colorSetting.invisibility = !toggle

	pauseStuff()
		paused = !paused
		pausedMap.invisibility = !paused
		colorSetting.invisibility = !paused

	betweenLevels(toggle)
		between = toggle
		betweenMap.invisibility = !between
		colorSetting.invisibility = !toggle
		for(var/HUD/x in HUDItems - betweenMap - pausedMap - lostMap - colorSetting - winner - reactCounter)
			if(!x.betweenLoc && between) x.invisibility = 1
			else x.invisibility = 0
			x.screen_loc = between ? x.betweenLoc : initial(x.screen_loc)

	updateHUD()
		smallCounter.maptext = "<P align=right><font size=4 color=red>[total-smalls]"
		neededCounter.maptext = "<P align=right><font size=4 color=blue>[needed]"
		totalCounter.maptext = "<P align=right><font size=4 color=yellow>[total]"
		levelCounter.maptext = "<P align=right><font size=4 color=green>[level]"

	Win()
		for(var/HUD/x in HUDItems)
			x.invisibility = 1
		winner.invisibility = 0
		reactCounter.maptext = "<P align=right><font size=4 color=yellow>[totalReactions]"
		reactCounter.invisibility = 0
var
	HUD
		smallCounter
		neededCounter
		levelCounter
		totalCounter

		pausedMap
		betweenMap
		lostMap
		winner

		dividerLabel
		levelLabel
		totalLabel
		reactCounter

		colorSetting

	HUDItems = newlist(
		/HUD/smallCounter,
		/HUD/neededCounter,
		/HUD/levelCounter,
		/HUD/totalCounter,

		/HUD/pausedMap,
		/HUD/betweenMap,
		/HUD/lostMap,

		/HUD/dividerLabel,
		/HUD/levelLabel,
		/HUD/totalLabel,

		/HUD/colorSetting,

		/HUD/winner,
		/HUD/reactCounter
		)

//		bigCounter
/*
		bigCounter = new
		bigCounter.screen_loc = "45,49"
		bigCounter.maptext_height = 32
		bigCounter.maptext_width = 32
		client.screen += bigCounter */

