library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--======================================
-- Declaracao da entity adder
-- Somador para os operandos da calculadora.
-- O operando proveniente de reg1 possui 8 bits. Já o
-- operando proveniente de reg2 possui 4 bits. 
-- Entradas:
--   * a, b: operandos de 8 e 4 bits, respectivamente
-- Saidas:
--   * result: resultado
--   * overflow: indica se houve overflow
--======================================
entity adder is
  port (a        : in  std_logic_vector(7 downto 0);
        b        : in  std_logic_vector(3 downto 0);
        result   : out std_logic_vector(7 downto 0);
		  overflow : out std_logic
       );
end adder;

architecture adderArch of adder is 
  -- Sinal intermediario para efetuar o sign-extend de "b"
  signal s_b : std_logic_vector(7 downto 0);

  component adder8bits is
    port (a, b     : in  std_logic_vector(7 downto 0);
          result   : out std_logic_vector(7 downto 0);
		    overflow : out std_logic
         );
  end component;
  
begin  
  -- Sign-extend
  s_b <= std_logic_vector(resize(signed(b), s_b'length));
  -- Instanciacao do componente adder8bits
  A8B : adder8bits port map (a, s_b, result, overflow);

end adderArch;
  