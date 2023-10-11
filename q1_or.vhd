library IEEE;
use IEEE.std_logic_1164.all;

entity OR_Gate is
    port(x1: in std_logic;
    x2: in std_logic;
    y: out std_logic);
end entity;

architecture behaviour of OR_Gate is
begin
    y <= x1 OR x2;
end architecture;
