LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all ;

ENTITY fft16OPT_sync IS
  PORT(
    clk   : IN  std_logic;
	 rst : IN  std_logic; 
    x_in  : IN  tab16;
    z_out : OUT tab9
  );
END;
