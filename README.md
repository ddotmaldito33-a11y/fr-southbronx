# FR South Bronx: The Trenches - Roblox Game Scripts

A complete Roblox game scripting framework for an urban street-themed game set in South Bronx.

## Features

### Core Systems
- **Sprint System**: Hold SHIFT to sprint with stamina management
- **Combat System**: Melee attacks with combo system
- **Damage System**: Health and damage mechanics
- **Character Controller**: Movement and animation handling

### Gameplay Mechanics

#### Combat
- **Punch**: Quick attack (25 damage + combo multiplier)
- **Kick**: Powerful attack with knockback (35 damage)
- **Special Move**: Ultimate attack with stun effect (50 damage, 5 second cooldown)
- **Block**: Defensive stance
- **Combo System**: Attacks build combo multiplier for increased damage

#### Movement
- **Walk Speed**: 16 studs/second
- **Sprint Speed**: 25 studs/second
- **Stamina**: Drains while sprinting, regenerates when walking
- **Max Stamina**: 100

## File Structure

```
FR-SouthBronx/
├── SouthBronxTrenches.lua    # Main game script
├── CharacterController.lua    # Character movement and animations
├── CombatSystem.lua          # Combat mechanics
└── README.md                 # This file
```

## Installation

1. Place `SouthBronxTrenches.lua` in **ServerScriptService**
2. Place `CharacterController.lua` in **ServerScriptService** or **ReplicatedStorage**
3. Place `CombatSystem.lua` in **ServerScriptService** or **ReplicatedStorage**

## Controls

| Key | Action |
|-----|--------|
| SHIFT | Sprint |
| E | Melee Attack |
| F | Block |
| Q | Special Move |

## Configuration

Edit the `CONFIG` table in `SouthBronxTrenches.lua` to adjust:

```lua
local CONFIG = {
	WALK_SPEED = 16,
	SPRINT_SPEED = 25,
	STAMINA_MAX = 100,
	STAMINA_DRAIN_RATE = 15,
	STAMINA_REGEN_RATE = 10,
	MELEE_DAMAGE = 25,
	MELEE_RANGE = 5,
	MELEE_COOLDOWN = 0.5,
}
```

## Usage Examples

### Creating a Custom Combat Move

```lua
function CombatSystem:customMove(targetHumanoid)
	targetHumanoid:TakeDamage(40)
	print("Custom move executed!")
end
```

### Modifying Player Stats

```lua
CONFIG.WALK_SPEED = 20  -- Increase walk speed
CONFIG.MELEE_DAMAGE = 50  -- Increase melee damage
```

## Future Enhancements

- [ ] Weapon system
- [ ] Map/Territory control
- [ ] Faction system
- [ ] Experience and leveling
- [ ] Custom skins and cosmetics
- [ ] NPCs and missions
- [ ] PvP leaderboards
- [ ] Sound effects and music

## Notes

- All scripts use Roblox's standard services (Players, UserInputService, RunService)
- Designed for use in Roblox Studio
- Requires proper game setup with spawn locations and terrain
- Combat is server-sided for anti-exploit measures

## License

Use freely in your Roblox games. Modify as needed for your project.

---

**Made for South Bronx: The Trenches - A FR Production**
