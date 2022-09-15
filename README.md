# Adaptive-Energy-Minimized-Scheduling-of-Real-Time-Applications-in-Vehicular-Edge-Computing

1. Data

-  We have provided some test data in the data folder
    you can use them directly in main.m

-  Generate your own data. We give 10 types of apps and you can view their DGA diagrams
   You can also define new app types by adding DGA diagrams in the data/GenerateTypesDAGFunc.m 
   Some settable variables of APP and RSU can be viewed through ClassApps.m and ClassRSUs.m 
 
   We provide sample code data/main.m and data/main_10types.m for generating data,
   you can generate the data you need by modifying the parameters or directly modifying part of the code

2. Run

- load data and run main.m

- View scheduling results. 
  After the algorithm is executed, a schedule will be generated, which saves the detailed scheduling results of each RSU.
  you can use Gante(schedule) to view Gante Chart
