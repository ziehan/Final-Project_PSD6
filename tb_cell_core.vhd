library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cell_core is
end tb_cell_core;

architecture Sim of tb_cell_core is

    component cell_core is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               neighbors : in STD_LOGIC_VECTOR(7 downto 0);
               current_state : out STD_LOGIC);
    end component;

    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal neighbors : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal current_state : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: cell_core port map (
        clk => clk,
        reset => reset,
        neighbors => neighbors,
        current_state => current_state
    );

    -- Clock Process
    process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    -- Stimulus Process
    process
    begin
        -- 1. Reset awal
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        
        -- KASUS 1: Lahir (Reproduction)
        -- Input: 3 tetangga hidup -> Harusnya output jadi '1'
        neighbors <= "00000111"; -- 3 bit nyala
        wait for CLK_PERIOD;
        assert current_state = '1' report "Error: Gagal Lahir (3 tetangga)" severity error;

        -- KASUS 2: Bertahan (Survival)
        -- Input: 2 tetangga hidup -> Harusnya output TETAP '1' (karena sebelumnya hidup)
        neighbors <= "00000011"; -- 2 bit nyala
        wait for CLK_PERIOD;
        assert current_state = '1' report "Error: Gagal Bertahan (2 tetangga)" severity error;

        -- KASUS 3: Mati Kepadatan (Overpopulation)
        -- Input: 4 tetangga hidup -> Harusnya output jadi '0'
        neighbors <= "00001111"; -- 4 bit nyala
        wait for CLK_PERIOD;
        assert current_state = '0' report "Error: Gagal Mati Kepadatan" severity error;

        -- KASUS 4: Mati Kesepian (Underpopulation)
        -- Input: 1 tetangga hidup -> Harusnya output TETAP '0'
        neighbors <= "00000001"; -- 1 bit nyala
        wait for CLK_PERIOD;
        assert current_state = '0' report "Error: Gagal Mati Kesepian" severity error;

        report "Simulasi Selesai. Jika tidak ada error di atas, berarti sukses!";
        wait;
    end process;

end Sim;
