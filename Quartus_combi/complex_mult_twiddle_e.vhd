LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all ;


entity complex_mult_twiddle is
  generic(
    N     : integer := 16   
  );
  port(
    k  : in integer range 0 to N-1;      
    Yr, Yi : in  sfixed(vecteurin'range);                    
    Er, Ei : out sfixed(vecteurin'range)   
  );
end entity;
