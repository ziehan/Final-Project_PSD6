library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cell_core is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        we : in STD_LOGIC; -- write enable
        data_in : in STD_LOGIC; -- nilai yang mau ditulis (1/0)
        neighbors : in STD_LOGIC_VECTOR(7 downto 0); -- Status 8 tetangga
        enable_sim : in STD_LOGIC; -- INPUT BARU: Sinyal Enable dari Controller
        current_state : out STD_LOGIC -- Output status sel ini
    );
end cell_core;

architecture Behavioral of cell_core is

    -- Sinyal internal untuk menyimpan status saat ini (Modul 3: Register)
    signal state_reg : std_logic := '0';

    -- [MODUL 7] FUNCTION: Aturan Game of Life (Fungsi Murni)
    function get_next_state(neigh_count : integer; curr_state : std_logic) return std_logic is
    begin
        -- Aturan Conway's Game of Life:
        if neigh_count < 2 then
            return '0'; -- Mati (Kesepian)
        elsif neigh_count > 3 then
            return '0'; -- Mati (Kepadatan)
        elsif neigh_count = 3 then
            return '1'; -- Lahir / Tetap Hidup
        elsif neigh_count = 2 then
            return curr_state; -- Bertahan (Status tetap sama)
        else
            return '0'; -- Default mati (untuk keamanan)
        end if;
    end function;

begin

    -- [MODUL 3] PROCESS: Logika Sekuensial (Berbasis Clock)
    process(clk, reset)
        variable live_neighbors : integer range 0 to 8; -- Variabel penghitung (Modul 2)
    begin
        if reset = '1' then
            state_reg <= '0'; -- Reset sel menjadi mati
        
        elsif rising_edge(clk) then
            -- [MODUL 8/9 LOGIC] Priority: CPU Write > Game Rules
            if we = '1' then
                state_reg <= data_in;
            elsif enable_sim = '1' then
                -- Hitung jumlah tetangga yang hidup (Modul 2: Operasi Aritmetika)
                -- Set ulang penghitung setiap siklus
                live_neighbors := 0;
                
                -- Loop manual untuk menghitung bit '1' pada vector neighbors
                for i in 0 to 7 loop
                    if neighbors(i) = '1' then
                        live_neighbors := live_neighbors + 1;
                    end if;
                end loop;
                
                -- Menentukan status sel berikutnya menggunakan Function (Modul 7)
                state_reg <= get_next_state(live_neighbors, state_reg);
            else
                -- Jika enable_sim = 0 dan we = 0, tahan nilai lama (Memory)
                state_reg <= state_reg;
            end if;
        end if;
    end process;

    current_state <= state_reg;

end Behavioral;