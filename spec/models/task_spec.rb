require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'is valid with name, user, and completed status' do
    user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')
    project = Project.create(name: 'Projeto Pessoal',
                             owner: user,
                             due_on: "03/01/2020",
                             description: 'Meu projeto')
    task = project.tasks.new(name: 'Estudo dirigido',
                             completed: false)

    expect(task).to be_valid
  end

  it 'is valid without completed status' do
    user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')
    project = Project.create(name: 'Projeto Pessoal',
                             owner: user,
                             due_on: "03/01/2020",
                             description: 'Meu projeto')
    task = project.tasks.new(name: 'Estudo dirigido',
                             completed: nil)

    expect(task).to be_valid
  end

  it 'is invalid without name' do
    user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')
    project = Project.create(name: 'Projeto Pessoal',
                             owner: user,
                             due_on: "03/01/2020",
                             description: 'Meu projeto')
    task = project.tasks.new(name: nil)

    task.valid?

    expect(task.errors[:name]).to include("can't be blank")
  end
end
