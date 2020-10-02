LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

entity Assignment9 is

port( C : in std_logic;
		rx_in : in std_logic;
		LED : out std_logic_vector(7 downto 0);
		reset : in std_logic;
		tx_out : out std_logic :='1'
		); 

end Assignment9;

architecture Behavioral of Assignment9 is
signal tx:std_logic_vector(9 downto 0);
signal count: integer range 0 to 7;
signal count_16: integer range 0 to 16;
signal count_10: integer range 0 to 10;
signal tmp: integer range 0 to 7;
signal count16 : integer range 0 to 15;
signal rx_reg : std_logic_vector(7 downto 0);
signal transmit : std_logic;
signal tx_start : std_logic;
signal m : integer range 0 to 651;
  type txstate_type is(idle,start,s0,s1,s2,s3,s4,s5,s6,s7);
signal state_tx : txstate_type;
TYPE State_type IS (idle,start,stop); 
 -- Define the states
	SIGNAL state : State_Type;  
 --- count is the variable counting 8 cosecutive 0
 --- count16 is the variable counting 16 cycles of rx_clk
 --- tmp is the variable counting number of input bits taken
begin


 process(C)
    begin
    if(C'event and C='1') then
           m <= m + 1;
              if(m=651) then
              m <=0;
              end if;
    end if;
    end process;
-- receiver
	process (C)
	begin
	if (C'event and C='1') then
	if (reset='1') then
	--tx <= "1111111111";
	--tx_out <= '1';
	state <= idle;
	count <=0;
	count16<=0;
	tmp<=0;
	
	else
	if( m=650) then
	case state is
		when idle =>
		
			if(rx_in='0') then
				if( count = 7) then
					--tx <= tx(8 downto 0)&"0";
					--tx_out <= '0';
					
					state <= start;
					count16<=0;
					count <= 0;
				else
				    count <= count+1;
				end if;
			else
			count <=0;
			end if;
		when start =>
			if(tmp=1) then
			tx_start<='0';
			end if;
			if( count16 = 15) then 
			tmp <= tmp +1;
			count16 <= 0;
			rx_reg <= rx_reg(6 downto 0)&rx_in;
			--tx <= tx(8 downto 0)&rx_in;
			--tx_out <= rx_in;
			
				if(tmp=7) then
				    
				    tx <= "0"&rx_reg(6 downto 0)&rx_in&"1";
					state <= stop;
					count16 <= 0;
					count <= 0;
				end if;
			else
			count16 <= count16 +1;
			end if;
		when stop => 
		    
			count16 <= count16+1;
			if( count16 = 15) then
			--tx <= tx(8 downto 0)&"1";
			--tx_out <='1';
			tx_start<='1';
			 state <= idle;
			 count <= 0;
			 
			end if;
	
	end case;
	end if;	
	end if;
	end if;
   end process;
	
--	process(C)
--	begin
--	if(tx_start='1') then
--	transmit<='1';
--	end if;
	
	
--	if(transmit ='1') then
--	if( m=650) then
--	   count_16 <= count_16+1;
--	   if(count_16=15) then
--	   tx_out <=tx(9-count_10);
--	   count_10 <= count_10+1;
--	   --tx<= tx(8 downto 0)&"1";
--	       if(count_10=8) then 
--	       transmit<='0';
--	       count_10<=0;
--	       count_16<=0;
	   
--	   end if;
--	   end if;
--	   end if;
--	   else
--	   tx_out <='1';
--	   end if;
--	end process;

process(C)
begin
if (C'event and C='1') then
if( m=650) then
count_16<=count_16+1;
if(count_16=15) then 
count_16<=0;
case state_tx is
          when idle =>
          if(tx_start='1') then
            state_tx <= start;
				tx_out <= tx(9);
          else
            state_tx <= idle;
				tx_out <= '1';
          end if;
          when start =>
			 tx_out <= tx(8);
          state_tx <= s0;
          when s0 =>
          state_tx <= s1;
	  tx_out <= tx(7);
          when s1 =>
          state_tx <= s2;
	  tx_out <= tx(6);
          when s2 =>
          state_tx <= s3;
	  tx_out <= tx(5);
          when s3 =>
          state_tx <= s4;
	  tx_out <= tx(4);
          when s4 =>
          state_tx <= s5;
	  tx_out <= tx(3);
          when s5 =>
          state_tx <= s6;
	  tx_out <= tx(2);
          when s6 =>
          state_tx <= s7;
	  tx_out <= tx(1);
          when s7 =>
          state_tx <= idle;
	  tx_out <= '1';
        end case;
        end if;
end if;
 end if;
    end process;








-------- transmitter ----
LED <= tx(8 downto 1);
--tx_out<=tx(9);
	
end Behavioral;