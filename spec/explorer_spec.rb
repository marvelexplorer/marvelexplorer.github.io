require 'spec_helper'

describe MarvelExplorer do
  it 'should get the default start character', :vcr do
    expect(MarvelExplorer.start_character[:name]).to eq 'Hulk'
  end
end
