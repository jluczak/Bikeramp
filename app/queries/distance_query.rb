class DistanceQuery
  def self.weekly_distance(relation: Trip)
    relation
      .where('created_at > ?', 1.week.ago)
      .sum(:distance)
  end

  def self.monthly_statistics(relation: Trip)
    today = DateTime.current
    current_month_first_day = today.beginning_of_month
    relation
      .select('date(created_at) as day, sum(distance) as total_distance')
      .where('created_at > ?', current_month_first_day)
      .group('date(created_at)')
      .order('date(created_at)')
      .as_json(:except => :id)
  end
end