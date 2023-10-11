library IEEE;
use IEEE.std_logic_1164.all;

entity NOT_Gate_Testbench is
end entity;

architecture testbench of NOT_Gate_Testbench is
    signal x_tb, y_tb : std_logic;
    component NOT_Gate
        port (
            x: in std_logic;
            y: out std_logic
        );
    end component;
begin
    uut: NOT_Gate port map (x_tb, y_tb);

    -- Stimulus process
    stimulus_proc: process
    begin
        x_tb <= '0'; -- Set input x to 0
        wait for 10 ns;

        x_tb <= '1'; -- Set input x to 1
        wait for 10 ns;

        x_tb <= '0'; -- Set input x to 0 (second test case)
        wait for 10 ns;

        x_tb <= '1'; -- Set input x to 1 (second test case)
        wait for 10 ns;

        -- End simulation
        wait; -- Wait indefinitely for the simulation to continue
    end process;
end architecture;
