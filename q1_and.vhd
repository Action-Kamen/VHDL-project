library IEEE;
use IEEE.std_logic_1164.all;

entity AND_Gate is
    port (
        x1: in std_logic;
        x2: in std_logic;
        y: out std_logic
    );
end entity;

architecture behaviour of AND_Gate is
begin
    y <= x1 and x2;
end architecture;
