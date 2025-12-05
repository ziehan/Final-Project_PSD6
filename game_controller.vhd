library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_controller is
    Port(
        clk : in std_logic;
        reset : in std_logic;
        -- Output ke Grid
        grid_we : out STD_LOGIC;
        grid_row : out integer range 0 to 7;
        grid_col : out integer range 0 to 7;
        grid_data : out STD_LOGIC;
        -- Status
        sim_running : out STD_LOGIC -- '1' = edit selesai, '0' = masih gambar
    );
end game_controller;

architecture Behavioral of game_controller is
    -- [MODUL 9] MICROCODE ROM
    -- Format Instruksi: [ROW(3 bit) | COL(3 bit) | VAL(1 bit) | IS_LAST(1 bit)]
    -- Total 8 bit per instruksi.
    type rom_type is array (0 to 5) of std_logic_vector(7 downto 0);

    -- ISI ROM: Pola "GLIDER"
    -- Koordinat Glider: (0,1), (1,2), (2,0), (2,1), (2,2)
    constant PATTERN_ROM : rom_type := (
        -- RRR CCC V L (Row, Col, Value, Last?)
        "00000110", -- Set (0,1) = 1
        "00101010", -- Set (1,2) = 1
        "01000010", -- Set (2,0) = 1
        "01000110", -- Set (2,1) = 1
        "01001011", -- Set (2,2) = 1 (LAST INSTR = '1')
        "00000000"  -- Padding
    );

    -- [MODUL 8] FSM States
    type state_type is (RESET_STATE, WRITE_STATE, RUN_STATE);
    signal state : state_type := RESET_STATE;
    
    -- Program Counter (uPC)
    signal pc : integer range 0 to 15 := 0;

begin
    process(clk, reset)
        variable instruction : std_logic_vector(7 downto 0);
        variable is_last     : std_logic;
    begin
        if reset = '1' then
            state <= RESET_STATE;
            pc <= 0;
            grid_we <= '0';
            sim_running <= '0';
            
        elsif rising_edge(clk) then
            case state is
                when RESET_STATE =>
                    state <= WRITE_STATE; -- Langsung pindah ke mode tulis
                    pc <= 0;
                    sim_running <= '0';

                when WRITE_STATE =>
                    -- Fetch Instruksi
                    instruction := PATTERN_ROM(pc);
                    is_last     := instruction(0); -- Bit terakhir penanda selesai
                    
                    -- Decode ke Output Grid
                    grid_row  <= to_integer(unsigned(instruction(7 downto 5)));
                    grid_col  <= to_integer(unsigned(instruction(4 downto 2)));
                    grid_data <= instruction(1);
                    grid_we   <= '1'; -- Aktifkan tulis

                    -- Next State Logic
                    if is_last = '1' then
                        state <= RUN_STATE; -- Selesai gambar, jalankan game
                        grid_we <= '0'; -- Matikan mode tulis segera (di next cycle efektifnya)
                    else
                        pc <= pc + 1; -- Lanjut instruksi berikutnya
                    end if;

                when RUN_STATE =>
                    -- Mode Simulasi: CPU diam, Grid jalan sendiri
                    grid_we <= '0';
                    sim_running <= '1';
                    -- CPU Idle forever
            end case;
        end if;
    end process;

end Behavioral;