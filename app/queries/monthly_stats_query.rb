class MonthlyStatsQuery
  def self.monthly_stats(relation: Trip)
    today = DateTime.current
    relation
      .select('date(created_at) as day,
               sum(distance) as total_distance,
               sum(price) as total_price,
               avg(distance) as avg_ride,
               avg(price) as avg_price')
      .where('created_at > ?', today.beginning_of_month)
      .group('date(created_at)')
      .order(Arel.sql('date(created_at)'))
      .as_json(except: :id)
  end
end