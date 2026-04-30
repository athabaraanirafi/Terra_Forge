# This is the place where i put nonsense that i thought about inside

# Mask-list:
	PRIMARY: [Ground, Environment],
	SECONDARY: [Hurt Box, Hit Box],
	TERTIARY: [Items, etc] 

# Important!:
	- Every Hurt Box that listen in the SECONDARY layer must implement these functions
		- func deal_damage(int)
		- func deal_push_back(Vector2)
		- func deal_stun(int)
