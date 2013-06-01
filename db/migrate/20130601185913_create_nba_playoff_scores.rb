class CreateNbaPlayoffScores < ActiveRecord::Migration
  def change
    create_table :nba_playoff_scores do |t|
      t.integer :round
      t.integer :points
      t.string :name

      t.timestamps
    end
  end
end
