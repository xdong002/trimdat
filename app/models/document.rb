class Document < ApplicationRecord
  has_many: document_librarys, dependent: :destroy
  has_many: users, through: :document_librarys
end
