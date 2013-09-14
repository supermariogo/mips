library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity adder is
    port(a, b :       in  std_logic_vector(31 downto 0);
         y:           out std_logic_vector(31 downto 0));
end;

architecture behave of adder is
begin 
    y<=a+b;
end;
