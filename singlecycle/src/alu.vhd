library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.std_logic_unsigned.all;

entity alu is -- alu
   port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
      alucontrol: in STD_LOGIC_VECTOR(2 downto 0);
      result: buffer STD_LOGIC_VECTOR(31 downto 0);
      zero: out STD_LOGIC);
end;

architecture behave of alu is

begin
    process(a,b,alucontrol) 
    begin
        case alucontrol is 
           when "010" => result <= a + b;
           when "110" => result <= a - b;
           when "000" => result <= a and b; 
           when "001" => result <= a or b; 
           when "111" => if a<b then result <= X"00000001";-- slt
                         else        result <= X"00000000";
                         end if; 
           when others => NULL;
        end case;
        
        if result = X"00000000" then
            zero <= '1';
        else
            zero <= '0';
        end if;

end process;
end;
            