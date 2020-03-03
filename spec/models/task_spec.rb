require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'is valid with name and completed status' do
    task = FactoryBot.build(:task, name: 'Estudo dirigido',
                                   completed: false)

    expect(task).to be_valid
  end

  it 'is valid without completed status' do
    task = FactoryBot.build(:task, name: 'Estudo dirigido',
                                   completed: nil)

    expect(task).to be_valid
  end

  it 'is invalid without name' do
    task = FactoryBot.build(:task, name: nil)

    task.valid?

    expect(task.errors[:name]).to include("can't be blank")
  end
end
