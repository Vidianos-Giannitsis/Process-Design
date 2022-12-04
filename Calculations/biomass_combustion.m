clear;clc

biomass = [3.3345, 4.7184, 3.3818, 5.0335e-2, 1.5016e-3]; # Biomass type

# Combustion stoichiometric coefficients
C = biomass(1); # CO_2 coefficient
P = biomass(5)/2; # P_2O_5 coefficient
N = biomass(4)/2; # N_2 coefficient
H = biomass(2)/2; # H_2O coefficient
O = (H+2*C+5*P)-biomass(3); # O_2 coefficient

disp ("Combustion coefficients: Biomass, Oxygen, Water, Carbon Dioxide, Phosphorus Pentoxide, Nitrogen")
combustion = [1, O, H, C, P, N]

# Heat of Combustion
DH_W = -68.7979; # Θερμότητα σύνθεσης νερού [kcal/mol]
DH_C = -94.052; # Θερμότητα σύνθεσης διοξειδίου του άνθρακα [kcal/mol]

DH = -( H*DH_W + C*DH_C ) # Θερμότητα σύνθεσης βιομάζας [kcal/mol]
disp ("In kcal/mol")
