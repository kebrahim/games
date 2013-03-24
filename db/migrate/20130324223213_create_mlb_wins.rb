class CreateMlbWins < ActiveRecord::Migration
  def change
    create_table :mlb_wins do |t|
      t.belongs_to :mlb_team
      t.integer :year
      t.float :line
      t.integer :actual

      t.timestamps
    end
    add_index :mlb_wins, :mlb_team_id
  end
end
