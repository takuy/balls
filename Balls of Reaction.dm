

turf
	mouse_opacity = 2
	Click(location,control,params)
		..()
		params = params2list(params)
#if DEBUGMODE
		if(params["right"])
			new /bigBall {inert = 1} (src, text2num(params["icon-x"]), text2num(params["icon-y"]))
			return
#endif
		if(paused)
			usr.pause()
			return

		if(!winner.invisibility)
			winset(usr, null, "command=.reconnect")
			return

		if(lost)
			lost = 0
			lostLevel(FALSE)
			setUp()
			return

		if(between)
			betweenLevels(FALSE)
			setUp()
			return

		if(!placed)
#if !DEBUGMODE
			placed = 1
#endif
			new /bigBall (src, text2num(params["icon-x"]), text2num(params["icon-y"]))

#if DEBUGMODE
turf
	MouseMove(location, control, params)
		params = params2list(params)
		if(params["shift"])
			new /wall (src, text2num(params["icon-x"]), text2num(params["icon-y"]))
			return

wall
	parent_type = /reactor
	inert = 1
	density = 0
	icon = 'tile.dmi'
	bound_height = 8
	bound_width = 8

	New(nloc, sx, sy)
		step_x -= 0.5*(bound_width) - sx
		step_y -= 0.5*(bound_height) - sy
	Cross(atom/a)
		. = SOLID_WALLS? 0 : ..()
#endif


smallBall
	parent_type = /ball
	icon = 'ball.dmi'
	step_size = 4
	density = 0

	var
		velocity_x
		velocity_y
		abs_x
		abs_y
#if DEBUGMODE
	Move(nloc, ndir, sx, sy)
		if(TRAILS)
			spawn(0)
				var/obj/i = new /ball(nloc)
				i.icon = src
				i.alpha = 255
				i.pixel_x = sx
				i.pixel_y = sy
				i.color = color
				animate(i, alpha = 0, time = 5)
				spawn(10) i.loc = null
		. = ..()
#endif

	New()
		step_x = rand(-200,200)
		step_y = rand(-200,200)
		smalls++
		src.color = rgb(rand(255),rand(255),rand(255))
		updateHUD()
		getRandomVelocity()
		updateLoop()
#if DEBUGMODE
	Cross(atom/a)
		. = (a.type == type)? !SOLID_BALLS : ..()
#endif


	proc
		getRandomVelocity()
			var/speed = rand(3,7)
			var/index = rand(1, unit_x.len)
			velocity_x = speed * unit_x[index]
			velocity_y = speed * unit_y[index]

		ballStuff()
			if( (velocity_y > 0 && !step(src, NORTH, velocity_y)) || \
				(velocity_y < 0 && !step(src, SOUTH, -velocity_y)) )
				velocity_y = -velocity_y
			if( (velocity_x > 0 && !step(src, EAST, velocity_x)) || \
				(velocity_x < 0 && !step(src, WEST, -velocity_x)) )
				velocity_x = -velocity_x
			spawn(world.tick_lag)
				for(var/reactor/c in obounds(src))
					if(!c.inert && c.type != type && inCircle(c, src))
						makeBig(src)
						return
ball
	bound_height = 16
	bound_width = 16
	mouse_opacity = 0
	parent_type = /obj

reactor
	var/inert = 0
	parent_type = /ball

bigBall
	parent_type = /reactor
	layer = 4
	bound_height = 64
	bound_width = 64
	icon = 'big_ball.dmi'

	New(nloc, sx, sy, _color)
		step_x -= 0.5*(bound_width) - sx
		step_y -= 0.5*(bound_height) - sy
		color = _color? _color : rgb(rand(255),rand(255),rand(255))
		if(bigs)
			smalls--
			totalReactions++
		bigs++
		updateHUD()
		name = "\ref[src] BIG"

		spawn(world.tick_lag)
			for(var/x = 1 to 30)
				while(paused || between || lost)
					sleep(1)
				sleep(1)
			deleteBig(src)

Sparkle
	layer = 5
	icon = 'sparkles.dmi'

	parent_type = /reactor
	var
		speed = 4

	New(loc, _color)
		if(sparkleON)
			. = ..()
			color = _color
		else del src

proc
	updateLoop()
		if(!paused && !between && !lost)
			for(var/smallBall/b)
				if(b.loc) b.ballStuff()
	GameLoop()
		spawn for()
			sleep(world.tick_lag*1.6)
			updateLoop()

	inCircle(ball/B,ball/S)
		var
			big_x = world.icon_size * B.x + B.step_x + B.bound_width*0.5
			big_y = world.icon_size * B.y + B.step_y + B.bound_height*0.5
			small_x = world.icon_size * S.x + S.step_x + S.bound_width*0.5
			small_y = world.icon_size * S.y + S.step_y + S.bound_height*0.5
			dx = small_x - big_x
			dy = small_y - big_y
			radius = (B.bound_width + S.bound_width) * 0.5
		return ( (dx*dx + dy*dy) <= (radius*radius) )

	deleteBig(obj/b)
		bigs--
		updateHUD()
		b.loc = null
#if !DEBUGMODE
		if(!bigs)
			if(total-smalls >= needed)
				betweenLevels(TRUE)
				nextLevel()
			else
				restartLevel()
				lostLevel(TRUE)
#endif

	makeBig(smallBall/c)
		var
			sx = c.step_x
			sy = c.step_y
			loc = c.loc
			color = c.color
		sparkles(loc, sx, sy, color)
		c.loc = null
		new /bigBall (loc, sx, sy, color)

	sparkles(loc, sx, sy, color)
		if(sparkleON)
			for(var/dir = 0 to 330 step 30)
				spawn(world.tick_lag)
					var/Sparkle/x = new /Sparkle (loc, color)
					x.step_x = sx - 8
					x.step_y = sy - 8
					var/vx = x.speed * cos(dir)
					var/vy = x.speed * sin(dir)
					for(var/i = 1 to 20)
						x.step_x += vx
						x.step_y += vy
						sleep(world.tick_lag)
					x.loc = null
#if DEBUGMODE
	spawnLoop()
		while(1)
			while(paused || !INFINITE)
				sleep(1)
			total++
			new /smallBall (locate(rand(2,world.maxx-1), rand(2,world.maxy-1), 1))
			sleep(3)
#else
	spawnLoop()
		for(var/x = 1 to total)
			while(paused)
				sleep(1)
			new /smallBall (locate(rand(2,world.maxx-1), rand(2,world.maxy-1), 1))
//			sleep(1)
#endif
	generateUnitComponents()
		unit_x = list()
		unit_y = list()

		for(var/angle = 0 to 355 step 5)
			unit_x += cos(angle)
			unit_y += sin(angle)

	startGame()
		spawn
			GameLoop()
		setUp()

	clearMap()
		total = 0
		needed = 0
		smalls = 0
		bigs = 0
		placed = 0

		for(var/ball/b)
		//	del b
			b.loc = null //http://www.byond.com/forum/?post=1613098


	nextLevel()
		between = 1
		clearMap()

	restartLevel()
		lost = 1
		level = 0
		clearMap()

	setUp()

#if !DEBUGMODE
	//	world.log << level
		if(level == 25)
			Win()
			return
		level++
		total = level * 4
		switch(level)
			if(1 to 4) needed = level
			else needed = total - level - 5
#endif
		spawnLoop()