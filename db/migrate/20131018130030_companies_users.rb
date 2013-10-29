class CompaniesUsers < ActiveRecord::Migration
  def change
    # create new table for many-to-many reference 
    create_table 'companies_users', :id => false do |t|
      t.column :company_id, :integer
      t.column :user_id, :integer
    end
    
    # remove user_id column from companies now that this will be many-to-many
    remove_column :companies, :user_id, :integer
  end
end
