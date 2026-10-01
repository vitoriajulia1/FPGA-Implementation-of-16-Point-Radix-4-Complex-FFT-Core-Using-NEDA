LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all ;

ENTITY fft16 IS
    PORT(
        x       : IN tab16 ;	-- entre
		  z	    : OUT tab9 	-- sortie 
    );
END fft16;


