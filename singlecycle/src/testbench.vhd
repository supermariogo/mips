library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity testbench is
end;

architecture test of testbench is
   component top
      port(clk, reset: in STD_LOGIC;
      writedata, dataadr: out STD_LOGIC_VECTOR(31 downto 0);
      memwrite: out STD_LOGIC);
   end component;

signal writedata, dataadr: STD_LOGIC_VECTOR(31 downto 0);
signal clk, reset, memwrite: STD_LOGIC;
begin
-- instantiate device to be tested
dut: top port map (clk, reset, writedata, dataadr, memwrite);

-- Generate clock with 10 ns period
process begin
clk <= '1';
wait for 5 ns;
clk <= '0';
wait for 5 ns;
end process;

-- Generate reset for first two clock cycles
process begin
reset <= '1';
wait for 22 ns;
reset <= '0';
wait;
end process;

-- check that 7 gets written to address 84 at end of program
process (clk) begin
   if (clk'event and clk = '0' and memwrite = '1') then
      if (conv_integer(dataadr) = 84 and conv_integer(writedata) = 7) then
         report "Simulation succeeded";
      elsif (dataadr /= 80) then
         report "Simulation failed";
      end if;
   end if;
end process;
end;
