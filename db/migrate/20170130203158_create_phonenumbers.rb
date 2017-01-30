class CreatePhonenumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :phonenumbers do |t|
      t.string :url
      t.string :number

      t.timestamps
    end
  end
end
