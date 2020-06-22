library IEEE;
use IEEE.std_logic_1164.all;

--======================================
-- Declaracao da entity reg8bits
-- Registrador para o resultado de 8 bits.
-- Entradas:
--   * clock, reset
--   * PE: parallel enable, ativa a entrada paralela de dados
--   * P: resultado da ALU de 8 bits na entrada paralela de dados
-- Saida:
--   * Q : resultado de 8 bits guardado no registrador no estado
--		     atual
--======================================
entity reg8bits is
	port (clock, reset : in  std_logic;
	      PE           : in  std_logic;
			P            : in  std_logic_vector(7 downto 0);
			Q            : out std_logic_vector(7 downto 0)
		  );
end reg8bits;

--======================================
-- Declaracao da arquitetura de reg8bits
--======================================
architecture reg8bitsArch of reg8bits is
begin
	process (clock, reset)
	begin
		if reset = '1' then
			Q <= "00000000";
		elsif clock'event and clock = '1' then
			if PE = '1' then 
				Q <= P;
			end if;
		end if;
	end process;
end reg8bitsArch;
