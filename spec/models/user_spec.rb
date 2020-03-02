require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a first name, last name, email, and password' do
    user = User.new(first_name: 'Gustavo',
                    last_name: 'Carvalho',
                    email: 'test@test.com',
                    password: '123456')

    expect(user).to be_valid
  end

  it 'is invalid without first name' do
    user = User.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without last name' do
    user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it 'is invalid without email' do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    User.create(first_name: 'Thiago',
                last_name: 'Carvalho',
                email: 'test@test.com',
                password: '123456')

    user = User.new(first_name: 'Gustavo',
                    last_name: 'Carvalho',
                    email: 'test@test.com',
                    password: '123456')

    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
  it "returns a user's full name as a string" do
    user = User.new(first_name: 'Gustavo',
                    last_name: 'Carvalho',
                    email: 'test@test.com',
                    password: '123456')

    expect(user.name).to eq('Gustavo Carvalho')
  end
end
