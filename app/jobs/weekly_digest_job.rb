class WeeklyDigestJob < ApplicationJob
  queue_as :default

  def perform
    # Use find_each to load users in batches (better for memory)
    User.find_each do |user|
      PostMailer.with(user: user).digest.deliver_later
    end

  end
end
