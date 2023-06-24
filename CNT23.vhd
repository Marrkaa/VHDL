--KTU 2023
--Informatikos fakultetas
--Kompiuteriu katedra
--Skaitmenine Logika [P175B100]
--Dmitrovskis Martynas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CNT23 is port (  
		CLK 		: in std_logic; --Sinchro signalas
		RST 		: in std_logic; -- Reset signalas
		CNT_CMD  	: in std_logic; -- Komanda	
		CNT_C	 	: out std_logic; --Pernasa  
		CNT_O	 	: out std_logic_vector(4 downto  0)
		);
end CNT23;


architecture rtl of CNT23 is
	signal CNT_A: unsigned (4 downto  0); --Penki� bit� dvejetainis skai�ius
begin	
	process(CLK, RST, CNT_CMD)
	begin
		if RST = '1' then
			CNT_A <= "00000"; --Nunulinama reik�m�, jeigu RST = 1
			CNT_C <= '1';	
		elsif CLK'event and CLK = '1' and CNT_CMD = '1' then --Jei CMD ir CLK = 1, skaitiklio darbas nestabdomas
			if CNT_A < 22 then	--Tikrinama ar skaitiklis ma�esnis u� modulio reik�m�
				CNT_A <= CNT_A + 1;
				if CNT_A = 21 then --Jeigu skaitiklio reik�m� art�ja prie modulio reik�m�s
					CNT_C <= '0'; --Perna�os reik�m� pakinta � 0 ir taip su�inome, jog atsirado perna�a
				else
					CNT_C <= '1'; 
				end if;					
			else	  
				CNT_C <= '1';
				CNT_A <= "00000"; --Po perna�os reik�m� nunulinama
			end if;
		end if;		
	end process; 
CNT_O <= std_logic_vector(CNT_A);	
end rtl;		