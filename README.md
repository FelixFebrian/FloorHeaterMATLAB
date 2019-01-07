# General
This MATLAB program was developed as a project for the module "Numerische Mathematik I für Ingenieure" at TU Berlin. As software, MATLAB (version 9.4.0.813654 (R2018a)) was used.
This program was developed by:
* Dario Staubach (d.staubach@campus.tu-berlin.de)
* Christian Ulmer (c.ulmer@campus.tu-berlin.de)
* Felix Febrian (f.febrian@campus.tu-berlin.de)

This work may be distributed and/or modified under the conditions of the  GNU General Public License v3.0

## Getting Started
The main directory consists of several folders and two MATLAB files. For a quick start, please open "mainGUI.m". From there, you can operate the program and generate plots. All functions are commented to provide the reader with information to quickly grasp the code.

## The graphical user interface (GUI) - `mainGUI.m`
The GUI acts as interface between the user and the program. To use the GUI, please select and/or confirm the options & parameters on the left side first. You can choose several different options, such as:

* floor and heating layout
* room size and resolution (up to 512 per side)
* initial & boundary conditions
* material properties
* heating power
* options for the instationary solution

Then, to start the calculation, press the button "Start Numerical Analysis". The program solves the system of linear equations derived using the finite-volume-method (FVM) for the stationary- & instationary case. The result is plotted in the GUI under the respectively labeled areas. 

*Important* After pressing the button "Start Numerical Analysis", please wait and do NOT click anywhere until the program has finished. This may take a while.

For this reason, important meta information and the progress is displayed in MATLABs command window. To close the GUI, simply close the figure or MATLAB.
The GUI itself does not perform any calculations. Rather, it collects the input and passes it on to the function `main.m`. 

## The main file for calculations - `main.m`
The file `main.m` performs all calculation to solve the stationary & instationary problem. The function uses default values if called without any input arguments, however can use the GUI (mainGUI.m) to give input in an easy and visual manner. 
To change the default values, please see the code section "Default values if no user input:" in the beginning of the file. All lines of code are commented.
By default, the iteration for the instationary solution stops if more than 1000 iterations have been calculated OR if more than 30% of the finite-volume-elements of material 2 (except the border) have reached a temperature greater or equal to 20 °C. We recommend to use the implict Euler or Crank-Nicolsen method. If one would like to change the break criteria, please change the respective code in the file `./Project/functions/fun_calculateInstationarySolution.m`. Please be aware that this is the break criteria as discussed in the final presentation and *not* as described in the written report. (There, the break criteria is set to 24h to have comparibility.)

### How to change or add materials 
The procedure to change or add materials is simple: 1) From the main directory, navigate to ./data/ and open the excel spreadsheet and add the material properties. Do not change the row names, as these are needed to read the spreadsheet by the program. 2) In the file ´mainGUI.m´ under the section " Data for Material Properties Import", uncomment the lines of code to read the data. 3) Once the program has run one time, comment the lines of code form step 2) out again. This is done for the sake of efficiency and speedy calculation, as the action to read the data from the spreadsheet is very time consuming.

### How to change or add floor & heating layouts
To change or add floor & heating layouts, one must place the RGB-encoded picture as bitmap in the folder `./image_read`. Pictures may have the size of n x n pixel, with n = (4, 8, 16, 32, 64, 128, 256, 512). The is a color-coding used to indicate materials & the shape of the floor heating. Green (RGB = 0/255/0) stands for Material 1. Blue RGB = (0/0/255) stand for material 2. Red (RGB = 255/0/0) stands for the heating. The files must follow a naming convention:
* pictures for the floor layout MUST start with the letter "f"
* pictures for the heating layout MUST start with the letter "s"

### A comment on the boundary conditions
We decided that the entire northern border can be represented by a Dirichlet boundary condition (BC). To avoid duplicates, the northern corner elements from the sides on the east & west are excluded. Thus, the east & west (minus the northern corner elements) are represented by a different BC. The remaining elements on the south (without any corner elements) are represented by a Cauchy-BC.

#### Folder Structure
All functions that are called from the `main.m` file are placed in ./Project/functions . If the name of a function does not start with `fun_`, they have been downloaded from the Internet.
