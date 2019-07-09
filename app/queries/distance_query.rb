class DistanceQuery
  def self.weekly_distance(relation: Trip)
    relation
      .where('created_at > ?', 1.week.ago)
      .sum(:distance)
  end
end