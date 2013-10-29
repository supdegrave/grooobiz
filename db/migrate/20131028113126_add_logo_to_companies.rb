class AddLogoToCompanies < ActiveRecord::Migration
  def change
    change_column :companies, :logo, :string
  end
end
