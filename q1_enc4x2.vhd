library IEEE;
use IEEE.std_logic_1164.all;
entity encoder4x2 is
    port(I: in std_logic_vector (3 downto 0);
    Y: out std_logic_vector(1 downto 0));
end entity;
architecture behavior of encoder4x2 is
    component OR_Gate is
        port (
            x1: in std_logic;
            x2: in std_logic;
            y: out std_logic
        );
    end component;
    begin
        U1:OR_Gate port map (I(3),I(1),Y(0));
        U2:OR_Gate port map (I(3),I(2),Y(1));
end architecture;