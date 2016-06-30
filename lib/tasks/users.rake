namespace :usr do
  desc "Destroy unconfirmed accounts"
  
  task desunconf: :environment do
    User.where(confirmed_at: nil).where("created_at < ?", Time.now - 24.hours).destroy_all
  end
end
