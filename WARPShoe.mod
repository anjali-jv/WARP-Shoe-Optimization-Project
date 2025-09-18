
#sets
set S; #set of shoes
set M; #set of machines
set WH; #set of warehouses
set R; #set of raw materials


#parameters
param Shoe_Cost{S}; #cost per shoe for set S
param Labour_Cost := 25; #fixed labour cost
param RM_Amount{R}; #amount of each raw material in set RM that is available
param RM_Cost{R}; #cost per raw material in set RM
param Avg_Duration{S, M} default 0; #Average duration to produce shoe in set S on machine in set M
param Amt_RM_Shoe{S,R} default 0; #Quantity of raw materials in set RM needed for shoe in set S
param Machine_OpCost{M}; #Machine operation cost
param Machine_OpTime := 12*28*60; #total machine operating time in the month of Feb in minutes
param Warehouse_OpCost{WH};#Operation cost of warehouse in set W
param Warehouse_Capacity{WH}; #Capacity of warehouse in set W
param Budget := 10000000; #Budget
param d{S};
param Num_Machines:= 72; # number of available machines (from Machine_Master Table)
param Penalty_Cost := 10; #penalty cost

#decision variables
var x{S} >= 0; # number of shoes produced

#write the objective func
maximize profit: sum{s in S} Shoe_Cost[s]*x[s]
- sum{ m in M} Machine_OpCost[m]*(Machine_OpTime)
- sum{s in S, m in M} x[s]*Avg_Duration[s, m] * (25/60)
- sum{w in WH} Warehouse_OpCost[w]
- sum{s in S, rm in R} RM_Cost[rm]*x[s]*Amt_RM_Shoe[s,rm]
- sum{s in S} 10 * (d[s] - x[s]);


#write the constraints

#demand constraint
subject to Demand_Co{s in S}: 0 <= x[s] <= d[s]; 
#budget constraint
subject to Budget_Co: sum{s in S, rm in R} RM_Cost[rm]*x[s]*Amt_RM_Shoe[s, rm] = Budget;
#time constraint
subject to Time_Co: sum{s in S, m in M} Avg_Duration[s,m]*x[s] <= (Machine_OpTime*Num_Machines);
#warehouse capacity constraint
subject to Warehouse_Co{w in WH} S: sum{s in S} x[s] <= Warehouse_Capacity[w];
#raw material constraint
subject to RM_Quantity_Available{rm in R}: sum{s in S} (Amt_RM_Shoe[s, rm]*x[s]) <= RM_Amount[rm];













