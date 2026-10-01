LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all ;


entity complex_mult_twiddle is
  port(
    clk : in std_logic;         
    rst : in std_logic; 
    k  : in integer range 0 to 9;      
    Yr, Yi : in  sfixed(vecteurin'range);                    -- entrada complexa
    Er, Ei : out sfixed(vecteurin'range)   -- saída complexa com mais bits
  );
end entity;
