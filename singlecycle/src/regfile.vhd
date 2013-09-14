library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity regfile is  -- 3 port register file
   port(clk:            in std_logic;
        we3:            in std_logic;
        ra1, ra2, wa3:  in std_logic_vector(4 downto 0);
        wd3:            in std_logic_vector(31 downto 0);
        rd1, rd2:       out std_logic_vector(31 downto 0));
end;

architecture behave of regfile is
    type ramtype is array(31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem: ramtype;
    
begin
    --three ported reg file
    --read two port combinationally
    --write third port on rising edge of clock
    process(clk) begin
       if clk'event and clk='1' then
          if we3='1' then mem(CONV_INTEGER(wa3))<=wd3;
          end if;
       end if;
    end process;
    
    
    process(ra1, ra2) begin
        if(conv_integer(ra1)=0) then rd1<=X"00000000";--reg 0 holds 0
        else rd1 <= mem(CONV_INTEGER (ra1));-- but mem 0 is high impedance 
        end if;
        
        if (conv_integer(ra2)=0) then rd2<=X"00000000";
        else rd2 <= mem(CONV_INTEGER(ra2));
        end if;
end process;
end;
        
     
