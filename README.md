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
| ![Protagonist.png](https://imgur.com/fkUBzdn.png) | ![ProtagonistIdea.png](https://imgur.com/ybsQrBB.png) | ![Shoe.png](https://imgur.com/4BQ8koF.png) |
|:--:|:--:|:--:| 
| *Fig 1a: Wave Function Collapse Tool: WFC Settings* | *Fig 1b: Wave Function Collapse Tool: Tile Rules* | *Fig 1c: Wave Function Collapse Tool: Invalid Combos* |

After [installation](#installation) the Wave Function Collapse Tool can be opened by clicking the _AssetLib_ then clicking the _Plugins_ button. This will open up the plugin window. There just enable the **DS Wave Function Collapse** and this will open up Wave Function Collapse tool and dock it. The tool has 3 tabs which are _WFC Settings_, _Tile Rules_ and _Invalid Combos_. I will explain them all below.
##### 1. WFC Settings:
