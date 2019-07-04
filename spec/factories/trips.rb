FactoryBot.define do
  factory :trip do
    start_address { 'Plac Europejski 2, Warszawa, Polska' }
    destination_address { 'Leszno 15, Warszawa, Polska' }
    price { '4.65' }
    distance { '798.76' }
  end
end
