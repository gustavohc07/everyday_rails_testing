require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = User.create(first_name: 'Gustavo',
                       last_name: 'Carvalho',
                       email: 'test@test.com',
                       password: '123456')
    @project = @user.projects.create(name: 'Test Project')
  end

  it 'is valid with user, project and message' do
    note = Note.new(message: 'Sou um teste',
                    user: @user,
                    project: @project)


    expect(note).to be_valid
  end

  it 'is invalid without a message' do
    note = Note.new(user: @user,
                    project: @project)
    note.valid?
    expect(note).not_to be_valid
    expect(note.errors[:message]).to include("can't be blank")
  end
  describe 'search message for a term' do
    before do
      @note1 = @project.notes.create(message: 'This is the first note.',
                                   user: @user)
      @note2 = @project.notes.create(message: 'This is the second note.',
                                   user: @user)
      @note3 = @project.notes.create(message: 'First, preheat the oven.',
                                   user: @user)
      @note4 = @project.notes.create(message: 'First, we have first hand.',
                                   user: @user)
    end

    context 'when a match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('FIRST')).to include(@note1, @note3, @note4)
        expect(Note.search('FIRST')).not_to include(@note2)
      end
    end

    context 'when no match is found' do
      it 'returns an empty collection when no results are found' do
        expect(Note.search('gustavo')).to be_empty
      end
    end
  end
end
