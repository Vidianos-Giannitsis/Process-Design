clear;clc

FA0 = 42.2;
FA = 0.001*FA0;
Q = 126024;
A = 12.96;
T = 2095.6;
Ea = 46.68;
R = 8.314e-3;

V = ((FA0-FA)*Q)/(A*e^(-Ea/(R*T))*FA)/1e+6
