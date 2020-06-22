library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--======================================
-- Declaracao da entity calculator
-- Unidade de controle e fluxo de dados da calculadora
-- Entradas:
--   * clock, reset
--   * storeInput: promove o carregamento do operando nos registradores adequados
--   * storeOperation: promove o carregamento do codigo da operação nos registradores adequados
--   * calculate: calcular resultado final
-- Saidas:
--   *
--   * db_Q: sinal de depuracao. Palavra de 4 bits que representa o estado atual
--======================================
entity calculator is
  port (clock, reset   : in  std_logic;
		  storeInput     : in  std_logic;
		  storeOperation : in  std_logic;
		  calculate      : in  std_logic;
		  opCode         : in  std_logic_vector(1 downto 0);
		  operand        : in  std_logic_vector(3 downto 0);
		  Q1             : out std_logic_vector(7 downto 0);
		  Q2             : out std_logic_vector(3 downto 0);
		  result         : out std_logic_vector(7 downto 0);
		  remainder      : out std_logic_vector(7 downto 0);
		  overflow       : out std_logic;
		  div0           : out std_logic;
		  db_remainderALU: out std_logic_vector(7 downto 0);
		  db_resultALU : out std_logic_vector(7 downto 0);
		  db_opCode : out std_logic_vector(1 downto 0);
		  db_Q           : out std_logic_vector(3 downto 0)
		 );
end calculator;

--======================================
-- Declaracao da arquitetura de calculator
--======================================
architecture calculatorArch of calculator is
  -- Sinais intermediarios do fluxo de dados
  signal s_operand8bits : std_logic_vector(7 downto 0); -- "operand" com sign-extend
  signal s_P1           : std_logic_vector(7 downto 0); -- Entrada paralela em REG1
  signal s_Q1           : std_logic_vector(7 downto 0); -- Saida de REG1
  signal s_Q2           : std_logic_vector(3 downto 0); -- Saida de REG2
  signal s_Q3           : std_logic_vector(7 downto 0); -- Saida de REG3
  signal s_Q4           : std_logic_vector(7 downto 0); -- Saida de REG4
  signal s_resultALU    : std_logic_vector(7 downto 0); -- Resultado de uma operacao na ULA
  signal s_remainderALU : std_logic_vector(7 downto 0); -- Resto de uma possivel divisao na ULA
  signal s_opP1         : std_logic_vector(1 downto 0); -- Entrada paralela em OPREG1
  signal s_opQ1         : std_logic_vector(1 downto 0); -- Saida de OPREG1
  signal s_opQ2         : std_logic_vector(1 downto 0); -- Saida de OPREG2
  signal s_showRem      : std_logic;                    -- Exiba o resto da divisao ao usuario
  signal s_div0Aux      : std_logic;                    -- Sinal auxiliar para div0
  
  -- Sinais de controle
  signal s_clear             : std_logic; -- clear
  signal s_pI1, s_pI2, s_pI3 : std_logic; -- parallelInput1, 2 e 3
  signal s_sOp1, s_sOp2      : std_logic; -- storeOp1 e 2
  signal s_reg3toReg1        : std_logic; -- reg3toReg1
  signal s_op2toOp1          : std_logic; -- op2toOp1
  signal s_showFinalResult   : std_logic; -- showFinalResult
  
  component controlUnit is
    port (clock, reset   : in  std_logic;
		    storeInput     : in  std_logic;
		    storeOperation : in  std_logic;
		    calculate      : in  std_logic;
		    clear          : out std_logic;
		    parallelInput1, parallelInput2, parallelInput3 : out std_logic;
		    storeOp1, storeOp2 : out std_logic;
		    reg3toReg1         : out std_logic;
		    op2toOp1           : out std_logic;
		    showFinalResult    : out std_logic;
		    db_Q               : out std_logic_vector(3 downto 0)
			 );
  end component;
  
  component alu is
    port (a         : in  std_logic_vector(7 downto 0);
          b         : in  std_logic_vector(3 downto 0);
	       opCode    : in  std_logic_vector(1 downto 0);
		    result    : out std_logic_vector(7 downto 0);
		    remainder : out std_logic_vector(7 downto 0);
		    overflow  : out std_logic;
		    div0      : out std_logic
		   ); 
  end component;

  component reg4bits is
	 port (clock, reset : in  std_logic;
	       PE           : in  std_logic;
	 		 P            : in  std_logic_vector(3 downto 0);
			 Q            : out std_logic_vector(3 downto 0)
		   );
  end component;
  
  component reg8bits is
	 port (clock, reset : in  std_logic;
	       PE           : in  std_logic;
			 P            : in  std_logic_vector(7 downto 0);
			 Q            : out std_logic_vector(7 downto 0)
		   );
  end component;
  
  component operationReg is
	 port (clock : in  std_logic;
	       PE    : in  std_logic;
 			 P     : in  std_logic_vector(1 downto 0);
			 Q     : out std_logic_vector(1 downto 0)
		   );
  end component;
  
begin
	
  -- Efetuar sign-extend em "operand"
  s_operand8bits <= std_logic_vector(resize(signed(operand), s_operand8bits'length));
  
  -- Tratamento da entrada paralela de REG1. Deve-se decidir entre 
  -- "s_operand8bits", entrada escrita pelo usuario com sign-extend, 
  --  ou "s_previousResult", isto é, o resultado anterior
  s_P1 <= s_operand8bits when s_reg3ToReg1 = '0' else 
          s_Q3; 
		 
  -- Tratamento da entrada paralela de OPREG1. Deve-se decidir entre
  -- "s_opQ2", saida de OPREG2, e "opCode"
  s_opP1 <= opCode when s_op2toOp1 = '0' else
            s_opQ2; 
		   
  -- Instanciacao de CTRLU, unidade de controle
  CTRLU : controlUnit port map (clock, reset, 
                                storeInput, storeOperation, calculate,
										  s_clear, s_pI1, s_pI2, s_pI3, s_sOp1, s_sOp2,
										  s_reg3toReg1, s_op2toOp1, s_showFinalResult,
										  db_Q);
										 
  -- Instanciacao de ALU1, a ULA 
  ALU1 : alu port map (s_Q1, s_Q2, s_opQ1, s_resultALU, s_remainderALU, overflow, s_div0Aux); 
   
  -- Instanciacao de REG1, que guarda o primeiro operando inserido pelo usuario
  REG1 : reg8bits port map (clock, s_clear, s_pI1, s_P1, s_Q1);
  
  -- Instanciacao de REG2, que guarda o segundo (ou sucessivo) operando, inserido pelo usuario
  REG2 : reg4bits port map (clock, s_clear, s_pI2, operand, s_Q2); 
  
  -- Instanciacao de REG3, que guarda o resultado (intermediario ou final)
  REG3 : reg8bits port map (clock, s_clear, s_pI3, s_resultALU, s_Q3);
  
  -- Instanciacao de REG4, que guarda o resto de uma possivel divisao 
  REG4 : reg8bits port map (clock, s_clear, s_pI3, s_remainderALU, s_Q4);
  
  -- Instanciacao de OPREG1, que guarda a primeira operacao inserida pelo usuario
  OPREG1 : operationReg port map (clock, s_sOp1, s_opP1, s_opQ1);
   
  -- Instanciacao de OPREG2, que guarda a segunda (ou sucessiva) operacao inserida pelo usuario
  OPREG2 : operationReg port map (clock, s_sOp2, opCode, s_opQ2);
  
  Q1 <= s_Q1;
  Q2 <= s_Q2;
  
   -- Tratamento da saida "result"
  result <= s_Q3 when s_showFinalResult = '1' else
            "00000000";
  
  -- Tratamento da saida "remainder"
  s_showRem <= s_reg3toReg1 or s_op2toOp1 or s_showFinalResult;
  remainder <= s_Q4 when s_showRem = '1' else
               "00000000";
		
  -- Tratamento da saida "div0." Ela somente devera ser ativada apos uma divisao. Coincidentemente, os
  -- estados que representam isso sao os mesmos na obtencao de s_showRem.
  div0 <= s_div0Aux when s_showRem = '1' else 
          '0';
			 
  -- Sinais de depuracao
  db_remainderALU <= s_remainderALU;  
  db_resultALU <= s_resultALU;
  db_opCode <= s_opQ1;

end calculatorArch;