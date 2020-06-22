library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--======================================
-- Declaracao da entity multiplier
-- Multiplicador presente na ALU. Aqui, as 
-- entradas sao ambas de 4 bits. Portanto, se houver
-- um numero no reg1 menor que -8 ou maior que +7, somente 
-- os 4 bits menos significativos serao utilizados na multiplicacao!
-- Entradas:
--   * a, b
-- Saida:
--   * result
--======================================
entity multiplier is
  port (a      : in  std_logic_vector(7 downto 0);
        b      : in  std_logic_vector(3 downto 0);
        result : out std_logic_vector(7 downto 0)
		 );
end multiplier;


--======================================
-- Declaracao da arquitetura de multiplier
--======================================
architecture multiplierArch of multiplier is
  signal s_a : signed(3 downto 0);
  signal s_b : signed(3 downto 0);
  signal s_result : signed(7 downto 0);

begin
  -- Conversao das entradas para signed. Note que apenas 
  -- os 4 bits menos significativos de "a" sao utilizados
  s_a <= signed(a(3 downto 0));
  s_b <= signed(b);
  -- Multiplicacao
  s_result <= s_a * s_b;
  -- Conversao do resultado para std_logic_vector
  result <= std_logic_vector(s_result);
  
end multiplierArch;