# Run with rake db:development:fake_data

namespace :db do
  namespace :development do
    desc 'Create fake users, repositories, and permissions in the dev db.'
    task fake_data: :environment do
      require 'faker'

      # r is Read, w is Write, a is Admin
      @permission_types = ['r', 'w', 'f']

      # Regular users
      10.times do
        u = User.new(
          email: Faker::Internet.email,
          password: 'userpassword',
          password_confirmation: 'userpassword'
        )
        u.save
      end

      # Admins
      5.times do
        u = User.new(
          email: Faker::Internet.email,
          password: 'adminpassword',
          password_confirmation: 'adminpassword'
        )
        u.admin = true
        u.save
      end

      # Repositories
      20.times do
        name = Faker::Lorem.words(20).sample
        r = Repository.new(name: name)
        r.save
      end

      # Repository permissions
      20.times do
        p = Permission.new(
          user_id: User.all.sample.id,
          repository_id: Repository.all.sample.id,
          name: @permission_types.sample
        )
        p.save
      end
    end
  end
end
