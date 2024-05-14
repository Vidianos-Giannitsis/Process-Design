sets
i /1,2/;
positive variables
v(i)
CV capital cost
EV environmental impact;
variable
Z objective function;
scalar
w /0.5/;
parameters
c(i) /1 10, 2 20/
e(i) /1 10, 2 5/
total /1000/;
equations
costobj
eiobj
wastecon
TOTAL_COST_FUN;

TOTAL_COST_FUN.. Z =e= w*CV + (1-w)*EV;

costobj.. sum(i, c(i)*v(i)**2) =e= CV;

eiobj.. sum(i, e(i)*v(i)**2) =e= EV;

wastecon.. sum(i, v(i)) =e= total

model wastetreatment /all/;
*solve wastetreatment using NLP minimizing Z;

set par pareto points /1*10/;
parameters
         z_par(par)
         CV_par(par)
         EV_par(par);
scalar pp;
parameter Points(par,*);
for (pp = 1 to 10,
         w = pp*0.1;
         solve wastetreatment using NLP minimizing Z;
                 Z_par(par)$(ord(par) eq pp) = Z.l;
                 CV_par(par)$(ord(par) eq pp) = CV.l;
                 EV_par(par)$(ord(par) eq pp) = EV.l;

                 Points(par, "x")$(ord(par) eq pp) = CV.l;
                 Points(par, "y")$(ord(par) eq pp) = EV.l;

) ;

display v.l, Z_par, CV_par, EV_par, Points
execute_unload "WWTresults1.gdx" Points