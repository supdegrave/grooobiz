class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.references :user, index: true
      t.string :name
      t.text :description
      t.binary :logo

      t.timestamps
    end
  end
end
