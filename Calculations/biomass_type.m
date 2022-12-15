function balances = biomass_type(biomass)
  # Biomass:
  # 1: Sb (stoichiometry of biomass)
  # 2: Cb (carbon in biomass)
  # 3: Hb (hydrogen in biomass)
  # 4: Ob (oxygen in biomass)
  # 5: Nb (nitrogen in biomass)
  S_CO2 = 3.5;
  S_H2O = 2.5;

  balances(1) = biomass(1)*biomass(2) + S_CO2 - 4.167;
  balances(2) = biomass(1)*biomass(3) + 2*S_H2O - 6.333;
  balances(3) = biomass(1)+biomass(4) + S_H2O + 2*S_CO2 - 9.32;
  balances(4) = biomass(1)*biomass(5) - 0.05;
  balances(5) = biomass(1)*(12*biomass(2)+16*biomass(4)+biomass(3)+14*biomass(5)) - 10.385;
endfunction


  
