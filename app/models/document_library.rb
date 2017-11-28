class DocumentLibrary < ApplicationRecord
  belongs_to :user, foreign_key: true
  belongs_to :document, foreign_key: true
end
