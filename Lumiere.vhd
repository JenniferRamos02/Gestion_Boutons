Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Lumiere is
port(
     clk_50M,raz_n,ledBTfaible: in std_logic;
	  duty: out std_logic_vector (31 downto 0)
	  );
end Lumiere;

ARCHITECTURE BEHAVIORAL of Lumiere is 

begin
process (ledBTfaible)

begin

	if ledBTfaible ='1' then
	duty <= x"00989680";
	else 
	duty <= x"017D7840";
	end if;
 
 end process;

end BEHAVIORAL;