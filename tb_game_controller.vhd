library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_game_controller is
end tb_game_controller;

architecture Sim of tb_game_controller is

    component game_controller is
        Port (
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            grid_we     : out STD_LOGIC;
            grid_row    : out integer range 0 to 7;
            grid_col    : out integer range 0 to 7;
            grid_data   : out STD_LOGIC;
            sim_running : out STD_LOGIC
        );
    end component;

    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    
    -- Sinyal untuk menampung output CPU
    signal we    : STD_LOGIC;
    signal row   : integer;
    signal col   : integer;
    signal data  : STD_LOGIC;
    signal run   : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: game_controller port map (
        clk => clk, reset => reset,
        grid_we => we, grid_row => row, grid_col => col, 
        grid_data => data, sim_running => run
    );

    -- Clock Process
    process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    -- Stimulus
    process
    begin
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        
        -- Kita tunggu sekitar 10 clock cycle.
        -- Seharusnya CPU mengeluarkan koordinat Glider satu per satu.
        wait for 15 * CLK_PERIOD;
        
        report "Cek Waveform. Pastikan koordinat (0,1), (1,2), dst muncul berurutan.";
        wait;
    end process;

end Sim;