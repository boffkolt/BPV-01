
-----------------------------------------------------------------------------------
-- ШАБЛОН ТЕСТБЕНЧА VHDL 
------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
--use work.my_types.all;


entity shift_seg_tb is
end shift_seg_tb ;

		
architecture RTL_shift_seg_tb of shift_seg_tb is
component shift_seg
	--generic
	--(
		--GENERICN : integer range 1 to 32 := 2;
		
	--);
	port( 
		in_std_clk : in std_logic;
		out_std_clk : out std_logic;
		out_std_clk_inv: out std_logic;
		out_std_dout:out std_logic;
		in_std16_data: in std_logic_vector(15 downto 0));
end component;

for label_0: shift_seg use entity work.shift_seg ;

signal in_std_clk: std_logic := '1';
signal out_std_clk: std_logic := '0';
signal out_std_clk_inv: std_logic := '0';
signal out_std_dout: std_logic := '0';
signal in_std16_data: std_logic_vector(15 downto 0):=X"8001";

begin
label_0: shift_seg port map (in_std_clk => in_std_clk , out_std_clk=> out_std_clk,out_std_clk_inv=>out_std_clk_inv,out_std_dout=>out_std_dout, in_std16_data=>in_std16_data);



-----------------------------------------------------------------------------------
-- ПРОЦЕСС ТАКТИРОВАНИЯ
------------------------------------------------------------------------------------


CLK: process
begin

       in_std_clk <= not(in_std_clk);
       
       wait for 10 ns;
   
end process;

-----------------------------------------------------------------------------------
-- ПРОЦЕСС АСИНХРОННЫЙ СБРОС
------------------------------------------------------------------------------------


ENA: process
begin

       wait for 35 ms;
	  in_std16_data <= X"A55A";
       

end process;
-----------------------------------------------------------------------------------
-- ПРОЦЕСС ОСТАНОВКИ СИМУЛЯЦИИ
------------------------------------------------------------------------------------

STOP: process
begin
	assert false
		report "simulation started"
		severity warning;
	wait for 100 ms; --run the simulation for this duration
	assert false
		report "simulation ended"
		severity failure;
end process ;

end RTL_shift_seg_tb;	
