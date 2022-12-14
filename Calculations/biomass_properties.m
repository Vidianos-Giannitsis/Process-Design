clear;clc

# Biomass in [Carbon, Hydrogen, Oxygen, Nitrogen]
C = 6.2247;
H = 12.3790;
O = 0.1133;
N = 0.4736;
MW_b = 12*C+1*H+16*O+14*N
Density = 1.5 # g/ml
disp("In g/ml")

# Calculate heat capacity
# Molar Heat capacity of elements in J/mol K
C_pm(1) = 28.836; # Hydrogen
C_pm(2) = 8.517; # Carbon (graphite)
C_pm(3) = 29.378; # Oxygen
C_pm(4) = 29.124; # Nitrogen
#C_pm(5) = 23.824; # Phosphorus

# Molecular Weights in kg/mol
Mw(1) = 1/1000; # Hydrogen
Mw(2) = 12/1000; # Carbon
Mw(3) = 16/1000; # Oxygen
Mw(4) = 14/1000; # Nitrogen
#Mw(5) = 31/1000; # Phosphorus

# Mass heat capacities in J/kg K as needed by Kopp's law
C_p = C_pm./Mw;

# Mass fractions
m_f(1) = H/MW_b; # Hydrogen
m_f(2) = 12*C/MW_b; # Carbon
m_f(3) = 16*O/MW_b; # Oxygen
m_f(4) = 14*N/MW_b; # Nitrogen
#m_f(5) = 31*P/MW_b; # Phosphorus

# Biomass heat capacity
Cp_vector = C_p.*m_f;
Heat_Capacity = sum(Cp_vector) # in J/kg K
disp ("In J/kg K")
