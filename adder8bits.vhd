library IEEE;
use IEEE.std_logic_1164.all;

--======================================
-- Declaracao da entity adder8bits
-- Somador para operandos de 8 bits.
-- Entradas:
--   * a, b: operandos
-- Saidas:
--   * result: resultado
--   * overflow: indica se houve overflow
--======================================
entity adder8bits is
  port (a, b     : in  std_logic_vector(7 downto 0);
        result   : out std_logic_vector(7 downto 0);
		  overflow : out std_logic
       );
end adder8bits;

--======================================
-- Declaracao da arquitetura de adder8bits
--======================================
architecture adder8bitsArch of adder8bits is 
  signal s_carries : std_logic_vector(7 downto 0);
  signal s_result  : std_logic_vector(7 downto 0); 
  
begin
  s_result(0) <= a(0) xor b(0);
  s_carries(0) <= a(0) and b(0);
  
  s_result(1) <= a(1) xor b(1) xor s_carries(0);
  s_carries(1) <= (a(1) and b(1)) or (s_carries(0) and a(1)) or (s_carries(0) and b(1));
  
  s_result(2) <= a(2) xor b(2) xor s_carries(1);
  s_carries(2) <= (a(2) and b(2)) or (s_carries(1) and a(2)) or (s_carries(1) and b(2));
  
  s_result(3) <= a(3) xor b(3) xor s_carries(2);
  s_carries(3) <= (a(3) and b(3)) or (s_carries(2) and a(3)) or (s_carries(2) and b(3));
  
  s_result(4) <= a(4) xor b(4) xor s_carries(3);
  s_carries(4) <= (a(4) and b(4)) or (s_carries(3) and a(4)) or (s_carries(3) and b(4));
  
  s_result(5) <= a(5) xor b(5) xor s_carries(4);
  s_carries(5) <= (a(5) and b(5)) or (s_carries(4) and a(5)) or (s_carries(4) and b(5));
  
  s_result(6) <= a(6) xor b(6) xor s_carries(5);
  s_carries(6) <= (a(6) and b(6)) or (s_carries(5) and a(6)) or (s_carries(5) and b(6));
  
  s_result(7) <= a(7) xor b(7) xor s_carries(6);
  s_carries(7) <= (a(7) and b(7)) or (s_carries(6) and a(7)) or (s_carries(6) and b(7));
  
  result <= s_result;
  overflow <= ((not a(7)) and (not b(7)) and s_result(7)) or (a(7) and b(7) and (not s_result(7)));
  
end adder8bitsArch;
