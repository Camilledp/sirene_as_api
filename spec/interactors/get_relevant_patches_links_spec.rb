require 'rails_helper'

describe GetRelevantPatchesLinks do
  before :each do
    puts 'Cleaning the database before test...'
    DatabaseCleaner.start
    puts 'Populating the database before test...'
    populate_test_database
  end

  after :each do
    puts 'Cleaning the database after test...'
    DatabaseCleaner.clean
  end

  context 'when in march & there are MORE than 5 patches',
          vcr: {  cassette_name: 'sirene_file_index_20170330',
                  allow_playback_repeats: true } do
    it 'retrieves the right number of patches' do
      add_one_recent_entry_7_patch_ago
      right_number_of_patches = 7
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  context 'when in march & there are LESS than 5 patches',
          vcr: {  cassette_name: 'sirene_file_index_20170330',
                  allow_playback_repeats: true } do
    it 'retrieves at least 5 patches' do
      add_one_recent_entry_2_patch_ago
      right_number_of_patches = 5
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  def populate_test_database
    50.times do
      create(:etablissement)
    end
  end

  def add_one_recent_entry_2_patch_ago
    puts "Adding one recent entry 2 patch ago"
    create(:etablissement, date_mise_a_jour: '2017-03-27T10:55:43')
  end

  def add_one_recent_entry_7_patch_ago
    puts "Adding one recent entry 7 patch ago"
    create(:etablissement, date_mise_a_jour: '2017-03-20T10:55:43')
  end
end