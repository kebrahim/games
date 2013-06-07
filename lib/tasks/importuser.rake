namespace :importuser do

  # environment is a rake task that loads all models
  desc "Imports user data from CSV file"
  task :users => :environment do
    require 'csv'
    usercount = 0
    CSV.foreach(File.join(File.expand_path(::Rails.root), "/lib/assets/users.csv")) do |row|
      email = row[0]
      first_name = row[1]
      last_name = row[2]
      is_admin = row[3]
      User.create(email: email, password: 'changeme', password_confirmation: 'changeme',
                  first_name: first_name, last_name: last_name, is_admin: is_admin)
      usercount += 1
    end
    puts "Imported " + usercount.to_s + " Users!"
  end
end