namespace :review do
  desc 'Setup and seed the database'
  task :setup do
    system 'bundle exec rails db:migrate'
    system 'bundle exec rails db:seed'
  end
end
