architecture a1 of fft16 is
-- Signaux internes 
	component radix4 is
		PORT(
        x0r,x0i,x1r,x1i,x2r,x2i,x3r,x3i     : IN sfixed(vecteurin'range) ;	-- entres
	y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i	    : OUT sfixed(vecteurin'range) ;	-- sortie du radix
	d20,d21 : IN std_logic
    );
	end component radix4;
	
	component complex_mult_twiddle is 
		generic(
    N     : integer := 16   -- tamanho da FFT
  );
		port(
    k  : in integer range 0 to N-1;      -- índice k (0..15)
    Yr, Yi : in  vecteurin;                    -- entrada complexa
    Er, Ei : out vecteurin    -- saída complexa com mais bits
		);
	end component complex_mult_twiddle;
	component calc_pot is
		port(
		 Xr, Xi : in  sfixed(vecteurin'range);                    -- entrada complexa
		 Pot : out sfixed(vecteurin'range)    -- -- |X|^2 (potência)
		 ); 	
   end component calc_pot;

		
	signal E5r, E5i, E6r, E6i, E7r, E7i, E9r, E9i, E10r, E10i, E11r, E11i, E13r, E13i, E14r, E14i, E15r, E15i : vecteurin;
	signal x_out_r       :  tab9 ; --calcule des 9 valeurs de sortie
	signal x_out_i       :  tab9 ;	


	signal y0r,  y0i  : vecteurin;
	signal y1r,  y1i  : vecteurin;
	signal y2r,  y2i  : vecteurin;
	signal y3r,  y3i  : vecteurin;
	signal y4r,  y4i  : vecteurin;
	signal y5r,  y5i  : vecteurin;
	signal y6r,  y6i  : vecteurin;
	signal y7r,  y7i  : vecteurin;
	signal y8r,  y8i  : vecteurin;
	signal y9r,  y9i  : vecteurin;
	signal y10r, y10i : vecteurin;
	signal y11r, y11i : vecteurin;
	signal y12r, y12i : vecteurin;
	signal y13r, y13i : vecteurin;
	signal y14r, y14i : vecteurin;
	signal y15r, y15i : vecteurin;

	 
begin
	-- Appel de l’entité top-level du design à tester 
	UUT1 : radix4
	port map (
      x0r => x(0), x0i => ZERO_VECTEURIN,
      x1r => x(4), x1i => ZERO_VECTEURIN,
      x2r => x(8), x2i => ZERO_VECTEURIN,
      x3r => x(12), x3i => ZERO_VECTEURIN,
      y0r => y0r, y0i => y0i,
      y1r => y4r, y1i => y4i,
      y2r => y8r, y2i => y8i,
      y3r => y12r, y3i => y12i,
      d20 => '1',
      d21 => '1'
    ); 
	UUT2 : radix4
	port map (
      x0r => x(1), x0i => ZERO_VECTEURIN,
      x1r => x(5), x1i => ZERO_VECTEURIN,
      x2r => x(9), x2i => ZERO_VECTEURIN,
      x3r => x(13), x3i => ZERO_VECTEURIN,
      y0r => y1r, y0i => y1i,
      y1r => y5r, y1i => y5i,
      y2r => y9r, y2i => y9i,
      y3r => y13r, y3i => y13i,
      d20 => '1',
      d21 => '1'
    ); 
	UUT3 : radix4
	port map (
      x0r => x(2), x0i => ZERO_VECTEURIN,
      x1r => x(6), x1i => ZERO_VECTEURIN,
      x2r => x(10), x2i => ZERO_VECTEURIN,
      x3r => x(14), x3i => ZERO_VECTEURIN,
      y0r => y2r, y0i => y2i,
      y1r => y6r, y1i => y6i,
      y2r => y10r, y2i => y10i,
      y3r => y14r, y3i => y14i,
      d20 => '1',
      d21 => '1'
    );
	UUT4 : radix4
	port map (
      x0r => x(3), x0i => ZERO_VECTEURIN,
      x1r => x(7), x1i => ZERO_VECTEURIN,
      x2r => x(11), x2i => ZERO_VECTEURIN,
      x3r => x(15), x3i => ZERO_VECTEURIN,
      y0r => y3r, y0i => y3i,
      y1r => y7r, y1i => y7i,
      y2r => y11r, y2i => y11i,
      y3r => y15r, y3i => y15i,
      d20 => '1',
      d21 => '1'
    ); 
	UUT5 : complex_mult_twiddle		
	port map(
		k => 1,
		Yr => y5r,
		Yi => y5i,
		Er => E5r,
		Ei => E5i
	);	

	UUT6 : complex_mult_twiddle		
		port map(
			k => 2,
			Yr => y9r,
			Yi => y9i,
			Er => E9r,
			Ei => E9i
		);	

	UUT7 : complex_mult_twiddle		
		port map(
			k => 3,
			Yr => y13r,
			Yi => y13i,
			Er => E13r,
			Ei => E13i
		);	

	UUT8 : complex_mult_twiddle		
		port map(
			k => 2,
			Yr => y6r,
			Yi => y6i,
			Er => E6r,
			Ei => E6i
		);	

	UUT9 : complex_mult_twiddle		
		port map(
			k => 4,
			Yr => y10r,
			Yi => y10i,
			Er => E10r,
			Ei => E10i
		);	

	UUT10 : complex_mult_twiddle		
		port map(
			k => 6,
			Yr => y14r,
			Yi => y14i,
			Er => E14r,
			Ei => E14i
		);	

	UUT11 : complex_mult_twiddle		
		port map(
			k => 3,
			Yr => y7r,
			Yi => y7i,
			Er => E7r,
			Ei => E7i
		);	

	UUT12 : complex_mult_twiddle		
		port map(
			k => 6,
			Yr => y11r,
			Yi => y11i,
			Er => E11r,
			Ei => E11i
		);	

	UUT13 : complex_mult_twiddle		
		port map(
			k => 9,
			Yr => y15r,
			Yi => y15i,
			Er => E15r,
			Ei => E15i
		);
   UUT14 : radix4
  port map (
      x0r => y0r, x0i => y0i,
      x1r => y1r, x1i => y1i,
      x2r => y2r, x2i => y2i,
      x3r => y3r, x3i => y3i,
      y0r => x_out_r(0),  y0i => x_out_i(0),
      y1r => x_out_r(4),  y1i => x_out_i(4),
      y2r => x_out_r(8),  y2i => x_out_i(8),
      y3r => open,        y3i => open,
      d20 => '1',
      d21 => '0'
  );
  UUT15 : radix4
  port map (
      x0r => y4r, x0i => y4i,
      x1r => E5r, x1i => E5i,
      x2r => E6r, x2i => E6i,
      x3r => E7r, x3i => E7i,
      y0r => x_out_r(1),  y0i => x_out_i(1),
      y1r => x_out_r(5),  y1i => x_out_i(5),
      y2r => open,  y2i => open,
      y3r => open,        y3i => open,
      d20 => '0',
      d21 => '0'
  );
  UUT16 : radix4
  port map (
      x0r => y8r, x0i => y8i,
      x1r => E9r, x1i => E9i,
      x2r => E10r, x2i => E10i,
      x3r => E11r, x3i => E11i,
      y0r => x_out_r(2),  y0i => x_out_i(2),
      y1r => x_out_r(6),  y1i => x_out_i(6),
      y2r => open,  y2i => open,
      y3r => open,        y3i => open,
      d20 => '0',
      d21 => '0'
  );
  UUT17 : radix4
  port map (
      x0r => y12r, x0i => y12i,
      x1r => E13r, x1i => E13i,
      x2r => E14r, x2i => E14i,
      x3r => E15r, x3i => E15i,
      y0r => x_out_r(3),  y0i => x_out_i(3),
      y1r => x_out_r(7),  y1i => x_out_i(7),
      y2r => open,  y2i => open,
      y3r => open,        y3i => open,
      d20 => '0',
      d21 => '0'
  );

	calc_Z0 : calc_pot 
	port map(
		 Xr => x_out_r(0),
		 Xi => x_out_i(0),
		 Pot => z(0)
		 ); 
   calc_Z1 : calc_pot 
	port map(
		 Xr => x_out_r(1),
		 Xi => x_out_i(1),
		 Pot => z(1)
		 ); 
	calc_Z2 : calc_pot 
	port map(
		 Xr => x_out_r(2),
		 Xi => x_out_i(2),
		 Pot => z(2)
		 );
	calc_Z3 : calc_pot 
	port map(
		 Xr => x_out_r(3),
		 Xi => x_out_i(3),
		 Pot => z(3)
		 );
	calc_Z4 : calc_pot 
	port map(
		 Xr => x_out_r(4),
		 Xi => x_out_i(4),
		 Pot => z(4)
		 );
	calc_Z5 : calc_pot 
	port map(
		 Xr => x_out_r(5),
		 Xi => x_out_i(5),
		 Pot => z(5)
		 );
	calc_Z6 : calc_pot 
	port map(
		 Xr => x_out_r(6),
		 Xi => x_out_i(6),
		 Pot => z(6)
		 );
	calc_Z7 : calc_pot 
	port map(
		 Xr => x_out_r(7),
		 Xi => x_out_i(7),
		 Pot => z(7)
		 );
	calc_Z8 : calc_pot 
	port map(
		 Xr => x_out_r(8),
		 Xi => x_out_i(8),
		 Pot => z(8)
		 );
	

	 
 
end architecture a1;