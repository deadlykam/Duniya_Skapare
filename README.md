# Duniya_Skapare

### Introduction
A godot tool that creates a grid world using different type of algorithms.

## Table of Contents:

## Prerequisites
#### Godot Game Engine
Godot version **v4.1.3.stable.mono.official [f06b6836a]** and above should work. Previous Godot 4 versions should work but those have not been tested.
***
## Stable Build
[Stable-v1.0.0](https://github.com/deadlykam/Duniya_Skapare/tree/Stable-v1.0.0) is the latest stable build of the project. The compressed file for this project can also be found there. If development is going to be done on this project then it is adviced to branch off of any _Stable_ branches because they will **NOT** be changed or updated except for README.md. Any other branches are subjected to change including the main branch.
***
## Installation
1. First download the latest [Duniya_Skapare-v1.0.0.zip](https://github.com/deadlykam/Duniya_Skapare/releases/tag/v1.0.0) from the latest Stable build.
2. Once downloaded extract/unzip the file.
3. Enter the folder and copy the folder named **kamran_wali**.
4. Now paste the folder in the **addons** folder of your Godot project. If your Godot project does not have the **addons** folder then just create it in the root folder, **res://**, and paste the copied folder there.
5. (Optional) To open the interface for Duniya_Skapare simply go to the menu _Project_ -> _Projct Settings_. Click the _Plugins_ tab and enable the **DS Wave Function Collapse**. This should open and dock the **DS Wave Function Collapse**.
***
## Features
### Wave Function Collapse:
Let me give a brief explanation of Wave Function Collapse. Wave Function Collapse or WFC is a constraint based algorithm that can be used to generate anything for example images, 2D stages, 3D stages etc. Basically that means the algorithm uses a set of rules to generate the desired result. In this tool we are going to use WFC to generate stages.
#### Wave Function Collapse Tool:
| ![WFC_UI_1.png](https://imgur.com/fkUBzdn.png) | ![WFC_UI_2.png](https://imgur.com/ybsQrBB.png) | ![WFC_UI_3.png](https://imgur.com/z9fg8P7.png) |
|:--:|:--:|:--:| 
| *Fig 1a: Wave Function Collapse Tool: WFC Settings* | *Fig 1b: Wave Function Collapse Tool: Tile Rules* | *Fig 1c: Wave Function Collapse Tool: Invalid Combos* |

After [installation](#installation) the Wave Function Collapse Tool can be opened by clicking the _AssetLib_ then clicking the _Plugins_ button. This will open up the plugin window. There just enable the **DS Wave Function Collapse** and this will open up Wave Function Collapse tool and dock it. The tool has 3 tabs which are _WFC Settings_, _Tile Rules_ and _Invalid Combos_. I will explain them all below.
##### 1. WFC Settings:
| ![WFC_UI_1.png](https://imgur.com/G8Z0SmK.png) | 
|:--:| 
| *Fig 2a: Wave Function Collapse Tool: WFC Settings* |

The purpose of the _WFC Settings_ tab is to set the number of tiles that is going to be used and to name each tile. The _default_ WFC file will be selected when you open up the tool for the first time. It is recommended to create a new WFC file and use that for your project. I will explain what each part does in the _WFC Settings_ tab with the help of _Fig 2a_.

- **a.** _File Name_ - This is the file name of the current data being used. When the tool starts for the first time then the default WFC file is select and in this case it is showing the name of the default file.
- **b.** _Save_ - The _Save_ button will save any changes made to the data file. Changes can be done in any of the tab and will save all of the changes in all the tabs.
- **c.** _Number of Tiles_ - This number indicates how many tiles are going to be used in the WFC. Minimum amount is 1.
- **d.** _Tile Name_ - This is where you can give the names for the tiles.
- **e.** _New_ - The _New_ button will pop up a new window that will allow you to create a new WFC file. In the _Path_ field give the full folder location where you want to save the new WFC file. You can get the full folder location by selecting the folder in the _FileSystem_ and then pressing _ctrl + shift + c_. In the _Name_ filed you must give the name of the WFC file. Once everything is set then press the _Save_ button and a new WFC File will be created and the newly created WFC file will be loaded.
- **f.** _Load_ - The _Load_ button will pop up a new window that will allow you to load any WFC files. In the _Path_ field give the full WFC file location. You can get the full file location by selecting the WFC file in the _FileSystem_ and then pressing _ctrl + shift + c_. Once everythign is set then press the _Load_ button. The selected WFC file will be loaded.
- **g.** _Reset_ - The _Reset_ button will reset the currently loaded WFC file to it's default state. This means there will be only 1 tile with a default name and all the rules and invalid combos will be removed. Be caution when pressing this button.
- **h.** _Ok_ - This will update the _Number of Tiles_ value to the newly given value.
##### 2. Tile Rules:
| ![WFC_UI_2.png](https://imgur.com/crgM5DG.png) | ![WFC_UI_2.png](https://imgur.com/RsTGtAv.png) | ![WFC_UI_2.png](https://imgur.com/OJMflA3.png) |
|:--:|:--:|:--:|
| *Fig 3a: Wave Function Collapse Tool: Tile Rules* | *Fig 3b: Top Down View of Tile Model in Blender* | *Fig 3c: Top Down View of Tile Model in Godot* |

The purpose of the _Tile Rules_ tab is to set the rules for each tile. This will tell the WFC how to generate a stage using the rules. I will explain what each part does in the _Tile Rules_ tab with the help of _Fig 3a, Fig 3b and Fig 3c_.

- **a.** _Tile_ - Here you can select the tile you want to work with. Clicking on the drop down menu will reveal all the tiles created in the [WFC Settings Tab](#1-wfc-settings). The post-fix number of the tile name is the index number of the tile. So if you named your 0th tile Ground then the tile name will be _(0) Ground_. The reason for adding this post-fix index number is to help you further if you are using numbers to create the rules.
- **b.** _Add_ - The _Add_ button will add one or multiple rules to the selected _Tile_. When another tile or multiple tiles are selected from the list and the _Add_ button is pressed then those selected tiles are added as rules for the given edge. Once a rule has been added it will be highlighted in green colour. If you see image _Fig 3a_ you will see that the _North_ edge has ground, corner1 and corner2 rules added which means for the _Tile_ Ground it's north edge can have the tiles ground, corner1 and corner2.
- **c.** _Remove_ - The _Remove_ button will remove one or multiple rules from the selected _Tile_. When selecting any added rules from the list, which are the green highlighted rules, and then clicking the _Remove_ button will remove those rules and they will be highlighted back to red.
- **d.** _Edge_ - These are the edges of a tile. Each tile has 6 edges for now. Up, North, East, Bottom, South and West. Their index representations are 0, 1, 2, 3, 4 and 5 respectively. The Up and Bottom edges are still work in progress and will NOT work in the current version but later down the line hopefully I will get it done. You will also notice that each edge has a pre-fix coordinate direction. Up is +y direction in Godot, North is -z direction in Godot, East is +x direction in Godot, Bottom is -y direction in Godot, South is +z direction in Godot and West is -x direction in Godot. The reason for adding the direction representation of each edges is because then you will know which edge is in which side in Godot once importing from Blender or other 3D modeling software. If you see _Fig 3c_ then you will see that the North is on the -z direction, East is on the +x direction, South is on the +z direction and West is on the -x. So using these edge representations we can now know how the rules should be applied for the _Tile_. Also _Fig 3b_ shows how the edges are represented in Blender3D which is NOT same as Godot.
- **e.** _Added Rule_ - The green highlighted tile in the list indicates that the rule has been added for an edge for the _Tile_.
- **f.** _Removed Rule_ - The red highlighted tile in the list indicates that the rule has been removed for an edge for the _Tile_. By default newly added tiles will NOT have any rules added.
##### 3. Invalid Combos:
| ![WFC_UI_1.png](https://imgur.com/G8Z0SmK.png) | 
|:--:| 
| *Fig 2a: Wave Function Collapse Tool: WFC Settings* |
##TODO: Finish the Invalid Rule##
