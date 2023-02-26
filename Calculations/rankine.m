function res = rankine(Qout, Wout)
  m = (Wout+0.389*Qout)/1167.91;
  y = Qout/(2149.16*m);
  z = 0.303*(1-y);
  h5 = 176.81*y + 1274.21;
  qin1 = 3603 - h5;
  qin2 = (1-y)*(3674.9-3236.56);
  eu = (Qout+Wout)/(m*(qin1+qin2));
  disp("Results: m, y, z, h5, qin1, qin2, eu")
  res = [m, y, z, h5, qin1, qin2, eu];
endfunction
