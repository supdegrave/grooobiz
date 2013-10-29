# edit migration to add categories_companies

class AddAttributesToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :location_id, :integer
    add_column :companies, :tagline, :string
    add_column :companies, :audience, :text
    add_column :companies, :launch_date, :string
    
    create_table(:categories_companies, :id => false) do |t|
      t.references :category
      t.references :company
    end
  end
end
