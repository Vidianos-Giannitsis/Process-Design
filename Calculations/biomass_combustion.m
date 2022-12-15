clear;clc

biomass = [6.2332, 12.3790, 0.1133, 0.4736]; # Biomass type (C, H, O, N)

# Combustion stoichiometric coefficients
C = biomass(1); # CO_2 coefficient
N = biomass(4)/2; # N_2 coefficient
H = biomass(2)/2; # H_2O coefficient
O = (H+2*C)-biomass(3); # O_2 coefficient

disp ("Combustion coefficients: Biomass, Oxygen, Water, Carbon Dioxide, Nitrogen")
combustion = [1, O, H, C, N]

# Heat of Combustion
DH_W = -68.7979; # Θερμότητα σύνθεσης νερού [kcal/mol]
DH_C = -94.052; # Θερμότητα σύνθεσης διοξειδίου του άνθρακα [kcal/mol]

DH = -( H*DH_W + C*DH_C) # Θερμότητα σύνθεσης βιομάζας [kcal/mol]
disp ("In kcal/mol")

# Gibbs energy of Combustion
DG_W = -237.2; # Ενέργεια Gibbs νερού [kJ/mol]
DG_C = -394.4; # Ενέργεια Gibbs διοξειδίου του άνθρακα [kJ/mol]

DG = -( H*DG_W + C*DG_C ) # Ενέργεια Gibbs βιομάζας [kJ/mol]
disp ("In kJ/mol")
