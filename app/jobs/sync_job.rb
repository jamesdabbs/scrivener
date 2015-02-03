class SyncJob
  include SuckerPunch::Job

  def perform user_id
    user = User.find_by_id user_id
    user.teamwork.tap do |t|
      Category.sync! t
      Author.sync!   t
      Journal.sync!  t
    end

    Author.guess_subjects!
    Journal.guess_weeks!
  rescue => e
    Rails.logger.error "Error while syncing: #{e}"
  end
end
