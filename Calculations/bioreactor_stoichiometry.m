clear;clc

# Mass Flows (tn/y)
m(1) = 32692.2; # Γλυκόζη
m(2) = 212.8; # Ουρία
m(3) = 283.79; # CSL
m(4) = 13643; # Γλυκερόλη
m(5) = 640.48; # Αραβιτόλη
m(6) =  168.82; # Αιθανόλη
m(7) = 165.99; # Οξικό Οξύ

# Molecular weights (tn/Mmol)
MW(1) =  180.156; # Γλυκόζη
MW(2) = 60.06;  # Ουρία
MW(3) = 38.270;   # CSL
MW(4) = 92.09;  # Γλυκερόλη
MW(5) = 152.14;  # Αραβιτόλη
MW(6) = 46.07;	  # Αιθανόλη
MW(7) = 60;	   # Οξικό Οξύ

# Molar Flows (Mmol/y)
n = m./MW;

# Stoichiometry (on glycerol basis)
s_gluc = n(1)/n(4)
s_urea = n(2)/n(4)
s_CSL = n(3)/n(4)
s_arab = n(5)/n(4)
s_eth = n(6)/n(4)
s_acet = n(7)/n(4)
