class RemoveCountryFromRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders, :country
  end
end
