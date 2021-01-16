Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Clignote is
port(
     clk,reset_n: in std_logic;
	  clin: in std_logic_vector (1 downto 0);
	  led: out std_logic	  
	   );
end Clignote;

ARCHITECTURE BEHAVIORAL of Clignote is 

signal counter : std_logic_vector (31 downto 0);
signal Sig 		: std_logic;
signal pwm		: std_logic;
signal Nclin   : std_logic;
signal countPwm: integer;
signal a			: integer;
begin

sequential: process (clk, reset_n)
begin
	if reset_n = '0' then
		counter <= (others => '0');
		pwm <= '0';
	elsif clk'event and clk = '1' then
		if counter >= X"17D7840" then
			pwm <= NOT pwm;
			counter <= (others => '0');
		else 
			counter <= counter + 1;
		end if;
	end if;
end process;
      
Compteur_pwm: process (pwm)
begin 
	if pwm'event and pwm = '1' then
		countPwm <= countPwm + 1;
		if (countPwm = a) then
			Sig  <= '0';
			countPwm <= 0;
		end if;
	end if;

end process Compteur_pwm;

process(clin)
begin
	case clin is
	when "00" => Sig <= '1';
	when "01" => a <= 1; 
	when "10" => a <= 2;
	when "11" => Sig <= pwm;
	end case;
end process;

led <=pwm;	

end BEHAVIORAL;