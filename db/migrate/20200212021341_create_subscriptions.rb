class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true
      t.timestamps
    end

    add_index :subscriptions, [:question_id, :user_id], unique: true
  end
end
