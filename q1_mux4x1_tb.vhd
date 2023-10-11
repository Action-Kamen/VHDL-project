library IEEE;
use IEEE.std_logic_1164.all;

entity mux4x1_testbench is
end entity;

architecture testbench of mux4x1_testbench is
    signal D_tb:std_logic_vector (3 downto 0);
    signal S_tb:std_logic_vector(1 downto 0);
    signal Y_tb:std_logic;
    
    component mux4x1 is
        port (
            D: in std_logic_vector (3 downto 0);
            S: in std_logic_vector(1 downto 0);
            Y: out std_logic
        );
    end component;

begin
    mux4x1_inst: mux4x1 port map(
            D_tb,
            S_tb,
            Y_tb
        );
    stimulus_proc: process

    begin
        
        
        -- Initialize test vectors
        D_tb <= "1010";
        S_tb <= "00";

        -- Apply different test cases

        wait for 10 ns;
        D_tb <= "1010";
        S_tb <= "01";

        wait for 10 ns;
        D_tb <= "1010";
        S_tb <= "10";

        wait for 10 ns;
        D_tb <= "1010";
        S_tb <= "11";

        wait;
    end process;

end testbench;
