# some stupid tricks you can do?

## Physics Gun
cl_weaponcolor inf inf inf : makes your physics gun super fucking bright.  
![cl_weaponcolor inf inf inf](/images/infinfinf_physgun.png)  
cl_weaponcolor -inf -inf -inf : quite the opposite, and the beam is invisible.  
![cl_weaponcolor -inf -inf -inf](/images/-inf-inf-inf_physgun.png)  

## Prop Spawn binds
the command ``gm_spawn <model here>`` spawns prop.  
for example: ``gm_spawn models/props_phx/mk-82.mdl`` spawns the mk-82 bomb.  
you can bind it to a key: ``bind g "gm_spawn models/props_phx/mk-82.mdl"``  
prop spawn binds from [pvprepo](https://github.com/greyliterature/pvprepo/) [here](https://github.com/greyliterature/pvprepo/blob/8364512253115f1aa77a34401c0b6b3d174307ec/GarrysMod/cfg/valve.rc#L283-L335)

## Medkit/Battery binds
there is a command to spawn SEnts(or engine ents): ``gm_spawnsent <classname here>``  
Common Health/Armor entities:
| Class Name | Amount | How many to get to 100 | Banned in most servers |
| --------- | ------ | ---------------------- | ----------------------- |
| item_healthkit | 25 Health | 4 | No |
| item_healthvial | 10 Health | 10 | No |
| item_battery | 15 Armor | 7 | No |
| sent_ball | 5 Health, allow overheal | 20 | Yes |

how to bind:  
``bind t "gm_spawnsent item_healthkit"``

## Fading Doors
some sandbox servers might have the ``Fading Doors`` tool, if you fade a prop it no longer collides with anything, even physics gun can't grab it  
![CAN'T GRAB IT WITH PHYSICS GUN](/images/fading_door_cantgrab.png)  
however, you can use physics gun to unfreeze it ***(DOUBLE PRESS R)***.  

example usage:  
put hoverballs on thrusters on an airboat, and make it fade away, unfreeze them and fly out of bounds.

## Funny Cube
some sandbox servers might have the ``Submaterial`` tool, you can set the material path to ``vgui/inworldui``, and it still can be seen behind walls.  
![Funny Cube](/images/funny_cube.png)  
if you combo it with the ``Advanced Resizer`` tool, you can create a cube that is super big and blocks everyone's view.

## Solid Color Cubes
some sandbox servers might have the ``Submaterial`` tool, you can set the material path to ``debug/debugportals``, instead of blocking the whole view, it blocks the world.  
![Solid Color cube](/images/solid_color_cube.png)  
again, if you combo it with the ``Advanced Resizer`` tool, you can create a cube that is super big and blocks the whole world.  

## Combine APC
in a Garry's Mod update, combine apc has been added to the spawnmenu, it is immune to damages, however, if a Combine Ball hit it, the driver will dissolve, this can be countered by disabling collisions via the context menu or the ``No Collide`` tool.  
Though, there is still a way to counter the combine apc, you can use barnacles to get people out of apcs.