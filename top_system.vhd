library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_system is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        grid_out : out STD_LOGIC_VECTOR(63 downto 0)
    );
end top_system;

architecture Structural of top_system is

    --CPU
    component game_controller is
        Port (
            clk, reset : in STD_LOGIC;
            grid_we    : out STD_LOGIC;
            grid_row, grid_col : out integer range 0 to 7;
            grid_data  : out STD_LOGIC;
            sim_running : out STD_LOGIC
        );
    end component;

    --Grid
    component game_grid_8x8 is
        Port (
            clk, reset : in STD_LOGIC;
            cpu_we     : in STD_LOGIC;
            cpu_row, cpu_col : in integer range 0 to 7;
            cpu_data   : in STD_LOGIC;
            grid_out   : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    --internal signals
    signal w_we   : std_logic;
    signal w_row  : integer range 0 to 7;
    signal w_col  : integer range 0 to 7;
    signal w_data : std_logic;
    signal w_run  : std_logic;

begin

    -- 1. CPU Controller
    CPU_Inst: game_controller port map (
        clk => clk,
        reset => reset,
        grid_we => w_we,
        grid_row => w_row,
        grid_col => w_col,
        grid_data => w_data,
        sim_running => w_run
    );

    -- 2.Grid 8x8
    Grid_Inst: game_grid_8x8 port map (
        clk => clk,
        reset => reset,
        cpu_we => w_we,
        cpu_row => w_row,
        cpu_col => w_col,
        cpu_data => w_data,
        grid_out => grid_out
    );

end Structural;
