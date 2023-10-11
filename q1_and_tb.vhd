library IEEE;
use IEEE.std_logic_1164.all;

entity AND_Gate_Testbench is
end entity;

architecture testbench of AND_Gate_Testbench is
    signal x1_tb, x2_tb, y_tb : std_logic;
    component AND_Gate
        port (
            x1: in std_logic;
            x2: in std_logic;
            y: out std_logic
        );
    end component;
begin
    uut: AND_Gate port map (x1_tb, x2_tb, y_tb);

    -- Stimulus process
    stimulus_proc: process
    begin
        x1_tb <= '0'; -- Set input x1 to 0
        x2_tb <= '0'; -- Set input x2 to 0
        wait for 4 ns;
        
        x1_tb <= '0'; -- Set input x1 to 0
        x2_tb <= '1'; -- Set input x2 to 1
        wait for 4 ns;

        x1_tb <= '1'; -- Set input x1 to 1
        x2_tb <= '0'; -- Set input x2 to 0
        wait for 4 ns;

        x1_tb <= '1'; -- Set input x1 to 1
        x2_tb <= '1'; -- Set input x2 to 1
        wait for 4 ns;

        -- End simulation
        wait;
    end process;
end architecture;
