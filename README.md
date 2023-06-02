# alloy-blast-smelter-microcontroller

Made for use in GTNH.

This program automates taking Programmed Circuits out of input busses, to allow for one machine to share different-circuit-requiring recipes in one bus. This works in the general case, but I made it for my Alloy Blast Smelter, hence the name.

# Step 1:
Make a Microcontroller, using any Tier of microcontroller case.

![image](https://github.com/NeroOneTrueKing/alloy-blast-smelter-microcontroller/assets/28197216/c412c645-a130-408a-b7ae-26020f1c2cb2)

RED: Required.
* Tier 1 CPU
* Tier 1 OR Tier 1.5 RAM
* Transposer

ORANGE: Optional.
* RITEG Upgrade (requires Tier 2 microcontroller case)

PURPLE: Will be added after assembly.
* EEPROM

# Step 2:
Download the code onto a regular OpenComputers computer, and flash it to an EEPROM.

To download and save to a new file 'ABS.lua':
```lua
wget 'https://raw.githubusercontent.com/NeroOneTrueKing/alloy-blast-smelter-microcontroller/master/abs-controller.lua' ABS.lua
```

To flash to the EEPROM currently installed in the computer:
```lua
flash ABS.lua ABS_Auto
```

# Step 3:
Set up your physical blocks.

The microcontroller needs to be adjacent to an ME Interface or Dual Interface, and it needs to have access to the input side of the input bus.
The input side of the input bus is probably inaccessible because you have an ME Interface inserting items that way, so use a Thaumcraft Transvector Interface. The Microcontroller has to be on the same face of the transvector interface as the ME interface is on the input bus.
It's likely possible to accomplish this with two Linked Input busses as well, if you don't do Thaumcraft.

After placing the microcontroller, shift-right-click it with your flashed EEPROM (if you didn't do step 2 before step 1 and installed the flashed EEPROM directly).
If you didn't install the RITEG, you will also need to connect a GT cable to the microcontroller to supply power.

Sample setup, where the Dual Interface adjacent to the microcontroller is also the interace pushing into the input bus:

![image](https://github.com/NeroOneTrueKing/alloy-blast-smelter-microcontroller/assets/28197216/da894342-7c4f-4fc2-b9c3-7e0851fdeef3)

# Step 4:
Include programmed circuits in your patterns:

![image](https://github.com/NeroOneTrueKing/alloy-blast-smelter-microcontroller/assets/28197216/4663a5e7-a78d-45ea-a91c-a6377abb0e82)

# Fluids:
Optionally, also watch that an input hatch is empty.

If the microcontroller is adjacent to (or is adjacent to a transvector interface which is connected to) an input hatch, then it will wait for that input hatch to be empty before transferring out the programmed circuit and token.

# Customization:
It doesn't have to be a programmed circuit! In fact, the code currently defaults to moving _molds_ for a fluid solidifier.

In the code, where it says `targetName`, just change that string to match \[part of\] the name of the non-consumable you want the program to extract.
You can also disable if it's looking for a token, and change the token name.

To make changes to a microcontroller already in use by flashing your new program to a new EEPROM, then shift-right-clicking the microcontroller with your new EEPROM. This will switch its old EEPROM with your new one.

# Debugging

If it isn't working, set up another computer nearby, and place an Adapter adjacent to the microcontroller. This will make it visible as a component (https://ocdoc.cil.li/component:microcontroller),
The functions `start()`, `isRunning()`, and `lastError()` will help you debug.

