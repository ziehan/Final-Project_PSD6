library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_grid_8x8 is
    Port (
        clk, reset  : in  STD_LOGIC;
        grid_out    : out STD_LOGIC_VECTOR(63 downto 0)
    );
end game_grid_8x8;

architecture Structural of game_grid_8x8 is

    -- [MODUL 5] COMPONENT: untun mangggil "Otak" yg udh dibuat
    component cell_core is
        Port (
            clk           : in  STD_LOGIC;
            reset         : in  STD_LOGIC;
            neighbors     : in  STD_LOGIC_VECTOR(7 downto 0);
            current_state : out STD_LOGIC
        );
    end component;

    type grid_type is array (0 to 7, 0 to 7) of std_logic;
    signal grid_matrix : grid_type;

begin

    -- [MODUL 6] LOOPING GENERATE: buat 64 sel otomatis, pake nested loop
    Gen_Rows: for r in 0 to 7 generate
        Gen_Cols: for c in 0 to 7 generate
            
            signal my_neighbors : std_logic_vector(7 downto 0);
            
            -- index 0 dikurang 1 -> jadi 7 (Wrap)
            -- index 7 ditambah 1 -> jadi 0 (Wrap)
            constant r_up   : integer := (r + 7) mod 8;
            constant r_down : integer := (r + 1) mod 8;
            constant c_left : integer := (c + 7) mod 8;
            constant c_right: integer := (c + 1) mod 8;

        begin
            -- 1. KABEL SPAGHETTI OTOMATIS (Wiring)
            -- Urutan: N, NE, E, SE, S, SW, W, NW
            my_neighbors(0) <= grid_matrix(r_up,   c);       -- North
            my_neighbors(1) <= grid_matrix(r_up,   c_right); -- North-East
            my_neighbors(2) <= grid_matrix(r,      c_right); -- East
            my_neighbors(3) <= grid_matrix(r_down, c_right); -- South-East
            my_neighbors(4) <= grid_matrix(r_down, c);       -- South
            my_neighbors(5) <= grid_matrix(r_down, c_left);  -- South-West
            my_neighbors(6) <= grid_matrix(r,      c_left);  -- West
            my_neighbors(7) <= grid_matrix(r_up,   c_left);  -- North-West

            -- 2. INSTANSIASI SEL (Port Map)
            Cell_Inst: cell_core
                port map (
                    clk           => clk,
                    reset         => reset,
                    neighbors     => my_neighbors,
                    current_state => grid_matrix(r, c)
                );
                
        end generate Gen_Cols;
    end generate Gen_Rows;

    -- FLATTENING: Mengubah Array 2D (Matriks) menjadi Vector 1D (64-bit) untuk Output
    process(grid_matrix)
    begin
        for r in 0 to 7 loop
            for c in 0 to 7 loop
                grid_out((r * 8) + c) <= grid_matrix(r, c);
            end loop;
        end loop;
    end process;

end Structural;