# Run this the first time on a new server:
# system 'bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed'

# Run this if the database already exists:
system 'bundle exec rake db:drop && bundle exec rake db:create && bundle exec rake db:migrate && bundle exec rake db:seed'
