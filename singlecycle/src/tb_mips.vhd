library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library work;
use work.pkg.all;

entity tb_mips is 
end;

architecture test of tb_mips is 
component mips
	port (clk, reset: in STD_LOGIC;
         pc: out STD_LOGIC_VECTOR (31 downto 0);
         instr: in STD_LOGIC_VECTOR (31 downto 0);
         memwrite: out STD_LOGIC;
         aluout, writedata: out STD_LOGIC_VECTOR (31 downto 0);
         readdata: in STD_LOGIC_VECTOR (31 downto 0));
end component;

shared variable end_sim : BOOLEAN ;
signal clk, reset: STD_LOGIC;
signal pc: STD_LOGIC_VECTOR (31 downto 0);
signal instr: STD_LOGIC_VECTOR (31 downto 0);
signal memwrite: STD_LOGIC;
signal aluout, writedata: STD_LOGIC_VECTOR (31 downto 0);
signal readdata: STD_LOGIC_VECTOR (31 downto 0);
begin
dut : mips port map(clk,reset,pc,instr,memwrite,aluout,writedata,readdata);
--generate clock with 10 ns period
clk_in: process begin
	if end_sim=false then 
		clk <= '0';
		wait for 5 ns;
		clk <= '1';
		wait for 5 ns;
	else
		wait;
	end if;
end process;

stimulus: process begin
    readdata<="001000"&"00000"&"00010"&"0000000000000010";
	instr<="001000"&"00000"&"00010"&"0000000000000010"; --addi    rt2=rs0+2
	reset<='0';
	wait for 10 ns;
    reset<='1';
	wait for 10 ns;
	reset<='0';
	instr<="001000"&"00000"&"00010"&"0000000000000010"; --addi    rt2=rs0+2
	wait for 10 ns;
	instr<="001000"&"00000"&"00001"&"0000000000000001"; -- addi   rt1=rs0+1
	wait for 10 ns;
	instr<="000000"&"00010"&"00001"&"00011"&"00000"&"100000";-- add  rd3=rs2+rt1
	wait for 10 ns;-- change funct code to verify other R types
	instr<="000000"&"00010"&"00011"&"00001"&"00000"&"100000";-- add  rd1=rs2+rt3
	wait for 10 ns;
	instr<="00001000000000000000000000000010";-- jump + b10<<2
	wait for 10 ns;
	end_sim := true;
	wait;
end process;

fsdb : process begin
	fsdbDumpfile("tb_mips.fsdb");
	fsdbDumpvars(0, "tb_mips");
	wait;
end process;

end;

