class MonthlyStatsQuery
  def self.monthly_stats(relation: Trip)
    today = DateTime.current
    current_month_first_day = today.beginning_of_month
    relation
      .select('date(created_at) as day,
               sum(distance) as total_distance,
               sum(price) as total_price,
               avg(distance) as avg_ride')
      .where('created_at > ?', current_month_first_day)
      .group('date(created_at)')
      .order('date(created_at)')
      .as_json(except: :id)
  end
end