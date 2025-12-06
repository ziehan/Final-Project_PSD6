library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_top_system is
end tb_top_system;

architecture Sim of tb_top_system is

    component top_system is
        Port ( clk, reset : in STD_LOGIC;
                grid_out : out STD_LOGIC_VECTOR(63 downto 0));
    end component;

    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal grid  : STD_LOGIC_VECTOR(63 downto 0);

    constant CLK_PERIOD : time := 10 ns;
    file file_out : text open write_mode is "output_game.txt";

begin

    UUT: top_system port map (clk => clk, reset => reset, grid_out => grid);

    -- clock 
    process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    -- Main Simulation
    process
        variable line_buf : line;
        variable i : integer;
    begin
        -- Reset 
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        
        -- CPU Menggambar Pola (Sekitar 6-7 clock cycle untuk Glider)
        wait for CLK_PERIOD * 10;
        
        report "CPU Selesai Menggambar. Memulai Simulasi Game of Life...";

        -- Capture Frame selama 30 Clock Cycle (Generasi)
        for gen in 1 to 30 loop
            wait until rising_edge(clk);
            
            write(line_buf, string'("FRAME: "));
            write(line_buf, gen);
            writeline(file_out, line_buf);

            -- print grid 8x8 untuk bentuk kotak
            -- grid indeks: (Baris * 8) + Kolom
            for r in 0 to 7 loop
                -- 8 bit per baris 
                write(line_buf, grid((r*8)+7 downto (r*8)));
                writeline(file_out, line_buf);
            end loop;
            
            write(line_buf, string'("================="));
            writeline(file_out, line_buf);
        end loop;

        wait;
    end process;

end Sim;
