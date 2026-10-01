LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all ;


entity calc_pot is
  port(
    Xr, Xi : in  sfixed(vecteurin'range);   -- entree complexe
    Pot : out sfixed(vecteurin'range)    -- -- |X|^2 (puissance)
  );
end entity;
