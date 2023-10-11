library IEEE;
use IEEE.std_logic_1164.all;

entity en4x2_testbench is
    end entity;
architecture testbench of en4x2_testbench is
    signal I_tb:std_logic_vector (3 downto 0);
    signal Y_tb:std_logic_vector(1 downto 0);
    component encoder4x2 is
        port(I: in std_logic_vector (3 downto 0);
        Y: out std_logic_vector(1 downto 0));
        end component;
begin
    uut:encoder4x2 port map(I_tb,Y_tb);
    stimulus_proc:process
    begin
          
            I_tb<="0001";
            wait for 10 ns;
            I_tb<="0010";
            wait for 10 ns;
        
            I_tb<="0100";
            wait for 10 ns;
            I_tb<="1000";
            wait for 10 ns;
           
    end process;
end testbench;
