architecture a1 of radix4 is
-- Signaux internes 
	component radix2 is
		port (
		d2 : in std_logic;
		x0 : in vecteurin; 
		x1 : in vecteurin; 
		yp : out vecteurin; 
		ym : out vecteurin
			);
	end component radix2;
	 
	signal Z0r,Z0i,Z1r,Z1i,Z2r,Z2i,Z3r,Z3i: vecteurin; 
begin
	-- Appel de l’entité top-level du design à tester 
	UUT1 : radix2
	port map ( d2 => '1' ,  ---MUDEI PARA DIVIDIR TUDO POR DOIS E NO FINAL EU N TER QUE DIVIDIR POR 16²
					x0 => x0r,
					x1 => x2r,
					yp => Z0r, 
					ym => Z1r 
					); 
	UUT2 : radix2
	port map ( d2 => '1' ,
					x0 => x0i,
					x1 => x2i,
					yp => Z0i, 
					ym => Z1i 
					); 
	UUT3 : radix2
	port map ( d2 => '1' ,
					x0 => x1r,
					x1 => x3r,
					yp => Z2r, 
					ym => Z3r 
					);
	UUT4 : radix2
	port map ( d2 => '1' ,
					x0 => x1i,
					x1 => x3i,
					yp => Z2i, 
					ym => Z3i 
					);
	UUT5 : radix2
	port map ( d2 => d20 ,
					x0 => Z0r,
					x1 => Z2r,
					yp => y0r, 
					ym => y2r 
					);
	UUT6 : radix2
	port map ( d2 => d20 ,
					x0 => Z0i,
					x1 => Z2i,
					yp => y0i, 
					ym => y2i 
					);	
	UUT7 : radix2
	port map ( d2 => d21 ,
					x0 => Z1r,
					x1 => Z3i,
					yp => y1r, 
					ym => y3r 
					);
	UUT8 : radix2
	port map ( d2 => d21 ,
					x0 => Z1i,
					x1 => Z3r,
					yp => y3i, 
					ym => y1i 
					);			
	 
 
end architecture a1;