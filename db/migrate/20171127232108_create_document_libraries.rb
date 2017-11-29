class CreateDocumentLibraries < ActiveRecord::Migration[5.1]
  def change
    create_table :document_libraries do |t|
      t.timestamps

      # define foreign keys for associated models
      t.belongs_to :document
      t.belongs_to :user
    end
  end
end
