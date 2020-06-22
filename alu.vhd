library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--======================================
-- Declaracao da entity alu
-- Unidade Logico-aritmetica da calculadora. alu realiza 
-- as seguintes operacoes, de acordo com o codigo da operacao:
--   - "00": adicao
--   - "01": subtracao
--   - "10": multiplicacao
--   - "11": divisao
-- Entradas
--   * a: operando proveniente de reg1, de 8 bits
--   * b: operando proveniente de reg2, de 4 bits
--   * opCode: codigo da operacao 
-- Saidas:
--   * result: resultado, de 8 bits
--   * overflow: indica se houve overflow na adicao ou subtracao
--   * div0: indica se houve divisao por zero na divisao
--======================================
entity alu is
  port (a         : in  std_logic_vector(7 downto 0);
        b         : in  std_logic_vector(3 downto 0);
		  opCode    : in  std_logic_vector(1 downto 0);
		  result    : out std_logic_vector(7 downto 0);
		  remainder : out std_logic_vector(7 downto 0);
		  overflow  : out std_logic;
		  div0      : out std_logic
		 ); 
end alu;

--======================================
-- Declaracao da arquitetura de alu
--======================================
architecture aluArch of alu is
  signal s_resAdd      : std_logic_vector(7 downto 0); -- Resultado do somador
  signal s_resSub      : std_logic_vector(7 downto 0); -- Resultado do "subtrator"
  signal s_bInv        : std_logic_vector(7 downto 0); -- operando b com sinal invertido
  signal s_resMul      : std_logic_vector(7 downto 0); -- Resultado do multiplicador
  signal s_resDiv      : std_logic_vector(7 downto 0); -- Resultado do divisor
  signal s_remDiv      : std_logic_vector(7 downto 0); -- Resto da divisao
  signal s_overflowAdd : std_logic;
  signal s_overflowSub : std_logic;
  signal s_div0        : std_logic;

  component adder is
    port (a        : in  std_logic_vector(7 downto 0);
          b        : in  std_logic_vector(3 downto 0);
          result   : out std_logic_vector(7 downto 0);
		    overflow : out std_logic
         );
  end component;

  component multiplier is
    port (a      : in  std_logic_vector(7 downto 0);
          b      : in  std_logic_vector(3 downto 0);
          result : out std_logic_vector(7 downto 0)
		   );
  end component;

  component divider is
    port (a         : in  std_logic_vector(7 downto 0);
          b         : in  std_logic_vector(3 downto 0);
          result    : out std_logic_vector(7 downto 0);
		    remainder : out std_logic_vector(7 downto 0);
		    div0      : out std_logic
		   );
  end component;

begin
			
  -- Instanciacao do inversor, que inverte o operando "b", para ser utilizado 
  -- na subtracao.
  INV : adder port map("00000001", not(b), s_bInv, open);
  
  -- Instanciacao do somador, "subtrator", 
  ADD : adder port map(a, b, s_resAdd, s_overflowAdd);
  SUB : adder port map(a, s_bInv(3 downto 0), s_resSub, s_overflowSub);
  MUL : multiplier port map(a, b, s_resMUl);
  DIV : divider port map(a, b, s_resDiv, s_remDiv, s_div0);
  
  -- Saidas
  with opCode select result <=
    s_resAdd when "00",
	 s_resSub when "01",
	 s_resMul when "10",
	 s_resDiv when "11";
  
  overflow <= s_overflowAdd or s_overflowSub when opCode = "00" or opCode = "01" else
              '0';
  remainder <= s_remDiv when opCode = "11" else
               "00000000";
  div0 <= s_div0 when opCode = "11" else
          '0';

end aluArch;