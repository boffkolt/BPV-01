
-----------------------------------------------------------------------------------
-- ШАБЛОН ТОП ПРОЕКТА VHDL 
------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use work.my_types.all; -- 	подключение пакета


entity shift_seg is
	generic
	(
		TIME_ms : integer range 0 to 1000 := 20; --частота обновления данных	
		SYS_CLK_MHz: integer range 0 to 1000 := 50	;
		SEG_BITS : integer range 0 to 256 :=16
	);
	port
	(
		
		in_std_clk : in std_logic;
		out_std_clk : out std_logic;
		out_std_clk_inv : out std_logic;
		out_std_dout:out std_logic;
		in_std16_data: in std_logic_vector(15 downto 0)
	);
end shift_seg;

architecture RTL_shift_seg of shift_seg is

--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 								Декларирование компонента 											  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--component component_name
	--generic
	--(
		--GENERIN : integer range 0 to 32 := 16	
	--);
	--port
	--(
		--in_std : in std_logic;
		--inout_std : inout std_logic;
		--out_std : out std_logic					
	--);
--end component;
--///////////////////////////////////////////////////////////////////////////////////////////////////////////


--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 								Декларирование сигналов архитектуры									  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
constant con_int_period : integer := (SYS_CLK_MHz*TIME_ms*1000)-1;
constant con_int_check : integer := con_int_period - ((SEG_BITS-1)*2);
--
signal sig_std_clk : std_logic := '0';
signal sig_std_clk_t1: std_logic := '0';
signal sig_std_clk_inv : std_logic := '1';
signal cnt: std_logic_vector(31 downto 0) := (others => '0');
signal digit : std_logic_vector(15 downto 0) := X"8001";

--///////////////////////////////////////////////////////////////////////////////////////////////////////////
begin

out_std_clk<=sig_std_clk;
out_std_clk_inv<=not(sig_std_clk);
out_std_dout<=digit(0);
--////////////////////////////////////////////////////////////////////////
--		Процесс 										//
--////////////////////////////////////////////////////////////////////////
LABEL0: process (in_std_clk)
	begin
		if in_std_clk'event and in_std_clk = '1' then
		if cnt >= con_int_check then
			sig_std_clk <= not(sig_std_clk);-- выполнение процесса
			--sig_std_clk_inv <= not(sig_std_clk_inv);
		else
			sig_std_clk <= '0';
		end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////



----////////////////////////////////////////////////////////////////////////
----		Процесс 										//
----////////////////////////////////////////////////////////////////////////
--rev_bits: process (sig_std_clk )
	--begin
		--if sig_std_clk 'event and sig_std_clk = '0' then
			--digit <= digit(0) & digit(15 downto 1);
		--end if;
	--end process;
----///////////////////////////////////////////////////////////////////////


--////////////////////////////////////////////////////////////////////////
--		Процесс 										//
--////////////////////////////////////////////////////////////////////////
get_data: process (in_std_clk)
	begin
		if in_std_clk 'event and in_std_clk = '1' then
			if cnt < con_int_check then
				digit <= in_std16_data;
			elsif sig_std_clk_t1 = '1' and sig_std_clk = '0' then
				digit <= digit(0) & digit(15 downto 1);
			end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////


--////////////////////////////////////////////////////////////////////////
--		Процесс 										//
--////////////////////////////////////////////////////////////////////////
CNT_proc: process (in_std_clk)
	begin
		if in_std_clk'event and in_std_clk = '1' then
			if cnt < con_int_period then
				cnt <= cnt +1; 
			else
				cnt <=(others => '0');
			end if;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////
--		Процесс 										//
--////////////////////////////////////////////////////////////////////////
strobes: process (in_std_clk)
	begin
		if in_std_clk'event and in_std_clk = '1' then
			sig_std_clk_t1 <= sig_std_clk;
		end if;
	end process;
--///////////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--// 			Генерирование компонентов											  //
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
-- LABEL1: for i in 0 to NUM generate LABEL2: component_name
--	generic map (WIDTH_DATA)
--	port map	(
--				in_std : in std_logic;
--				inout_std : inout std_logic;
--				out_std : out std_logic	);
--	end generate;

end RTL_shift_seg;
