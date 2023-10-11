library IEEE;
use IEEE.std_logic_1164.all;
entity decoder4x16 is
    port(a, b, c, d, enable: in std_logic;
    dec: out std_logic_vector(15 downto 0));
end entity;
architecture behavior of decoder4x16 is
    signal X:std_logic_vector(3 downto 0);
    signal Z:std_logic_vector(3 downto 0);
    signal W:std_logic_vector(3 downto 0);
    signal T:std_logic_vector(3 downto 0);
    signal M:std_logic_vector(3 downto 0);
    component decoder2x4 is
        port(I: in std_logic_vector (1 downto 0);
        enable : in std_logic;
        Y: out std_logic_vector(3 downto 0)
        );
    end component;
    begin
        U1:decoder2x4 port map(I(0)=>a,I(1)=>b,enable=>enable,Y=>X);
        U2:decoder2x4 port map(I(0)=>c,I(1)=>d,enable=>X(0),Y=>Z);
        U3:decoder2x4 port map(I(0)=>c,I(1)=>d,enable=>X(1),Y=>W);
        U4:decoder2x4 port map(I(0)=>c,I(1)=>d,enable=>X(2),Y=>T);
        U5:decoder2x4 port map(I(0)=>c,I(1)=>d,enable=>X(3),Y=>M);
        dec<=Z&W&T&M;
end architecture;