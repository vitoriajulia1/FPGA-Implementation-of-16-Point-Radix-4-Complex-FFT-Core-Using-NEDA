LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use work.types.all;

ENTITY radix2 IS
    PORT(
		d2	   : IN  std_logic ;					-- indique si on doit diviser par 2
        x0     : IN  vecteurin ;-- entree 1
        x1     : IN  vecteurin;	-- entree 2
        yp     : OUT vecteurin;	-- sortie somme
	ym     : OUT vecteurin	-- sortie difference
    );
END radix2;
