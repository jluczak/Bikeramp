require 'rails_helper'

RSpec.describe Trip, type: :model do
  context 'column presence and type' do
    it { is_expected.to have_db_column(:id) }
    it { is_expected.to have_db_column(:start_address).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:destination_address).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:price).of_type(:decimal).with_options(precision: 6, scale: 2, null: false) }
  end

  context 'validation' do
    it { is_expected.to validate_presence_of(:start_address) }
    it { is_expected.to validate_presence_of(:destination_address) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  end
end
