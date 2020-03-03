require 'rails_helper'

RSpec.describe Note, type: :model do
  it 'is valid with a message' do
    note = FactoryBot.build(:note, message: 'Sou um teste')

    expect(note).to be_valid
  end

  it 'is invalid without a message' do
    note = FactoryBot.build(:note, message: nil)
    note.valid?
    expect(note).not_to be_valid
    expect(note.errors[:message]).to include("can't be blank")
  end
  describe 'search message for a term' do
    before do
      project = FactoryBot.create(:project)

      @note1 = FactoryBot.create(:note, message: 'This is the first note.',
                                        project: project)
      @note2 = FactoryBot.create(:note, message: 'This is the second note.',
                                        project: project)
      @note3 = FactoryBot.create(:note, message: 'First, preheat the oven.',
                                        project: project)
      @note4 = FactoryBot.create(:note, message: 'First, we have first hand.',
                                        project: project)
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
