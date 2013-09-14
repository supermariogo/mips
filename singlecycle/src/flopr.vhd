library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;

entity flopr is -- flip-flop with synchronous reset
generic (width: integer);
port (clk, reset: in STD_LOGIC;
      d:          in STD_LOGIC_VECTOR(width-1 downto 0);
      q:          out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture asynchronous of flopr is

begin
   asy: process (clk, reset)
   begin
   if reset = '1' then 
      q <= CONV_STD_LOGIC_VECTOR(0, width);
   elsif clk'event and clk = '1' then
      q <= d;
   end if;
   end process asy;
end;
