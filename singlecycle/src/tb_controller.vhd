library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
library work;
use work.pkg.all;

entity tb_controller is
end;

architecture test of tb_controller is
-- component 
   component controller
      port (op, funct: in STD_LOGIC_VECTOR (5 downto 0);
      zero: in STD_LOGIC;
      memtoreg, memwrite: out STD_LOGIC;
      pcsrc, alusrc: out STD_LOGIC;
      regdst, regwrite: out STD_LOGIC;
      jump: out STD_LOGIC;
      alucontrol: out STD_LOGIC_VECTOR (2 downto 0));
   end component;

-- test signal
signal op, funct:  STD_LOGIC_VECTOR (5 downto 0);
signal zero:  STD_LOGIC;
signal memtoreg, memwrite:  STD_LOGIC;
signal pcsrc, alusrc:   STD_LOGIC;
signal regdst, regwrite:   STD_LOGIC;
signal jump:   STD_LOGIC;
signal alucontrol:   STD_LOGIC_VECTOR (2 downto 0);
      
begin
-- instantiate device to be tested
dut: controller port map (op,funct,zero,memtoreg,memwrite,pcsrc,alusrc,regdst,regwrite,jump,alucontrol);

process begin
wait for 10 ns;
op <= "000000";  -- R type : aluop=1X
funct <= "100000";  -- add
wait for 10 ns;
op <= "000000";  -- R type : aluop=1X
funct <= "100010";  -- sub
wait for 10 ns;
op <= "000000";  -- R type : aluop=1X
funct <= "100100";  -- and
wait for 10 ns;
op <= "000000";  -- R type : aluop=1X
funct <= "100101";  -- or
wait for 10 ns;
op <= "000000";  -- R type : aluop=1X
funct <= "101010";  -- set less than
wait for 10 ns;
op <= "000000";  -- R type : aluop=1X
funct <= "111111";  -- others
wait for 10 ns;
op <= "101011";   --sw
funct <= "111111";  --add
wait for 10 ns;
op <= "100011";   --lw
funct <= "111111";  --add
wait for 10 ns;
op <= "000100";   --beq;
funct <= "111111";  --any
zero <= '0';
   
  
wait for 10 ns;
op <= "001000";   --addi;   alucontrol add
funct <= "111111";  --
zero <= '0';
 
wait for 10 ns;
op <= "000010";   --J;--add
funct <= "111111";  
zero <= '0';
  

wait for 10 ns;
wait;
end process;

process
begin
     fsdbDumpfile("tb_controller.fsdb");
     fsdbDumpvars(0, "tb_controller");
wait;
end process;


end;

