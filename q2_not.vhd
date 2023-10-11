library IEEE;
use IEEE.std_logic_1164.all;
entity NOT_Gate is
    port(x: in std_logic;
    y: out std_logic);
end entity;
architecture behaviour of NOT_Gate is
begin
    y <= not x;
end architecture;
