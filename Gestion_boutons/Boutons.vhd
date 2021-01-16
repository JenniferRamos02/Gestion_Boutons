library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity Boutons is
port (
clk 			 	: in std_logic;
reset_n			: in std_logic;

BP_Babord		: in std_logic;
BP_Tribord		: in std_logic;
BP_STBY			: in std_logic;
	
ledBabord		: out std_logic;
ledTribord		: out std_logic;
ledSTBY			: out std_logic;
out_bip			: out std_logic

);
end Boutons;


ARCHITECTURE BEHAVIORAL of Boutons  is 
----- machine a etats-----

signal clin				: std_logic_vector (1 downto 0);
signal codeFonction	: std_logic_vector (3 downto 0);
signal ledBTfaible	: std_logic;
signal BP_BabordL    : std_logic;
signal BP_TribordL	: std_logic;
type Etat is (Etat0, Etat1, Etat2,Etat3,Etat4,Etat5,Etat6,Etat7);
Signal Etat_present, Etat_futur : Etat := Etat0;

-----clignoter-----------
signal led				: std_logic;
signal counter : std_logic_vector (31 downto 0);
signal Sig 		: std_logic;
signal pwm		: std_logic;
signal Nclin   : std_logic;
signal countPwm: integer;
signal a			: integer;
-----lumiere-------------
signal duty				: std_logic_vector (31 downto 0);
-----pwm-----------------
signal out_pwm 		: std_logic;
signal pwm_nano : std_logic;

begin 

Sequentiel_maj_etat : process (clk,reset_n)

begin

	if reset_n = '0' then
		Etat_present <= Etat0;
		counter <= (others => '0');
		pwm <= '0';
	elsif clk'event and clk = '1' then
		if counter >= X"17D7840" then
			pwm <= NOT pwm;
			counter <= (others => '0');
		else 
			counter <= counter + 1;
		end if;
		Etat_present <= Etat_futur;
	end if;
	
end process Sequentiel_maj_etat;

------------duty_pwm-----------------
compare: process (clk, reset_n)
begin
if reset_n = '0' then
pwm_nano <= '0';
elsif clk'event and clk = '1' then
if counter >= duty then
pwm_nano <= '0';
else
pwm_nano <= '1';
end if;
end if;
end process compare;
--*******************************************************
---change de duty------------

change_duty: process(ledBTfaible)
begin
	if (ledBTfaible='1') then 
		duty <= X"00989680";
	else
		duty <= X"017d7840";
	end if;
end process change_duty; 
--0000000000000000000000000000000000000000000000000000000
out_pwm <= pwm_nano;


Combinatoire_etats : process  (BP_Babord,BP_Tribord,BP_STBY,BP_BabordL,BP_TribordL)

begin

	case Etat_present is
	
		when Etat0 => if BP_STBY =	'1' then
		Etat_futur <= Etat1;
		elsif BP_Babord ='1' then
		Etat_futur <= Etat2;
		elsif BP_Tribord ='1' then
		Etat_futur <=Etat3;
		else
		Etat_futur <= Etat0;
		end if;
		
		when Etat1 => if BP_Babord ='1' then
		Etat_futur <= Etat4;
		elsif BP_Tribord ='1' then
		Etat_futur <= Etat5;
		elsif BP_BabordL ='1' then
		Etat_futur <= Etat6;
		elsif BP_TribordL ='1' then
		Etat_futur <= Etat7; 
		else
		Etat_futur <=Etat1;
		end if;
		
		when Etat2 => if BP_Babord ='0' then
		Etat_futur <= Etat0;
		else
		Etat_futur <=Etat2;
		end if;
		
		when Etat3 => if BP_Tribord ='0' then
		Etat_futur <= Etat0;
		else
		Etat_futur <=Etat3;
		end if;
		
		when Etat4 => if Bp_Babord ='0' then
		Etat_futur <= Etat1;
		else
		Etat_futur <= Etat4;
		end if;
		
		when Etat5 => if Bp_Tribord ='0' then
		Etat_futur <= Etat1;
		else
		Etat_futur <= Etat5;
		end if;
		
		when Etat6 => if Bp_BabordL ='0' then
		Etat_futur <= Etat1;
		else
		Etat_futur <= Etat6;
		end if;
		
		when Etat7 => if Bp_TribordL ='0' then
		Etat_futur <= Etat1;
		else
		Etat_futur <= Etat7;
		end if;

	end case;

end process Combinatoire_etats;

Combinatoire_sorties : process (Etat_present)

begin

	case Etat_present is
		when Etat0 => CodeFonction <= "0000";ledSTBY <= '1';ledBabord <='0';ledTribord <='0';out_bip <='0';clin <="11";ledBTfaible <='1';
		when Etat1 => CodeFonction <= "0011";ledSTBY <= '1';ledBabord <='0';ledTribord <='0';out_bip <='1';clin <="00";ledBTfaible <='0';
		when Etat2 => CodeFonction <= "0001";ledSTBY <= '1';ledBabord <='0';ledTribord <='0';out_bip <='1';clin <="11";ledBTfaible <='1';
		when Etat3 => CodeFonction <= "0010";ledSTBY <= '1';ledBabord <='0';ledTribord <='0';out_bip <='1';clin <="11";ledBTfaible <='1';
		when Etat4 => CodeFonction <= "0100";ledSTBY <= '1';ledBabord <='1';ledTribord <='0';out_bip <='1';clin <="01";ledBTfaible <='0';
		when Etat5 => CodeFonction <= "0111";ledSTBY <= '1';ledBabord <='0';ledTribord <='1';out_bip <='1';clin <="10";ledBTfaible <='0';
		when Etat6 => CodeFonction <= "0101";ledSTBY <= '1';ledBabord <='1';ledTribord <='0';out_bip <='1';clin <="01";ledBTfaible <='0';  -- double clignote
		when Etat7 => CodeFonction <= "0110";ledSTBY <= '1';ledBabord <='0';ledTribord <='1';out_bip <='1';clin <="10";ledBTfaible <='0';  -- double clignote	
	end case;

end process Combinatoire_sorties;

sorties: process (codeFonction)
begin  
 case codeFonction is
	when "0000" =>  ledBabord<=out_pwm; ledTribord<=out_pwm; ledSTBY<=led; out_bip<='0';
	when "0001"	=>	 ledBabord<=out_pwm; ledTribord<=out_pwm; ledSTBY<=led; out_bip<=led;
	when "0010" => ledSTBY <= led; ledBabord <=out_pwm;ledTribord <=out_pwm; out_bip <='1';
	when "0011" =>	ledSTBY <= led; ledBabord <='0'; ledTribord <='0'; out_bip <=led; 	
	when "0100" => ledSTBY <= '1'; ledBabord <=led; ledTribord <='0'; out_bip <=led;
	when "0101" => ledSTBY <= '1'; ledBabord <='0'; ledTribord <=led; out_bip <=led;
	when "0111" => ledSTBY <= '1'; ledBabord <=led; ledTribord <='0'; out_bip <=led;
	when "0110" => ledSTBY <= '1'; ledBabord <='0'; ledTribord <=led; out_bip <=led;
end case;
end process sorties; 


end BEHAVIORAL ;



