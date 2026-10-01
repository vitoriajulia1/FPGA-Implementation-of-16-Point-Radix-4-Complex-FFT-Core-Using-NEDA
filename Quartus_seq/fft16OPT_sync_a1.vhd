architecture a1 of fft16OPT_sync is
  signal x_reg : tab16;
  signal z_reg : tab9;
  signal z     : tab9;
begin
  process(clk)
  begin
    if rising_edge(clk) then
      x_reg <= x_in;
      z_reg <= z;
    end if;
  end process;

  UUT : entity work.fft16OPT(a1)
    port map (
      clk => clk,      -- << passe o clock
       rst => '1',   -- ou rst se existir
      x   => x_reg,
      z   => z
    );

  z_out <= z_reg;
end architecture;