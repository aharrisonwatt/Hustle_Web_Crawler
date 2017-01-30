class Phonenumber < ApplicationRecord
  validates :url, :number presense: true

  def add_phonenumber(url, number)
    Phonenumber.create!({
      url: url,
      number: number
    })
  end
end
