require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'is valid with user, name, description and due date' do
    user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')
    project = Project.new(name: 'Projeto Pessoal',
                          owner: user,
                          due_on: "03/01/2020",
                          description: 'Meu projeto')

    expect(project).to be_valid
  end

  it 'is valid without description and due date' do
    user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')

    project = Project.new(name: 'Projeto Pessoal',
                          owner: user,
                          description: nil,
                          due_on: nil)

    expect(project).to be_valid
  end

  it 'is invalid without name' do
    user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')

    project = user.projects.new(name: nil)
    project.valid?

    expect(project.errors[:name]).to include("can't be blank")
  end

  it 'returns true if a project is late' do
    user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')

    project = Project.new(name: 'Projeto Pessoal',
                          owner: user,
                          due_on: "03/01/2020",
                          description: 'Meu projeto')

    expect(project.late?).to eq true
  end

  it 'return false if a project is not late' do
    user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')

    project = Project.new(name: 'Projeto Pessoal',
                          owner: user,
                          due_on: "03/05/2020",
                          description: 'Meu projeto')

    expect(project.late?).to eq false
  end

  describe 'verify duplicate names' do
    it 'and does not allow duplicate project names per user' do
      user = User.create(first_name: 'Gustavo',
                         last_name: 'Carvalho',
                         email: 'test@test.com',
                         password: '123456')

      user.projects.create(name: 'Comer burger')
      new_project = user.projects.build(name: 'Comer burger')

      new_project.valid?
      expect(new_project.errors[:name]).to include('has already been taken')
    end

    it 'and allows two users to share a project name' do
      user = User.create(first_name: 'Thiago',
                         last_name: 'Carvalho',
                         email: 'test@test.com',
                         password: '123456')
      user.projects.create(name: 'Comer burger')

      other_user = User.create(first_name: 'Gustavo',
                               last_name: 'Carvalho',
                               email: 'test2@test.com',
                               password: '123456')
      other_project = other_user.projects.build(name: 'Comer burger')

      expect(other_project).to be_valid
    end
  end
end
