class DropChallengesAndMilestones < ActiveRecord::Migration[5.2]
  def change
    drop_table :milestones
    drop_table :challenges
  end
end
