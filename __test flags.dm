#define DEBUGMODE 1


#if defined(DEBUGMODE)
var
	INFINITE = 1
	SOLID_BALLS = 1
	SOLID_WALLS = 1
	TRAILS = 1
	sparkleON = 1

mob
	verb
		sparkle() // S
			sparkleON = !sparkleON
		infinite() // D
			INFINITE = !INFINITE
		solidballs() // A
			SOLID_BALLS = !SOLID_BALLS
		solidwalls() // F
			SOLID_WALLS = !SOLID_WALLS
		trails() // G
			TRAILS = !TRAILS
#endif
