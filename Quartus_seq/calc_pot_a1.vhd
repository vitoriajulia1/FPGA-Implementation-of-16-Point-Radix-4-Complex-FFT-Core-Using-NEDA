architecture a1 of calc_pot is
  -- Registres de pipeline (mêmes largeurs que votre code d'origine)
  signal r2_s, i2_s : sfixed(1 downto -22);
  signal sum_u      : sfixed(1 downto -22);

  -- Fils combinatoires entre les étages (mêmes tailles)
  signal r2_c, i2_c : sfixed(1 downto -22);
  signal sum_c      : sfixed(1 downto -22);
begin
  --------------------------------------------------------------------
  -- ÉTAGE 1 (COMB) : calcul des carrés + resize (inchangé)
  --    r2_c = resize(Xr*Xr) ; i2_c = resize(Xi*Xi)
  --------------------------------------------------------------------
  r2_c <= resize(Xr * Xr, r2_s'high, r2_s'low,fixed_wrap,fixed_truncate);
  i2_c <= resize(Xi * Xi, i2_s'high, i2_s'low,fixed_wrap,fixed_truncate);

  --------------------------------------------------------------------
  -- ÉTAGE 2 (COMB) : somme des carrés + resize (inchangé)
  --    sum_c = resize(r2_s + i2_s)
  --------------------------------------------------------------------
  sum_c <= resize(r2_s + i2_s, r2_s'high, r2_s'low,fixed_wrap,fixed_truncate);

  --------------------------------------------------------------------
  -- PIPELINE (SEQ) : 3 registres successifs
  --  - cycle N   : r2_s/i2_s <= r2_c/i2_c   (sorties de l’étage 1)
  --  - cycle N+1 : sum_u     <= sum_c       (sortie de l’étage 2)
  --  - cycle N+2 : Pot       <= resize(sum_u, Pot'left, Pot'right)
  --                (resize final inchangé)
  --------------------------------------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        r2_s  <= (others => '0');
        i2_s  <= (others => '0');
        sum_u <= (others => '0');
        Pot   <= (others => '0');
      else
        -- Frontière Étage1→REG
        r2_s  <= r2_c;
        i2_s  <= i2_c;

        -- Frontière Étage2→REG
        sum_u <= sum_c;

        -- Sortie Étage3 (REG) : resize final vers Pot
        Pot   <= resize(sum_u, Pot'left, Pot'right,fixed_wrap,fixed_truncate);
      end if;
    end if;
  end process;
end architecture;