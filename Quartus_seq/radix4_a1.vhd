architecture a2 of radix4 is
  component radix2 is
    port (
      d2 : in  std_logic;
      x0 : in  vecteurin;
      x1 : in  vecteurin;
      yp : out vecteurin;
      ym : out vecteurin
    );
  end component;

  -- Signaux intermédiaires (sorties de l’étage 1, non enregistrées)
  signal Z0r, Z0i, Z1r, Z1i, Z2r, Z2i, Z3r, Z3i : vecteurin;

  -- Registres de pipeline (frontière entre étage 1 et 2)
  signal Z0r_s, Z0i_s, Z1r_s, Z1i_s, Z2r_s, Z2i_s, Z3r_s, Z3i_s : vecteurin;

  -- d20/d21 doivent être alignés avec les données enregistrées
  signal d20_s, d21_s : std_logic;
  
   -- estágio 2 (saídas combinacionais do 2º estágio)
  signal y0r_c, y1r_c, y2r_c, y3r_c : vecteurin;
  signal y0i_c, y1i_c, y2i_c, y3i_c : vecteurin;

  -- 3º estágio: registros de saída (o que vai para fora do radix4)
  signal y0r_r, y1r_r, y2r_r, y3r_r : vecteurin;
  signal y0i_r, y1i_r, y2i_r, y3i_r : vecteurin;

begin
  -----------------------------------------------------------------------------
  -- ÉTAGE 1 (combinational) : 4 papillons radix2 indépendants
  -----------------------------------------------------------------------------
  UUT1 : radix2
    port map ( d2 => '1',  x0 => x0r, x1 => x2r, yp => Z0r, ym => Z1r );

  UUT2 : radix2
    port map ( d2 => '1',  x0 => x0i, x1 => x2i, yp => Z0i, ym => Z1i );

  UUT3 : radix2
    port map ( d2 => '1',  x0 => x1r, x1 => x3r, yp => Z2r, ym => Z3r );

  UUT4 : radix2
    port map ( d2 => '1',  x0 => x1i, x1 => x3i, yp => Z2i, ym => Z3i );

  -----------------------------------------------------------------------------
  -- FRONTIÈRE DE PIPELINE : registres (clk/rst) entre l’étage 1 et 2
  -----------------------------------------------------------------------------
  pipe_reg : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        Z0r_s <= (others => '0');  Z0i_s <= (others => '0');
        Z1r_s <= (others => '0');  Z1i_s <= (others => '0');
        Z2r_s <= (others => '0');  Z2i_s <= (others => '0');
        Z3r_s <= (others => '0');  Z3i_s <= (others => '0');
        d20_s <= '0';
        d21_s <= '0';
      else
        Z0r_s <= Z0r;  Z0i_s <= Z0i;
        Z1r_s <= Z1r;  Z1i_s <= Z1i;
        Z2r_s <= Z2r;  Z2i_s <= Z2i;
        Z3r_s <= Z3r;  Z3i_s <= Z3i;
        d20_s <= d20;  -- alignement du contrôle avec les données
        d21_s <= d21;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- ÉTAGE 2 (combinational) : 4 papillons radix2 sur données enregistrées
  -- Remarque: on utilise d20_s/d21_s pour rester synchrone avec Z*_s
  -----------------------------------------------------------------------------
  -- UUT5/UUT6: branche "k pair" (combinaisons R/R et I/I)
  UUT5 : radix2 port map ( d2 => d20_s, x0 => Z0r_s, x1 => Z2r_s, yp => y0r_c, ym => y2r_c );
  UUT6 : radix2 port map ( d2 => d20_s, x0 => Z0i_s, x1 => Z2i_s, yp => y0i_c, ym => y2i_c );
  -- Branche k impair (mélange croisé R/I)
  UUT7 : radix2 port map ( d2 => d21_s, x0 => Z1r_s, x1 => Z3i_s, yp => y1r_c, ym => y3r_c );
  UUT8 : radix2 port map ( d2 => d21_s, x0 => Z1i_s, x1 => Z3r_s, yp => y3i_c, ym => y1i_c );
  
  -- ========= 3º Estágio: registrar as saídas =========
  out_reg : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '0' then
        y0r_r <= (others=>'0'); y0i_r <= (others=>'0');
        y1r_r <= (others=>'0'); y1i_r <= (others=>'0');
        y2r_r <= (others=>'0'); y2i_r <= (others=>'0');
        y3r_r <= (others=>'0'); y3i_r <= (others=>'0');
      else
        y0r_r <= y0r_c;  y0i_r <= y0i_c;
        y1r_r <= y1r_c;  y1i_r <= y1i_c;
        y2r_r <= y2r_c;  y2i_r <= y2i_c;
        y3r_r <= y3r_c;  y3i_r <= y3i_c;
      end if;
    end if;
  end process;

  y0r <= y0r_r;  y0i <= y0i_r;
  y1r <= y1r_r;  y1i <= y1i_r;
  y2r <= y2r_r;  y2i <= y2i_r;
  y3r <= y3r_r;  y3i <= y3i_r;
end architecture a2;
