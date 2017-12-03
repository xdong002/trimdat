class AddDocumentOwnerName < ActiveRecord::Migration[5.1]
  def change
  	add_column :documents, :owner_name, :string
  end
end
