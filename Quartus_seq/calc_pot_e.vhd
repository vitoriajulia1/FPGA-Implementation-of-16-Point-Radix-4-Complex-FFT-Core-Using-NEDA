LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all ;

--subtype q9 is sfixed(0 downto -9);

entity calc_pot is
--  generic(
--    N     : integer := 9;   -- tamanho da FFT
--	 NBITS : integer := 16    -- bits por componente
--  );
  port(
	 clk : in std_logic;         
    rst : in std_logic; 
	 --valid_in   : in  std_logic;
    --k  : in integer range 0 to N-1;      -- índice k (0..8) si k=1...7 multiplier par deux
    Xr, Xi : in  sfixed(vecteurin'range);                    -- entrada complexa
    Pot : out sfixed(vecteurin'range)    -- -- |X|^2 (potência)
	 --valid_out  : out std_logic
  );
end entity;
