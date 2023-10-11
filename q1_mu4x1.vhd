library IEEE;
use IEEE.std_logic_1164.all;

entity mux4x1 is
    port (
        D: in std_logic_vector(3 downto 0);
        S: in std_logic_vector(1 downto 0);
        Y: out std_logic
    );
end entity; 

architecture behavior of mux4x1 is
    signal temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9, temp10, temp11, temp12: std_logic;
     component OR_Gate is
        port (
            x1: in std_logic;
            x2: in std_logic;
            y: out std_logic
        );
    end component;

    component AND_Gate is
        port (
            x1: in std_logic;
            x2: in std_logic;
            y: out std_logic
        );
    end component;

    component NOT_Gate is
        port (
            x: in std_logic;
            y: out std_logic
        );
    end component;

begin    
    U1: NOT_Gate port map(S(0), temp1);
    U2: NOT_Gate port map(S(1), temp2);
    U3: AND_Gate port map(S(0), S(1), temp3);
    U4: AND_Gate port map(temp3, D(3), temp4);
    U5: AND_Gate port map(temp1, S(1), temp5);
    U6: AND_Gate port map(temp5, D(2), temp6);
    U7: AND_Gate port map(temp2, S(0), temp7);
    U8: AND_Gate port map(temp7, D(1), temp8);
    U9: AND_Gate port map(temp1, temp2, temp9);
    U10: AND_Gate port map(temp9, D(0), temp10);
    U11: OR_Gate port map(temp4, temp6, temp11);
    U12: OR_Gate port map(temp11, temp8, temp12);
    U13: OR_Gate port map(temp12, temp10, Y);
end architecture;
