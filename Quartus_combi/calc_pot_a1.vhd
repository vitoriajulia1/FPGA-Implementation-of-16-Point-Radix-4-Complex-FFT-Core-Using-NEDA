architecture a1 of calc_pot is
	signal r2_s, i2_s : sfixed(1 downto -22);
  
  signal sum_u      : sfixed(1 downto -22);  -- +1 bit pour la somme 
  
  
begin


  r2_s <= resize(Xr * Xr, r2_s'high, r2_s'low);
  i2_s <= resize(Xi * Xi, i2_s'high, i2_s'low);

  sum_u <= resize(r2_s  +  i2_s, r2_s'high, r2_s'low);

  Pot <= resize( sum_u, Pot'left, Pot'right ); 


end architecture;
