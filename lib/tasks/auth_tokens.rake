namespace :at do
  desc "Destroy expired auth tokens"
  
  task desexp: :environment do
    AuthToken.where("expired_at < ?", Time.now).delete_all 
  end
end