library IEEE;
use IEEE.std_logic_1164.all;
entity decoder2x4 is
    port(I: in std_logic_vector (1 downto 0);
    enable : in std_logic;
    Y: out std_logic_vector(3 downto 0)
    );

end entity;
architecture behavior of decoder2x4 is
    signal noti0,noti1,noti0i1,i1noti0,i0noti1,i0i1:std_logic;
    component AND_Gate is
        port (
            x1: in std_logic;
            x2: in std_logic;
            y: out std_logic
        );
    end component;
    component NOT_Gate is
        port(x: in std_logic;
        y: out std_logic);
    end component;
    begin
        U1:NOT_Gate port map(I(0),noti0);
        U2:NOT_Gate port map(I(1),noti1);

        U3:AND_Gate port map(noti0,noti1,noti0i1);
        U7:AND_Gate port map(noti0i1,enable,Y(0));

        U4:AND_Gate port map(noti0,I(1),i1noti0);
        U8:AND_Gate port map(i1noti0,enable,Y(1));

        U5:AND_Gate port map(I(0),noti1,i0noti1);
        U9:AND_Gate port map(i0noti1,enable,Y(2));

        U6:AND_Gate port map(I(0),I(1),i0i1);
        U10:AND_Gate port map(i0i1,enable,Y(3));
end architecture;