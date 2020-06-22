library IEEE;
use IEEE.std_logic_1164.all;

--======================================
-- Declaracao da entity reg4bits
-- Registrador para os operandos de 4 bits.
-- Entradas:
--   * clock, reset
--   * PE: parallel enable, ativa a entrada paralela de dados
--   * P: operando de 4 bits na entrada paralela de dados
-- Saida:
--   * Q : operando de 4 bits guardado no registrador no estado
--		     atual
--======================================
entity reg4bits is
	port (clock, reset : in  std_logic;
	      PE           : in  std_logic;
			P            : in  std_logic_vector(3 downto 0);
			Q            : out std_logic_vector(3 downto 0)
		  );
end reg4bits;

--======================================
-- Declaracao da arquitetura de reg4bits
--======================================
architecture reg4bitsArch of reg4bits is
begin
	process (clock, reset)
	begin
		if reset = '1' then
			Q <= "0000";
		elsif clock'event and clock = '1' then
			if PE = '1' then 
				Q <= P;
			end if;
		end if;
	end process;
end reg4bitsArch;
