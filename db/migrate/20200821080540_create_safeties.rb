class CreateSafeties < ActiveRecord::Migration[5.2]
  def change
    create_table :safeties do |t|
      t.references :disaster, foreign_key: true
      t.references :user, foreign_key: true
      t.string :myself
      t.string :contact_information

      t.timestamps
      
      t.index [:disaster_id, :user_id], unique: true
    end
  end
end
