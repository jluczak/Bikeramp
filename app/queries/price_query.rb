class PriceQuery
  def self.weekly_price(relation: Trip)
    relation
      .where('created_at > ?', 1.week.ago)
      .sum(:price)
  end
end