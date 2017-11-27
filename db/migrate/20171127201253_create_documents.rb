class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.string :content_status
      t.text :original_file
      t.string :data_type
      t.string :name
      t.text :fixed_file

      t.timestamps
    end
  end
end
