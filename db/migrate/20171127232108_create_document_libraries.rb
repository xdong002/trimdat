class CreateDocumentLibraries < ActiveRecord::Migration[5.1]
  def change
    create_table :document_libraries do |t|

      t.timestamps
    end
  end
end
