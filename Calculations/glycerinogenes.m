clear;clc

# Batch ανά χρόνο
t_s = 80; # Χρόνος παραμονης (h)
t_d = 0; # Χρόνος μη παραγωγικών διαδικασιών (h)
batches = floor(8760/(t_s+t_d)); # Batches τον χρόνο

# Γλυκόζη στον αντιδραστήρα
S = 230.44; # Συγκέντρωση υποστρώματος (g/l)
S_y = S*batches; # Κατανάλωση υποστρώματος (g/l*year)
Biomass = 200000; # Βιομάζα (tn)
C_conc = 0.375; # Ποσό κυτταρίνης στη βιομάζα (%)
S_available = Biomass*C_conc*10^6; # Διαθέσιμο υπόστρωμα τον χρόνο (g/year)

V_r = (S_available/S_y)/1000 # Όγκος αντιδραστήρα (m^3)

# Γλυκερόλη
P = 96.1651; # Συγκέντρωση προιόντος (g/l)
P_y = (P*batches*V_r)/1e+3 # Παραγωγή προιόντος (tn/year)

# Άλλα θρεπτικά μέσα
urea = 2; # Συγκέντρωση ουρίας (g/l)
csl = 4; # Συγκέντρωση csl (g/l)
urea_y = (urea*batches*V_r)/1e+3; # Κατανάλωση ουρίας (tn/year)
csl_y = (csl*batches*V_r)/1e+3; # Κατανάλωση csl (tn/year)

# Παραπροιόντα
arabitol = 4.516; # Συγκέντρωση αραβιτόλης (g/l)
ethanol = 1.19; # Συγκέντρωση αιθανόλης (g/l)
acetate = 1.17; # Συγκέντρωση οξικού οξέος (g/l)
arabitol_y = (arabitol*batches*V_r)/1e+3 # Παραγωγή αραβιτόλης (tn/year)
ethanol_y = (ethanol*batches*V_r)/1e+3 # Παραγωγή αιθανόλης (tn/year)
acetate_y = (acetate*batches*V_r)/1e+3 # Παραγωγή Οξικού Οξέος (tn/year)

# Οικονομικά
glyc_price = 721.07; # Γλυκερόλη (euro/tn)
urea_price = 638.13; # Ουρία (euro/tn)
csl_price = 360; # Corn steep liquor (euro/tn)

cost = urea_y*urea_price + csl_y*csl_price # Κόστος (euro/year)
income = P_y*glyc_price # Κέρδος (euro/year)
EP = income-cost # Οικονομικό δυναμικό (euro/year)
