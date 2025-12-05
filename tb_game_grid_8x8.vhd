library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_game_grid is
end tb_game_grid;

architecture Sim of tb_game_grid is

    component game_grid_8x8 is
        Port ( 
            clk, reset   : in  STD_LOGIC;
            grid_out     : out STD_LOGIC_VECTOR(63 downto 0)
        );
    end component;

    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal grid_out : STD_LOGIC_VECTOR(63 downto 0);
    constant CLK_PERIOD : time := 10 ns;
    
begin

    UUT: game_grid_8x8 port map (
        clk      => clk,
        reset    => reset,
        grid_out => grid_out
    );

    -- Clock
    process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    -- testing uy
    process
    begin
        -- 1. Reset seluruh papan (Semua mati)
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';

        --2. INITIALIZE PATTERN: "BLINKER"
        wait for 10 * CLK_PERIOD;
        
        report "Fase 2 Selesai. Grid 8x8 terbentuk. Status: Semua sel Mati (Menunggu CPU di Fase 3).";
        wait;
    end process;

end Sim;
