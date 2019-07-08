require 'rails_helper'

describe CalculateDistance do
  it 'returns correct object' do
    expect(described_class.new).to be_kind_of(CalculateDistance)
  end
end
