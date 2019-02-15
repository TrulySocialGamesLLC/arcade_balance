class Minigame < ApplicationRecord
  before_create :fill_inserted_at

  def fill_inserted_at
    self.inserted_at = updated_at
  end
end
