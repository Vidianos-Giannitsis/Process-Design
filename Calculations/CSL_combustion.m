clear;clc

csl = [0.94, 2.94, 1.41, 0.04, 0.03] # Biomass type (C, H, O, N, P)

# Combustion stoichiometric coefficients
C = csl(1); # CO_2 coefficient
P = csl(5)/2; # P_2O_5 coefficient
N = csl(4)/2; # N_2 coefficient
H = csl(2)/2; # H_2O coefficient
O = (H+2*C+5*P)-csl(3); # O_2 coefficient

disp ("Combustion coefficients: CSL, Oxygen, Water, Carbon Dioxide, Phosphorus Pentoxide, Nitrogen")
combustion = [1, O, H, C, P, N]

# Heat of Combustion
DH_W = -68.7979; # Θερμότητα σύνθεσης νερού [kcal/mol]
DH_C = -94.052; # Θερμότητα σύνθεσης διοξειδίου του άνθρακα [kcal/mol]
DH_P = -365.83; # Θερμότητα σύνθεσης πεντοξειδίου του φωσφόρου [kcal/mol]

DH = -( H*DH_W + C*DH_C + P*DH_P) # Θερμότητα σύνθεσης CSL [kcal/mol]
disp ("In kcal/mol")

# Gibbs energy of Combustion
DG_W = -237.2; # Ενέργεια Gibbs νερού [kJ/mol]
DG_C = -394.4; # Ενέργεια Gibbs διοξειδίου του άνθρακα [kJ/mol]
DG_P = -1455.75; # Ενέργεια Gibbs πεντοξειδίου του φωσφόρου [kJ/mol]

DG = -( H*DG_W + C*DG_C + P*DG_P) # Ενέργεια Gibbs CSL [kJ/mol]
disp ("In kJ/mol")
