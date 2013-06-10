class CreateMlbStandings < ActiveRecord::Migration
  def change
    create_table :mlb_standings do |t|
      t.integer :year
      t.belongs_to :mlb_team
      t.integer :wins
      t.integer :losses

      t.timestamps
    end
    add_index :mlb_standings, :mlb_team_id
    add_index :mlb_standings, [:year, :mlb_team_id],
        {:unique => true, :name => "mlb_standings_year_team"}
  end
end
