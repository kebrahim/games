class CreateMlbTeams < ActiveRecord::Migration
  def change
    create_table :mlb_teams do |t|
      t.string :city
      t.string :name
      t.string :abbreviation
      t.string :division
      t.string :league

      t.timestamps
    end
  end
end
