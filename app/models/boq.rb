class Boq < ApplicationRecord

    belongs_to :request

    has_many :pages, dependent: :destroy, autosave: true

    validates :name, presence: true

end