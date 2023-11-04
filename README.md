# Pocket Tanks with Processing

### Project Description:
This project is an implementation of a two-player game resembling the classic Artillery Game, developed using Processing. The game involves tanks, destructible landscapes, projectile firing, and elements of physics.

### Assignment Overview:
The game was developed as part of a Computer Science course at the University of St Andrews, specifically for the CS4303 Video Games module. The practical involved the creation of a game using the Processing language and implementing physics concepts.

### Game Summary:
Pocket Tanks with Processing offers a two-player experience, with each player controlling a tank. Players take turns to aim and fire shots at each other, scoring points upon hitting the opposing tank. The game ends when one player reaches a predefined score limit.

### Features and Gameplay:
- **Game Controls:**
  - 'a' - Move left
  - 'd' - Move right
  - Mouse - Click, aim, and drag to control shot strength
  - 'r' - Reset the game
  - 'g' - Use gravity gun (special ability)
  - 'x' - Use LandSlider (special ability)
  - 'f' - Use FlashBomb (special ability)
- **Special Abilities:**
  - Gravity Gun: Alters gravity affecting the projectile.
  - LandSlider: Destroys a column of land mass in front of the player.
  - FlashBomb: Temporarily blinds the opposing player.
- **Game Elements:**
  - Destructible terrain blocks and tanks
  - Projectile motion influenced by gravity, wind, and air resistance
  - Randomly generated landscapes for varied gameplay
- **User Interface:**
  - Displays score of each player
  - Shows the currently selected elevation and strength for each player
  - Indicates whose turn it is
  - Exhibits wind strength and direction

### Design and Implementation:
The game implementation covers multiple areas such as landscape generation, forces in action, tank mechanics, bullet behavior, collision detection, and special abilities. The implementation aims for a balance between realistic physics and an enjoyable gameplay experience.

### Game Design Choices:
- Introduction of randomness in various game aspects to change win/lose probability
- Implementation of special abilities to introduce creativity and varied gameplay strategies

### Conclusion and Evaluation:
The developed game successfully simulates real-world physics, allowing players to move tanks, fire projectiles, and engage in a turn-based artillery battle. The game uses basic physics, such as gravity, wind, and projectile motion, but could potentially benefit from features like player displacement upon taking direct hits or floating land masses under low gravity.

### Known Bugs and Issues:
- Some glitches related to initial movements or abilities due to a bouncing bug.

### Future Improvements:
- Address and fix existing bugs/glitches.
- Implement features like player displacement and floating land masses to enhance gameplay and physics simulation.
