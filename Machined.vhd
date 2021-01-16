nzenLibrary ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Machined is
port(
     clk_50M,raz_n,BP_Babord,BP_Tribord,BP_STBY,BP_BabordL,BP_TribordL: in std_logic;
	  ledBabord,ledTribord,ledSTBY,out_bip,ledBTfaible: out std_logic;
	  clin: in std_logic_vector (1 downto 0);
	  codeFonction :out std_logic_vector (3 downto 0)
	  
	   );
end Machined;

ARCHITECTURE BEHAVIORAL of Machined is 

type Etat is (Etat0, Etat1, Etat2,Etat3,Etat4,Etat5,Etat6,Etat7);
Signal Etat_present, Etat_futur : Etat := Etat0;

begin

 --Machine � Etats--   
 
Sequentiel_maj_etat : process (clk_50M,raz_n)

begin

	if raz_n = '0' then
	Etat_present <= Etat0;
	elsif clk_50M'event and clk_50M = '1' then
	Etat_present <= Etat_futur;
	end if;
	
end process Sequentiel_maj_etat;


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

end BEHAVIORAL;