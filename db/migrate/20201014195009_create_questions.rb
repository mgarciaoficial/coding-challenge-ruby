class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.boolean :share, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
