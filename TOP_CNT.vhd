--KTU 2023
--Informatikos fakultetas
--Kompiuteriu katedra
--Skaitmenine Logika [P175B100]
--Dmitrovskis Martynas

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TOP_CNT is port (  
		
		CLK_I 	: in std_logic; --Sinchro signalas
		RST_I 	: in std_logic; -- Reset signalas
		ENBL_I 	: in std_logic; -- Aktyvavimo signalas	
		CNT_CO	: out std_logic --Pernasa
		);
end TOP_CNT;		

architecture struct of TOP_CNT is  

signal C,RST_internal,C1,C2,C3 : std_logic;
signal CNT_1_O :  std_logic_vector(4 downto 0);
signal CNT_2_O :  std_logic_vector(4 downto 0);
signal CNT_3_O :  std_logic_vector(4 downto 0);

component	 CNT31 
	port	(
		CLK : in std_logic; --Sinchro signalas
		RST : in std_logic; -- Reset signalas
		CNT_CMD  : in std_logic; -- Komanda	
		CNT_C	 : out std_logic; --Pernasa
		CNT_O	 : out std_logic_vector(4 downto  0) );	
end component;	

component	 CNT25 
	port  (
		CLK : in std_logic; --Sinchro signalas
		RST : in std_logic; -- Reset signalas
		CNT_CMD  : in std_logic; -- Komanda	
		CNT_C	 : out std_logic; --Kai pasiekia 0  
		CNT_O	 : out std_logic_vector(4 downto  0) );	
end component;

component	 CNT23 
	port  (
		CLK : in std_logic; --Sinchro signalas
		RST : in std_logic; -- Reset signalas
		CNT_CMD  : in std_logic; -- Komanda	
		CNT_C	 : out std_logic; --Kai pasiekia 0  
		CNT_O	 : out std_logic_vector(4 downto  0) );	
end component;


begin
	CNT_1: 	CNT31	port map (CLK=>CLK_I,   --Apsira�oma CNT31 kopija kaip nurodyta port map bloke
		RST=>RST_internal, CNT_CMD=>ENBL_I, 
		CNT_C=>C1, CNT_O=>CNT_1_O);
		
	CNT_2:	CNT25  port map (CLK=> C1,  
		RST=>RST_internal, CNT_CMD=>ENBL_I, --Apsira�oma CNT25 kopija kaip nurodyta port map bloke
		CNT_C=>C2, CNT_O=>CNT_2_O);
		
	CNT_3:	CNT23  port map (CLK=> C2,  
		RST=>RST_internal, CNT_CMD=>ENBL_I, --Apsira�oma CNT31 kopija kaip nurodyta port map bloke
		CNT_C=>C3, CNT_O=>CNT_3_O);
	process(CLK_I,RST_I)
	begin 
		if 	(RST_I = '1') then
			RST_internal <=	'1';  
		elsif CLK_I'event and CLK_I = '1' then  
			if ((CNT_3_O(0) = '1') 		 --/------------------------------------------/
			and (CNT_2_O(3) = '1') 		 --/
			and (CNT_2_O(1) = '1') 		 --/ Tikrinama nustatymo � nulin� b�sen� s�lyga
			and (CNT_1_O(4) = '1') 		 --/
			and (CNT_1_O(2) = '1') 		 --/
			and (CNT_1_O(0) = '1'))  then  --/------------------------------------------/
				RST_internal <=	'1'; --Nunulinamos visos reik�m�s jei yra galutin� perna�a
				CNT_CO <= '1'; --Indikuoja, jog �vyko galutin� perna�a ir buvo pasiektas jungtinio skaitiklio modulis
			else
				RST_internal <=	'0';  
				CNT_CO <= '0';	
			end if;			
		end if;
	end process;
end struct;