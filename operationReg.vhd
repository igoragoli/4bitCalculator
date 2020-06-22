library IEEE;
use IEEE.std_logic_1164.all;

--======================================
-- Declaracao da entity operationReg
-- Registrador para o código de operação de 2 bits.
-- Entradas:
--   * clock
--   * PE: parallel enable, ativa a entrada paralela de dados
--   * P: código de operação de 2 bits na entrada paralela de dados
-- Saida:
--   * Q : código de operação de 2 bits guardado no registrador no estado
--		     atual
--======================================
entity operationReg is
	port (clock : in  std_logic;
	      PE    : in  std_logic;
			P     : in  std_logic_vector(1 downto 0);
			Q     : out std_logic_vector(1 downto 0)
		  );
end operationReg;

--======================================
-- Declaracao da arquitetura de operationReg
--======================================
architecture operationRegArch of operationReg is
begin
	process (clock)
	begin
		if clock'event and clock = '1' then
			if PE = '1' then 
				Q <= P;
			end if;
		end if;
	end process;
end operationRegArch;
