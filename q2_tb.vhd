library IEEE;
use IEEE.std_logic_1164.all;
entity decoder4x16_tb is
end entity;

architecture testbench of decoder4x16_tb is
    signal a_tb, b_tb, c_tb, d_tb, enable: std_logic;
    signal dec_tb: std_logic_vector(15 downto 0);
    
    component decoder4x16 is
        port (
            a, b, c, d, enable: in std_logic;
            dec: out std_logic_vector(15 downto 0)
        );
    end component;

begin
    uut : decoder4x16 port map(a_tb, b_tb, c_tb, d_tb, enable, dec_tb);
    
    stimulus_proc: process
    begin
        enable <= '1';
       
        -- Combination 0000
        a_tb <= '0';
        b_tb <= '0';
        c_tb <= '0';
        d_tb <= '0';
        wait for 10 ns;
        
        -- Combination 0001
        a_tb <= '0';
        b_tb <= '0';
        c_tb <= '0';
        d_tb <= '1';
        wait for 10 ns;

        -- Combination 0010
        a_tb <= '0';
        b_tb <= '0';
        c_tb <= '1';
        d_tb <= '0';
        wait for 10 ns;

        -- Combination 0011
        a_tb <= '0';
        b_tb <= '0';
        c_tb <= '1';
        d_tb <= '1';
        wait for 10 ns;

        -- Combination 0100
        a_tb <= '0';
        b_tb <= '1';
        c_tb <= '0';
        d_tb <= '0';
        wait for 10 ns;

        -- Combination 0101
        a_tb <= '0';
        b_tb <= '1';
        c_tb <= '0';
        d_tb <= '1';
        wait for 10 ns;

        -- Combination 0110
        a_tb <= '0';
        b_tb <= '1';
        c_tb <= '1';
        d_tb <= '0';
        wait for 10 ns;

        -- Combination 0111
        a_tb <= '0';
        b_tb <= '1';
        c_tb <= '1';
        d_tb <= '1';
        wait for 10 ns;

        -- Combination 1000
        a_tb <= '1';
        b_tb <= '0';
        c_tb <= '0';
        d_tb <= '0';
        wait for 10 ns;

        -- Combination 1001
        a_tb <= '1';
        b_tb <= '0';
        c_tb <= '0';
        d_tb <= '1';
        wait for 10 ns;

        -- Combination 1010
        a_tb <= '1';
        b_tb <= '0';
        c_tb <= '1';
        d_tb <= '0';
        wait for 10 ns;

        -- Combination 1011
        a_tb <= '1';
        b_tb <= '0';
        c_tb <= '1';
        d_tb <= '1';
        wait for 10 ns;

        -- Combination 1100
        a_tb <= '1';
        b_tb <= '1';
        c_tb <= '0';
        d_tb <= '0';
        wait for 10 ns;

        -- Combination 1101
        a_tb <= '1';
        b_tb <= '1';
        c_tb <= '0';
        d_tb <= '1';
        wait for 10 ns;

        -- Combination 1110
        a_tb <= '1';
        b_tb <= '1';
        c_tb <= '1';
        d_tb <= '0';
        wait for 10 ns;

        -- Combination 1111
        a_tb <= '1';
        b_tb <= '1';
        c_tb <= '1';
        d_tb <= '1';
        wait for 10 ns;

        end process;

end testbench;
