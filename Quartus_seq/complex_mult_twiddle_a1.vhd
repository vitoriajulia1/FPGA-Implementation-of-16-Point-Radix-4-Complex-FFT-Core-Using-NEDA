architecture pipelined of complex_mult_twiddle is
  -- -------- Étape 1a : pré-sommes élémentaires (REG) --------
  signal k_s1a                      : integer range 0 to 15;
  signal Yr_s1a, Yi_s1a             : sfixed(vecteurin'range);

	-- Étape 1a : taps + pré-sommes 2-à-2 (REG)
	signal Yr_sh8_s, Yi_sh8_s                                   : sfixed(vecteurin'range); -- +2^-8

	-- c1 = (+1/2 −1/8)  &  (+1/128 −1/4096)
	signal c1a_Yr_s, c1b_Yr_s, c1a_Yi_s, c1b_Yi_s               : sfixed(vecteurin'range);

	-- c2 = (+1 −1/16)  &  (−1/64 +1/512)
	signal c2a_Yr_s, c2b_Yr_s, c2a_Yi_s, c2b_Yi_s               : sfixed(vecteurin'range);

	-- c3 = (+1 −1/4)  &  (−1/16 +1/64) ; +2^-8 ajouté en 1b
	signal c3a_Yr_s, c3b_Yr_s, c3a_Yi_s, c3b_Yi_s               : sfixed(vecteurin'range);

  -- -------- Étape 1b : combinaisons finales des pré-sommes (REG) --------
  signal k_s1b                      : integer range 0 to 15;
  signal Yr_s1b, Yi_s1b             : sfixed(vecteurin'range);
  signal c1Yr_s, c2Yr_s, c3Yr_s     : sfixed(vecteurin'range);
  signal c1Yi_s, c2Yi_s, c3Yi_s     : sfixed(vecteurin'range);

  -- Sommes partielles COMB (même format que vos vEr/vEi)
  signal pA_c, pB_c, pC_c, pD_c, pE_c, pF_c : sfixed(2 downto -22);
  -- Sommes partielles REGISTRÉES
  signal pA_s, pB_s, pC_s, pD_s, pE_s, pF_s : sfixed(2 downto -22);
  signal k_s2                   : integer range 0 to 15;
  signal Yr_s2, Yi_s2           : sfixed(vecteurin'range);

  -- Étape 3 : sélection/néga (reg)
  signal Er_s3, Ei_s3           : sfixed(2 downto -22);
begin
  -- ===================== ÉTAGE 1a : PRÉ-SOMMES 2-À-2 (REG) =====================
  -- Idée : les décalages coûtent peu ; ce qui limite Fmax est la profondeur de la chaîne
  -- d'additions. On calcule ici des paires (±tap1 ±tap2) puis on REGISTRE.
  stage1a : process(clk, rst)
  begin
    if rst = '0' then
      k_s1a   <= 0;
      Yr_s1a  <= (others => '0');  Yi_s1a <= (others => '0');
      Yr_sh8_s <= (others => '0'); Yi_sh8_s <= (others => '0');

      c1a_Yr_s <= (others => '0'); c1b_Yr_s <= (others => '0');
      c2a_Yr_s <= (others => '0'); c2b_Yr_s <= (others => '0');
      c3a_Yr_s <= (others => '0'); c3b_Yr_s <= (others => '0');

      c1a_Yi_s <= (others => '0'); c1b_Yi_s <= (others => '0');
      c2a_Yi_s <= (others => '0'); c2b_Yi_s <= (others => '0');
      c3a_Yi_s <= (others => '0'); c3b_Yi_s <= (others => '0');
    elsif rising_edge(clk) then
      -- Latch des entrées pour l’amorçage pipeline
      k_s1a  <= k;
      Yr_s1a <= Yr;
      Yi_s1a <= Yi;

      -- Taps isolés utilisés plus tard (ici 2^-8)
      Yr_sh8_s <= shift_right(Yr, 8);
      Yi_sh8_s <= shift_right(Yi, 8);

      -- ------- Pré-sommes pour c1 : (+2^-1 -2^-3) et (+2^-7 -2^-12)
      c1a_Yr_s <= resize( shift_right(Yr,1) - shift_right(Yr,3),  c1a_Yr_s'high, c1a_Yr_s'low,fixed_wrap,fixed_truncate);
      c1b_Yr_s <= resize( shift_right(Yr,7) - shift_right(Yr,12), c1b_Yr_s'high, c1b_Yr_s'low,fixed_wrap,fixed_truncate);
      c1a_Yi_s <= resize( shift_right(Yi,1) - shift_right(Yi,3),  c1a_Yi_s'high, c1a_Yi_s'low,fixed_wrap,fixed_truncate);
      c1b_Yi_s <= resize( shift_right(Yi,7) - shift_right(Yi,12), c1b_Yi_s'high, c1b_Yi_s'low,fixed_wrap,fixed_truncate);

      -- ------- Pré-sommes pour c2 : (+1 -2^-4) et (-2^-6 +2^-9)
      c2a_Yr_s <= resize( Yr - shift_right(Yr,4),                  c2a_Yr_s'high, c2a_Yr_s'low,fixed_wrap,fixed_truncate);
      c2b_Yr_s <= resize(-shift_right(Yr,6) + shift_right(Yr,9),   c2b_Yr_s'high, c2b_Yr_s'low,fixed_wrap,fixed_truncate);
      c2a_Yi_s <= resize( Yi - shift_right(Yi,4),                  c2a_Yi_s'high, c2a_Yi_s'low,fixed_wrap,fixed_truncate);
      c2b_Yi_s <= resize(-shift_right(Yi,6) + shift_right(Yi,9),   c2b_Yi_s'high, c2b_Yi_s'low,fixed_wrap,fixed_truncate);

      -- ------- Pré-sommes pour c3 : (+1 -2^-2) et (-2^-4 +2^-6)  (le +2^-8 viendra en 1b)
      c3a_Yr_s <= resize( Yr - shift_right(Yr,2),                  c3a_Yr_s'high, c3a_Yr_s'low,fixed_wrap,fixed_truncate);
      c3b_Yr_s <= resize(-shift_right(Yr,4) + shift_right(Yr,6),   c3b_Yr_s'high, c3b_Yr_s'low,fixed_wrap,fixed_truncate);
      c3a_Yi_s <= resize( Yi - shift_right(Yi,2),                  c3a_Yi_s'high, c3a_Yi_s'low,fixed_wrap,fixed_truncate);
      c3b_Yi_s <= resize(-shift_right(Yi,4) + shift_right(Yi,6),   c3b_Yi_s'high, c3b_Yi_s'low,fixed_wrap,fixed_truncate);
    end if;
  end process;

  -- ===================== ÉTAGE 1b : COMBINAISONS FINALES (REG) ==================
  -- On combine maintenant les pré-sommes (+ le tap 2^-8 de c3) et on REGISTRE les c1/c2/c3.
  stage1b : process(clk, rst)
  begin
    if rst = '0' then
      k_s1b   <= 0;
      Yr_s1b  <= (others => '0');  Yi_s1b <= (others => '0');
      c1Yr_s  <= (others => '0');  c2Yr_s <= (others => '0');  c3Yr_s <= (others => '0');
      c1Yi_s  <= (others => '0');  c2Yi_s <= (others => '0');  c3Yi_s <= (others => '0');
    elsif rising_edge(clk) then
      -- Alignement pipeline
      k_s1b  <= k_s1a;
      Yr_s1b <= Yr_s1a;
      Yi_s1b <= Yi_s1a;

      -- Combinaisons finales 
      c1Yr_s <= resize( c1a_Yr_s + c1b_Yr_s, c1Yr_s'high, c1Yr_s'low,fixed_wrap,fixed_truncate);
      c1Yi_s <= resize( c1a_Yi_s + c1b_Yi_s, c1Yi_s'high, c1Yi_s'low,fixed_wrap,fixed_truncate);

      c2Yr_s <= resize( c2a_Yr_s + c2b_Yr_s, c2Yr_s'high, c2Yr_s'low,fixed_wrap,fixed_truncate);
      c2Yi_s <= resize( c2a_Yi_s + c2b_Yi_s, c2Yi_s'high, c2Yi_s'low,fixed_wrap,fixed_truncate);

      -- Pour c3 : (c3a + c3b) puis ajout du +2^-8
      c3Yr_s <= resize( (c3a_Yr_s + c3b_Yr_s) + Yr_sh8_s, c3Yr_s'high, c3Yr_s'low,fixed_wrap,fixed_truncate);
      c3Yi_s <= resize( (c3a_Yi_s + c3b_Yi_s) + Yi_sh8_s, c3Yi_s'high, c3Yi_s'low,fixed_wrap,fixed_truncate);
    end if;
  end process;

  -- ===================== ÉTAGE 2A : SOMMES PARTIELLES (COMB) =====================
  -- pA = c2*Yr + c1*Yi
  pA_c <= resize(c2Yr_s + c1Yi_s, pA_c'high, pA_c'low,fixed_wrap,fixed_truncate);
  -- pB = c1*Yr + c2*Yi
  pB_c <= resize(c1Yr_s + c2Yi_s, pB_c'high, pB_c'low,fixed_wrap,fixed_truncate);
  -- pC = c3*Yr + c3*Yi
  pC_c <= resize(c3Yr_s + c3Yi_s, pC_c'high, pC_c'low,fixed_wrap,fixed_truncate);
  -- pD = c3*Yi - c3*Yr
  pD_c <= resize(c3Yi_s - c3Yr_s, pD_c'high, pD_c'low,fixed_wrap,fixed_truncate);
  -- pE = c2*Yi - c1*Yr
  pE_c <= resize(c2Yi_s - c1Yr_s, pE_c'high, pE_c'low,fixed_wrap,fixed_truncate);
  -- pF = c1*Yi - c2*Yr
  pF_c <= resize(c1Yi_s - c2Yr_s, pF_c'high, pF_c'low,fixed_wrap,fixed_truncate);

  -- ===================== ÉTAGE 2B : REGISTRES DES PARTIELLES =====================
  stage2b: process(clk, rst)
  begin
    if rst = '0' then
      pA_s <= (others => '0'); pB_s <= (others => '0'); pC_s <= (others => '0');
      pD_s <= (others => '0'); pE_s <= (others => '0'); pF_s <= (others => '0');
      k_s2 <= 0;
      Yr_s2 <= (others => '0'); Yi_s2 <= (others => '0');
    elsif rising_edge(clk) then
      pA_s <= pA_c;  pB_s <= pB_c;  pC_s <= pC_c;
      pD_s <= pD_c;  pE_s <= pE_c;  pF_s <= pF_c;
      k_s2  <= k_s1b;
      Yr_s2 <= Yr_s1b;
      Yi_s2 <= Yi_s1b;
    end if;
  end process;

  -- ===================== ÉTAGE 3 : SÉLECTION / SIGNE (REG) =====================
  stage3: process(clk, rst)
    variable vEr, vEi : sfixed(2 downto -22);
  begin
    if rst = '0' then
      Er_s3 <= (others => '0');
      Ei_s3 <= (others => '0');
    elsif rising_edge(clk) then
      -- valeurs par défaut
      vEr := (others => '0');  vEi := (others => '0');

      case k_s2 is
        when 1 =>
          -- Er =  c2*Yr + c1*Yi =  pA
          -- Ei = -c1*Yr + c2*Yi =  -(c1*Yr - c2*Yi) = -(-pE) =  pE
          vEr := pA_s;
          vEi := pE_s;

        when 2 =>
          -- Er =  c3*Yr + c3*Yi =  pC
          -- Ei =  c3*Yi - c3*Yr =  pD
          vEr := pC_s;
          vEi := pD_s;

        when 3 =>
          -- Er =  c1*Yr + c2*Yi =  pB
          -- Ei =  c1*Yi - c2*Yr =  pF
          vEr := pB_s;
          vEi := pF_s;

        when 4 =>
          -- Er =  Yi ;  Ei = -Yr
          vEr := resize(Yi_s2, vEr'high, vEr'low,fixed_wrap,fixed_truncate);
          vEi := resize(-Yr_s2, vEi'high, vEi'low,fixed_wrap,fixed_truncate);

			when 6 =>
			  -- Er =  c3*Yi - c3*Yr = pD
			  -- Ei = -(c3*Yi + c3*Yr) = -pC
			  vEr := pD_s;
			  vEi := resize(-pC_s, vEi'high, vEi'low,fixed_wrap,fixed_truncate);   

			when 9 =>
			  -- Er = -(c2*Yr + c1*Yi) = -pA
			  -- Ei =  c1*Yr - c2*Yi   = -pE
			  vEr := resize(-pA_s, vEr'high, vEr'low,fixed_wrap,fixed_truncate);  
			  vEi := resize(-pE_s, vEi'high, vEi'low,fixed_wrap,fixed_truncate);  

        when others =>
          null;
      end case;

      Er_s3 <= vEr;
      Ei_s3 <= vEi;
    end if;
  end process;

  -- ===================== ÉTAGE 4 : REDIMENSION / SORTIE (COMB) =====================
  Er <= resize(Er_s3, Er'high, Er'low,fixed_wrap,fixed_truncate);
  Ei <= resize(Ei_s3, Ei'high, Ei'low,fixed_wrap,fixed_truncate);
end architecture;
