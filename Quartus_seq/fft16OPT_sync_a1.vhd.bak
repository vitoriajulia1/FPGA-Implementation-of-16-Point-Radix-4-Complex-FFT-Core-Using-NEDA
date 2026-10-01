architecture a1 of fft16_sync is

signal x_reg       :  tab16 ;
signal z_reg,z       :  tab9 ;

begin


	process(clk)
	begin
		if rising_edge(clk) then
			x_reg <= x_in;
			z_reg <= z;		
		end if;
	end process; 
	
	UUT : entity work.fft16(a1)  port map(x_reg,z);   
	
	z_out <= z_reg;
	
	
end architecture a1 ;

