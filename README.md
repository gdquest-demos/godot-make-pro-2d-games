<h1 align="center">
  Make Pro 2d Games with Godot</br>
  <small>Open Source A-RPG Demo</small>
</h1>

<p align='center'>
  <img src="https://i.imgur.com/zW56qs0.png" alt="Banner for the project, showing the player facing the game's boss, the blue wild boar" />
</p>

<hr>

This is the full source code with all the system produced for the [Make Professional 2d Games with Godot](https://gumroad.com/l/godot-tutorial-make-professional-2d-games) course.

![The game's boss, the Wild Boar](https://i.imgur.com/Bt57gQH.png)

This game demo tries to show good Godot programming practices to support a growing game project. It has multiple interlocking systems, the core gameplay loop in place, a boss encounter, an inventory and shop systems, user interface with nested menus...

![Grasslands with the two monsters available in the game, the mosquito and the porcupine](https://i.imgur.com/OPg5QEn.png)

## LICENSE ##

The entire source code is available under the MIT licence and everyone is welcome to [contribute](https://github.com/GDquest/make-pro-2d-games-with-godot/issues/)! Better art, gameplay improvements, code re-factoring, and more…

All the techniques I used to build this project are in our [intermediate-level Godot course on Gumroad](https://gumroad.com/gdquest). If you're interested in getting it, be aware it's not 100% step-by-step.

If you have requests for tutorials from elements of that game demo, please feel free to [ask on Twitter](https://twitter.com/NathanGDquest)! I will not redo what's in the course but I'll gladly make extra videos that would benefit everyone! 😄

This is our first open game on GDQuest. We are looking to build more Free games and game creation tools in the future. Be sure to [subscribe to our YouTube channel](http://youtube.com/c/gdquest) to know when that happens ☺

## Dependencies ##

The project runs in **Godot 3.1**.

## Features ##

Here's a list of the gameplay features and a few of the systems you will find in the demo

### Gameplay ###

- A player that can walk, jump, and do a three hit combo with a sword
- Two monsters with steering based movement
- Boss with 3 phases, drops random stacks of coins upon dying
- Items, and inventory, and a shop that will cover your basics for an RPG game

### Core systems ###

- LevelLoader, to load maps cleanly, keep the player's data around
- Save and load system
- Game node to handle pause and initialize the game at the start
- Shader to animate the transition between levels

### User interface ###

- An inventory menu and a shop menu where you can buy and sell items between two characters
- A pause menu with sound options
- A system to create life bars that hook onto monsters and follow them in the game world, but that are still managed by the UI system
- The animated player life bar (tutorial)
- Animated boss light bar that appears when the boss spans

### Visual effects ###

- Layered particle systems like explosions, bursting fire, rock sparkles, dust
- Beautiful noise-based fog thanks to [Gonkee](https://github.com/Gonkee/Gonkee-Fog-Shader)

### A few misc extras

- Modular hit box and damage source system to create ranged and melee weapons
- Stats node to manage the player and the monsters' health
- Gaps the player can fall into

### Contributing

You can find our contributor's guides here:

- [Contributor's guide](https://www.gdquest.com/open-source/guidelines/contributing-to-gdquest-projects/)
- [GDScript best practices](https://www.gdquest.com/open-source/guidelines/godot-gdscript/)
- [Kind communication guidelines](https://www.gdquest.com/open-source/guidelines/kind-communication-guidelines/)
