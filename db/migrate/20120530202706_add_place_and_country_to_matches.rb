class AddPlaceAndCountryToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :place, :string
    add_column :matches, :country, :string
  end
end
