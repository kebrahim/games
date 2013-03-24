class CreateMlbWinBets < ActiveRecord::Migration
  def change
    create_table :mlb_win_bets do |t|
      t.belongs_to :mlb_win
      t.belongs_to :user
      t.string :prediction
      t.integer :amount

      t.timestamps
    end
    add_index :mlb_win_bets, :mlb_win_id
    add_index :mlb_win_bets, :user_id
  end
end
