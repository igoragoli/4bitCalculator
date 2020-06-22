library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--======================================
-- Declaracao da entity divider
-- Divisor presente na ALU. O dividendo sera proveniente
-- de reg1, isto é, o primeiro numero que o usuario inserir na
-- calculadora. O divisor sera proveniente de reg2, o segundo numero
-- que o usuario inserir na calculadora. o dividendo possui 8 bits,
-- e o divisor, 4.
-- Entradas:
--   * a: dividendo 
--   * b: divisor
-- Saida:
--   * result: resultado
--   * remainder: resto da divisao
--   * div0: indica se o usuario tentou dividir por zero! Neste caso,
--   * todas as saidas serao negadas
--======================================
entity divider is
  port (a         : in  std_logic_vector(7 downto 0);
        b         : in  std_logic_vector(3 downto 0);
        result    : out std_logic_vector(7 downto 0);
		  remainder : out std_logic_vector(7 downto 0);
		  div0      : out std_logic
		 );
end divider;

--======================================
-- Declaracao da arquitetura de multiplier
--======================================
architecture dividerArch of divider is
  signal s_a         : signed(7 downto 0);
  signal s_b         : signed(7 downto 0);
  signal s_result    : signed(7 downto 0);
  signal s_remainderAux : unsigned(7 downto 0);
  signal s_remainder : signed(7 downto 0);
  signal s_div0      : std_logic;
  
begin
  -- Divisao por zero
  s_div0 <= not(b(3) or b(2) or b(1) or b(0));
  div0 <= s_div0;
  
  -- Conversao das entradas para signed
  s_a <= signed(a);
  s_b <= resize(signed(b), s_b'length);
  
  -- Divisao
  s_result <= s_a / s_b;
  -- Conversao do resultado para std_logic_vector
  result <= std_logic_vector(s_result) when s_div0 = '0' else
            "00000000";
  
  -- Resto
  s_remainder <= s_a rem s_b;
  -- Conversao do resto para std_logic_vector
  remainder <= std_logic_vector(s_remainder) when s_div0 = '0' else
               "00000000";
					
end dividerArch;



