#define isneg(num)  ((num) < 0)
#define ceil(x) (-round(-(x)))

world
	fps = 60
	icon_size = 200
	view = "4x4"
	hub = "SuperSaiyanX.balls"
	hub_password = "cheese"
	version = 7
	maxx = 4
	maxy = 4
	maxz = 1
	New()
		..()
		generateUnitComponents()
mob
	density = 0

#if !DEBUGMODE
client
	control_freak = 1
#endif

var
	placed = 0
	paused = 0
	between = 0
	lost = 0

	tileColor

	level = 0

	bigs = 0

	smalls = 0 //amount of balls
	total = 0  //total amount of balls spawned on the level
	needed = 0 //amount needed to pass onto the next level.

	list/unit_x
	list/unit_y

	totalReactions = 0

