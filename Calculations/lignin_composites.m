function [percents] = lignin_composites(C, H, O, N)
  total = C+H+O+N;
  C_p = C/total*100;
  H_p = H/total*100;
  O_p = O/total*100;
  N_p = N/total*100;

  percents = [C_p, H_p, O_p, N_p];
endfunction

