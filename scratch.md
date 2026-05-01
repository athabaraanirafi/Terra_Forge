# This is the place where i put nonsense that i thought about inside

# Mask-list:
	PRIMARY: [Ground, Environment],
	SECONDARY: [Hurt Box, Hit Box],
	TERTIARY: [Items, etc] 

# Important!:
	- Every Hurt Box that listen in the SECONDARY layer must implement these signals
		- signal sig_deal_damage(int)
		- signal sig_deal_push_back(Vector2)
		- signal sig_deal_stun(int)
	- Then every entity that owned these hurtbox must also listen to those signals too
