# frozen_string_literal: true

class RequiredDocument < ApplicationRecord
  belongs_to :request_for_tender,
             inverse_of: :required_documents

  has_many :required_document_uploads,
           dependent: :destroy,
           inverse_of: :required_document
  accepts_nested_attributes_for :required_document_uploads,
                                allow_destroy: true,
                                reject_if: :all_blank
end
