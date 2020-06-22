library IEEE;
use IEEE.std_logic_1164.all;

--======================================
-- Declaracao da entity controlUnit
-- Unidade de controle da calculadora
-- Entradas:
--   * clock, reset
--   * storeInput: promove o carregamento do operando nos registradores adequados
--   * storeOperation: promove o carregamento do codigo da operação nos registradores adequados
--   * calculate: calcular resultado final
-- Saidas:
--   * clear: limpa os registradores de operandos e de resultados
--   * parallelInput1, parallelInput2, parallelInput3: carregam entradas paralelas nos registradores 
--                                                     de operando (REG1 e REG2) e de resultado e 
--                                                     resto (REG3 e REG4)
--   * storeOp1, storeOp2: carrega entradas paralelas nos registradores de operação (opReg1 e opReg2)
--   * reg3toReg1: a entrada paralela do reg1 passa a ser os 4 bits menos significativos da saida 
--   * op2toOp1: a entrada paralela do opReg1 passa a ser a saida de opReg2
--   * showFinalResult: promove a exibicao do resultado final ao usuario
--   * db_Q: sinal de depuracao. Palavra de 4 bits que representa o estado atual
--======================================
entity controlUnit is
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
end controlUnit;

--======================================
-- Declaracao da arquitetura de controlUnit
--======================================
architecture controlUnitArch of controlUnit is
  type StateType is (initial, clearRegs, 
                     storeInput1,
							storeOperation1,
                     storeInput2,
							storeOperation2,
					      storeIntermediateResult, overwriteReg1,
					      overwriteOpReg, storeFinalResult,
							standBy
                    );
  
  signal eCurr, eNext : StateType;
  signal s_clearRegs : std_logic := '0';
  
begin
  -- Passe para o proximo estado
  process (reset, clock)
  begin
    if reset = '1' then
      eCurr <= initial;
    elsif clock'event and clock = '1' then
      eCurr <= eNext;
    end if;
  end process;

  -- Parsing que determina o estado seguinte
  process (storeInput, storeOperation, calculate)
  begin
    case eCurr is
      when initial => 
		  eNext <= clearRegs;
      
		when clearRegs => 
		  if storeInput = '1' then
		    eNext <= storeInput1;
		  else
		    eNext <= clearRegs;
		  end if;
		  
      when storeInput1 => 
		  if storeOperation = '1' then
		    eNext <= storeOperation1;
		  else 
			 eNext <= storeInput1;
		  end if;
		
		when storeOperation1 =>
		  if storeInput = '1' then
		    eNext <= storeInput2;
		  else 
			 eNext <= storeOperation1;
		  end if;
		
		when storeInput2 => 
		  if storeOperation = '1' then
		    eNext <= storeOperation2;
		  elsif calculate = '1' then
		    eNext <= storeFinalResult;
		  else
		    eNext <= storeInput2;
		  end if;
		
		when storeOperation2 =>
		  eNext <= storeIntermediateResult;
		
		when storeIntermediateResult =>
		  eNext <= overwriteReg1;
		
		when overwriteReg1 =>
		  eNext <= overwriteOpReg;
		  
		when overwriteOpReg =>
		  if storeInput = '1' then
		    eNext <= storeInput2;
	     else 
		    eNext <= overwriteOpReg;
		  end if;
			
		when storeFinalResult =>
		  eNext <= standBy;
		  
		when standBy =>
		  eNext <= standBy;
		
		when others => eNext <= initial;
		
		end case;
  end process;
	   	
  -- Saidas
  with eCurr select db_Q <=
    "0000" when initial,
	 "0001" when clearRegs,
	 "0010" when storeInput1,
	 "0011" when storeOperation1,
	 "0100" when storeInput2,
	 "0101" when storeOperation2,
	 "0110" when storeIntermediateResult,
	 "0111" when overwriteReg1,
	 "1000" when overwriteOpReg,
	 "1001" when storeFinalResult,
	 "1010" when standBy,
	 "1111" when others;
	 
  clear <= '1' when eCurr = clearRegs else '0';

  parallelInput1 <= '1' when eCurr = storeInput1 or eCurr = overwriteReg1 else '0';
  parallelInput2 <= '1' when eCurr = storeInput2 else '0';
  parallelInput3 <= '1' when eCurr = storeIntermediateResult or eCurr = storeFinalResult else '0';
  
  storeOp1 <= '1' when eCurr = storeOperation1 or 
                       eCurr = overwriteOpReg else '0';
  storeOp2 <= '1' when eCurr = storeOperation2 else '0';
  
  
  reg3toReg1 <= '1' when eCurr = overwriteReg1 else '0';
  op2toOp1 <= '1' when eCurr = overwriteOpReg else '0';
  
  showFinalResult <= '1' when eCurr = standBy else '0';
  
end controlUnitArch;