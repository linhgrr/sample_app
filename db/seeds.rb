User.create!(name: "Example User1",
             email: "admin@gmail.com",
             birthday: 25.years.ago,
             gender: "male",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true)

30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  birthday = Faker::Date.birthday(min_age: 18, max_age: 65)
  gender = ["male", "female"].sample
  password = "password"
  User.create!(name: name,
               email: email,
               birthday: birthday,
               gender: gender,
               password: password,
               password_confirmation: password)
end
