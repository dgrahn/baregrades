class CreateProfessors < ActiveRecord::Migration
  def change
    create_table :professors do |t|
      t.text :name

      t.timestamps
    end
  end
end
