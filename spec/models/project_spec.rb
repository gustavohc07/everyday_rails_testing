require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'is valid with name, description and due date' do
    project = FactoryBot.build(:project, name: 'Projeto Pessoal',
                                         due_on: "03/01/2020",
                                         description: 'Meu projeto')

    expect(project).to be_valid
  end

  it 'is valid without description and due date' do
    project = FactoryBot.build(:project, description: nil,
                                         due_on: nil)

    expect(project).to be_valid
  end

  it 'is invalid without name' do
    project = FactoryBot.build(:project, name: nil)
    project.valid?

    expect(project.errors[:name]).to include("can't be blank")
  end

  describe 'late status' do
    it 'is late when the due date is past today' do
      project = FactoryBot.create(:project, :project_due_yesterday)

      expect(project).to be_late
    end

    it 'is on time when the due date is today' do
      project = FactoryBot.create(:project, :project_due_today)

      expect(project).not_to be_late
    end

    it 'is on time when the due date is in the future' do
      project = FactoryBot.create(:project, :project_due_tomorrow)

      expect(project).not_to be_late
    end
  end

  describe 'duplicate names' do
    it 'and does not allow duplicate project names per user' do
      user = FactoryBot.create(:user)

      user.projects.create(name: 'Comer burger')
      new_project = user.projects.build(name: 'Comer burger')

      new_project.valid?
      expect(new_project.errors[:name]).to include('has already been taken')
    end

    it 'and allows two users to share a project name' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:project, owner: user, name: 'Comer burger')

      other_user = FactoryBot.create(:user)
      other_project = FactoryBot.create(:project, owner: other_user,
                                                  name: 'Comer burger')

      expect(other_project).to be_valid
    end
  end

  describe 'notes' do
    it 'can have many notes' do
      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.length).to eq 5
    end
  end
end
