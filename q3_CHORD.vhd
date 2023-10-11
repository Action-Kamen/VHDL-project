library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CHORDEncoder is
    port (
        clk, rst: in std_logic;
        a: in std_logic_vector(7 downto 0);
        data_valid: out std_logic;
        z: out std_logic_vector(7 downto 0)
    );
end entity CHORDEncoder;

architecture Behavioral of CHORDEncoder is
    constant ARRAY_SIZE: integer := 32;  -- my buffer size is 32
    type InputArray_Type is array (0 to ARRAY_SIZE - 1) of integer;--arraytype
    type triadarray is array (0 to 2) of integer;--checking in groups of 3
    type Outputarray is array (0 to 31) of std_logic_vector(7 downto 0);--outputarray every clk cycle goes to z
    function integer_converter( --given ascii in input gives a number mapped to it mapping starts from A
        i : std_logic_vector(7 downto 0)
    ) return integer is
        variable f : integer;
    begin
        if i = "01000001" then f := 0;  -- A_65
        elsif i = "01000010" then f := 2;  -- B_66
        elsif i = "01000011" then f := 3;  -- C_67
        elsif i = "01000100" then f := 5;  -- D_68
        elsif i = "01000101" then f := 7;  -- E_69
        elsif i = "01000110" then f := 8;  -- F_70
        elsif i = "01000111" then f := 10; -- G_71
        elsif i = "01100001" then f := 11; -- a_97
        elsif i = "01100010" then f := 1;  -- b_98
        elsif i = "01100011" then f := 2;  -- c_99
        elsif i = "01100100" then f := 4;  -- d_100
        elsif i = "01100101" then f := 6;  -- e_101
        elsif i = "01100110" then f := 7;  -- f_102
        elsif i = "01100111" then f := 9;  -- g_103
        elsif i = "00011111" then f := 69; -- "00011111" --hash
        else
            f := -1; -- Handle invalid input
        end if;
        return f;
    end function;

    function chord_converter(--when checked it outputs char corresponding to number mapped
        f : integer
    ) return unsigned is
        variable i : unsigned(7 downto 0);
    begin
        case f is
            when 0 => i := "01000001";  -- A_65
            when 2 => i := "01000010";  -- B_66
            when 3 => i := "01000011";  -- C_67
            when 5 => i := "01000100";  -- D_68
            when 7 => i := "01000101";  -- E_69
            when 8 => i := "01000110";  -- F_70
            when 10 => i := "01000111"; -- G_71
            when 11 => i := "01100001"; -- a_97
            when 1 => i := "01100010";  -- b_98
            when 4 => i := "01100100";  -- b_100
            when 6 => i := "01100101";  -- e_101
            when 9 => i := "01100111";  -- g_103
            when others => i := "00000000"; -- Handle invalid input
        end case;
        return i;
    end function;

    function chord_checker( --returns major,minor,suspended,nochord
        T : triadarray
    ) return unsigned is
        variable ch : unsigned(7 downto 0);
    begin
        if ((T(1) = (T(0) + 4) mod 12) and (T(2) = (T(1) + 3) mod 12)) then --major
            ch := "01001101";
        elsif ((T(1) = (T(0) + 3) mod 12) and (T(2) = (T(1) + 4) mod 12)) then --minor
            ch := "01101101";
        elsif ((T(1) = (T(0) + 5) mod 12) and (T(2) = (T(1) + 2) mod 12)) then--suspended
            ch := "01110011";
        else
            ch := "00000000";--no chord
        end if;
        return ch;
    end function;

begin

    process(clk, rst)
        variable notearr : InputArray_Type;
        variable index : integer := 0;
        variable unfilled : integer :=0;
        variable triadindex : integer :=0;
        variable head : integer :=0;
        variable triad : triadarray;  
        variable outarr : Outputarray;
        variable outfilled : integer :=0;
        variable outindex : integer :=0;
        variable zout : integer :=0;
        variable visited : integer :=0;
    begin
        if rising_edge(clk) then
            if (rst ='0') then
                if(unfilled=0) then--fill the notearr to have enough numbers to check
                    if(integer_converter(a)=69) then--if hash present append to previous number
                        notearr(index-1):= (notearr(index-1) + 1) mod 12;
                    else    
                        notearr(index) := integer_converter(a);
                        index:=(index+1);
                    end if;
                    if (index > 4) then--if unfilled then we have to process
                        unfilled := 1;
                    end if;
                else
                triad(0) := notearr(0);--triad has elements to check
                triad(1) := notearr(1);
                triad(2) := notearr(2);
                if(chord_checker(triad)="01001101") then--major check,if major ,then check dominant7 or not
                    data_valid<='1';
                    if(notearr(3) = ((triad(2)+3) mod 12)) then--dominant7
                        outfilled:=1;
                        outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                        outarr(outindex+1) := "00110111";--if dominant7 send two numbers to outputarray
                        outindex := outindex + 2;
                        unfilled :=0;
                        index := 1;
                        notearr(0):=notearr(4);--next element to be checked is the 5th element
                        if(integer_converter(a)=69) then
                            notearr(index-1):= (notearr(index-1) + 1) mod 12;
                        else    
                            notearr(index) := integer_converter(a);
                            index:=(index+1);
                        end if;
                    else--only major not dominant7
                        outfilled:=1;
                        outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                        outarr(outindex+1) := "01001101";
                        outindex := outindex + 2;--send two ascii to output array
                        unfilled :=0;
                        index :=2; 
                        notearr(0):=notearr(3); 
                        notearr(1):=notearr(4);
                        if(integer_converter(a)=69) then
                            notearr(index-1):= (notearr(index-1) + 1) mod 12;
                        else    
                            notearr(index) := integer_converter(a);
                            index:=(index+1);
                        end if;
                    end if;
                elsif(chord_checker(triad)="01101101") then--minor 
                    data_valid<='1';
                    outfilled:=1;
                    outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                    outarr(outindex+1) := "01101101";
                    outindex := outindex + 2;
                    unfilled :=0;
                    index :=2; 
                    notearr(0):=notearr(3);
                    notearr(1):=notearr(4);
                    if(integer_converter(a)=69) then
                        notearr(index-1):= (notearr(index-1) + 1) mod 12;
                    else    
                        notearr(index) := integer_converter(a);
                        index:=(index+1);
                    end if;
                elsif(chord_checker(triad)="01110011") then--suspended chord
                    data_valid<='1';
                    outfilled:=1;
                    outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                    outarr(outindex+1) := "01110011";
                    outindex := outindex + 2;
                    unfilled :=0;
                    index :=2;
                    notearr(0):=notearr(3);
                    notearr(1):=notearr(4);
                    if(integer_converter(a)=69) then
                        notearr(index-1):= (notearr(index-1) + 1) mod 12;
                    else    
                        notearr(index) := integer_converter(a);
                        index:=(index+1);
                    end if;
                elsif(chord_checker(triad)="00000000") then --nochord ,print first element of the triad
                    data_valid<='1';
                    outfilled:=1;
                    outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                    outindex := outindex +1;
                    notearr(0) :=notearr(1);
                    notearr(1) :=notearr(2);
                    notearr(2) :=notearr(3);
                    notearr(3) :=notearr(4);
                    index:=4;
                    if(integer_converter(a)=69) then
                        notearr(index-1):= (notearr(index-1) + 1) mod 12;
                        unfilled:=0;
                    else    
                        notearr(index) := integer_converter(a);
                        index:=(index+1);
                    end if;
                end if;
                end if;
            elsif rst = '1' and visited =0 then--checking endvalues
                visited :=1;
                if(index =1) then--if lastvalue left,just print it
                    data_valid<='1';
                    outfilled:=1;
                    outarr(outindex) := std_logic_vector(chord_converter(notearr(0)));
                    outindex := outindex +1;
                elsif(index =2) then--if 2 lastvalue left,just print it
                    data_valid<='1';
                    outfilled:=1;
                    outarr(outindex) :=  std_logic_vector(chord_converter(notearr(0)));
                    outarr(outindex+1):= std_logic_vector(chord_converter(notearr(1)));
                    outindex := outindex +2;
                elsif(index=3) then--if 3lastvalue left,check if they make a chord
                    triad(0) :=notearr(0);
                    triad(1) := notearr(1);
                    triad(2) := notearr(2);
                    if(chord_checker(triad)="01001101") then--if major print 2ascii
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex) := std_logic_vector(chord_converter(notearr(0)));
                        outarr(outindex+1) :="01001101";
                        outindex := outindex +2;
                    elsif(chord_checker(triad)="01101101") then--if minor print 2ascii
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex) := std_logic_vector(chord_converter(notearr(0)));
                        outarr(outindex+1) := "01101101";
                        outindex := outindex +2;
                    elsif(chord_checker(triad)="01110011") then--if suspended print 2ascii
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                        outarr(outindex+1):= "01110011";
                        outindex := outindex +2;
                    elsif(chord_checker(triad)="00000000") then--if nochord print all 3chords
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                        outarr(outindex+1):= std_logic_vector(chord_converter(triad(1)));
                        outarr(outindex+2):= std_logic_vector(chord_converter(triad(2)));
                        outindex := outindex +3;
                    end if;
                elsif(index=4) then--if 4 at the end we have to check two triads
                    triad(0) :=notearr(0);
                    triad(1) := notearr(1);
                    triad(2) := notearr(2);
                    if(chord_checker(triad)="01001101") then--major,just print major and print last chord
                        if(notearr(3) = ((triad(2)+3) mod 12)) then
                            data_valid<='1';
                            outfilled:=1;
                            outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1):= "00110111";
                            outindex:=outindex+2;
                        else
                            data_valid<='1';
                            outfilled:=1;
                            outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1):= "01001101";
                            outarr(outindex+2):= std_logic_vector(chord_converter(notearr(3)));
                            outindex:=outindex+3;
                        end if;
                        
                    elsif(chord_checker(triad)="01101101") then--minor,just print minor and print last chord
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex):= std_logic_vector(chord_converter(notearr(0)));
                        outarr(outindex+1):= "01101101";
                        outarr(outindex+2):= std_logic_vector(chord_converter(notearr(3)));
                        outindex:=outindex+3;
                    elsif(chord_checker(triad)="01110011") then--suspended,just print suspended and print last chord
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                        outarr(outindex+1):= "01110011";
                        outarr(outindex+2):= std_logic_vector(chord_converter(notearr(3)));
                        outindex:=outindex+3;
                    elsif(chord_checker(triad)="00000000") then--if nochord then print 1stone and check last3
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                        outindex:=outindex+1;
                        triad(0) :=notearr(1);
                        triad(1) := notearr(2);
                        triad(2) := notearr(3);
                        if(chord_checker(triad)="01001101") then
                            data_valid<='1';
                            outfilled:=1;
                            outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1):="01001101";
                            outindex:=outindex+2;
                        elsif(chord_checker(triad)="01101101") then
                            data_valid<='1';
                            outfilled:=1;
                            outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1):= "01101101";
                            outindex:=outindex+2;
                        elsif(chord_checker(triad)="01110011") then
                            data_valid<='1';
                            outfilled:=1;
                            outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1):= "01110011";
                            outindex:=outindex+2;
                        elsif(chord_checker(triad)="00000000") then
                            data_valid<='1';
                            outfilled:=1;
                            outarr(outindex):= std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1):= std_logic_vector(chord_converter(triad(1)));
                            outarr(outindex+2):= std_logic_vector(chord_converter(triad(2)));
                            outindex:=outindex+3;
                        end if;
                    end if;
                elsif(index =5) then--we gotta check 3triads in the worst case
                    triad(0) :=notearr(0);
                    triad(1) := notearr(1);
                    triad(2) := notearr(2);
                    if(chord_checker(triad)="01001101") then--major chord exists,print that and print last two 
                        if(notearr(3) = ((triad(2)+3) mod 12)) then
                            data_valid<='1';
                            outfilled:=1;
                            outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1) := "00110111";
                            outarr(outindex+2) := std_logic_vector(chord_converter(notearr(4)));
                            outindex:=outindex+3;
                        else
                            data_valid<='1';
                            outfilled:=1;
                            outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1) := "01001101";
                            outarr(outindex+2) := std_logic_vector(chord_converter(notearr(3)));
                            outarr(outindex+3) := std_logic_vector(chord_converter(notearr(4)));
                            outindex:=outindex+4;
                        end if;
                        
                    elsif(chord_checker(triad)="01101101") then--minor chord exists,print that and print last two 
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex) := std_logic_vector(chord_converter(notearr(0)));
                        outarr(outindex+1) := "01101101";
                        outarr(outindex+2) := std_logic_vector(chord_converter(notearr(3)));
                        outarr(outindex+3) := std_logic_vector(chord_converter(notearr(4)));
                        outindex:=outindex+4;
                    elsif(chord_checker(triad)="01110011") then--suspended chord exists,print that and print last two 
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                        outarr(outindex+1) := "01110011";
                        outarr(outindex+2) := std_logic_vector(chord_converter(notearr(3)));
                        outarr(outindex+3) := std_logic_vector(chord_converter(notearr(4)));
                        outindex:=outindex+4;
                    elsif(chord_checker(triad)="00000000") then--no chord exists,check the next 3
                        data_valid<='1';
                        outfilled:=1;
                        outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                        outindex:=outindex+1;
                        triad(0) :=notearr(1);
                        triad(1) := notearr(2);
                        triad(2) := notearr(3);
                        if(chord_checker(triad)="01001101") then--if major chord,print that and the last one
                            if(notearr(3) = ((triad(2)+3) mod 12)) then
                                outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                                outarr(outindex+1) := "00110111";
                                outindex:=outindex+2;
                            else
                                outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                                outarr(outindex+1) := "01001101";
                                outarr(outindex+2) := std_logic_vector(chord_converter(notearr(4)));
                                outindex:=outindex+3;
                            end if;
                            
                        elsif(chord_checker(triad)="01101101") then--if minor chord,print that and the last one
                            outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1) := "01101101";
                            outarr(outindex+2) := std_logic_vector(chord_converter(notearr(4)));
                            outindex:=outindex+3;
                        elsif(chord_checker(triad)="01110011") then--if suspended chord,print that and the last one
                            outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                            outarr(outindex+1) := "01110011";
                            outarr(outindex+2) := std_logic_vector(chord_converter(notearr(4)));
                            outindex:=outindex+3;
                        elsif(chord_checker(triad)="00000000") then--if no chord found check the last 3 chords
                            outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                            outindex:=outindex+1;
                            triad(0) :=notearr(1);
                            triad(1) := notearr(2);
                            triad(2) := notearr(3);
                            if(chord_checker(triad)="01001101") then--major chord print that
                                outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                                outarr(outindex+1):="01001101";
                                outindex:=outindex+2;
                            elsif(chord_checker(triad)="01101101") then--minor chord print that
                                outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                                outarr(outindex+1) := "01101101";
                                outindex:=outindex+2;
                            elsif(chord_checker(triad)="01110011") then--suspended chord print that
                                outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                                outarr(outindex+1) := "01110011";
                                outindex:=outindex+2;
                            elsif(chord_checker(triad)="00000000") then--print all 3 chords
                                outarr(outindex) := std_logic_vector(chord_converter(triad(0)));
                                outarr(outindex+1) := std_logic_vector(chord_converter(triad(1)));
                                outarr(outindex+2) := std_logic_vector(chord_converter(triad(2)));
                                outindex:=outindex+3;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
            data_valid<= '0';
            if visited =1 and zout<outindex then--to correct the end repetition of outputs
                z<=outarr(zout);
                zout:=zout+1;
                data_valid<='1';
            elsif outfilled =1 and zout /= outindex then--send value to z in every clk cycle if condition fulls
                z<=outarr(zout);
                zout:=zout+1;
                data_valid<='1';
            else
                data_valid<='0';
            end if;
        end if;
    end process;
end Behavioral;
