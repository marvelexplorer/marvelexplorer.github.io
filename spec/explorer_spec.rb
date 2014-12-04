require 'spec_helper'

describe MarvelExplorer do
  before :each do
    Timecop.freeze '2014-12-03T19:01:00+00:00'
    @me = MarvelExplorer.new
  end

  after :each do
    Timecop.return
  end

  it 'should get the default start character', :vcr do
    MARSHAL_FILE = 'not_a_path'
    expect(@me.start_character.name).to eq 'Hulk'
  end

  it 'should load the stored character', :vcr do
    MARSHAL_FILE = 'spec/fixtures/last.character'
    expect(@me.start_character.name).to eq 'Human Torch'
  end

  it 'should select a comic for the start character', :vcr do
    MARSHAL_FILE = 'not_a_path'
    stub_request(:get, /gateway.marvel.com\/v1\/public\/characters\/1009351\/comics/)
    .to_return(status: 200, body: File.read('spec/fixtures/hulk_comics.json'))
    expect(@me.comic.title).to eq 'Marvel Double Shot (2003) #2'
  end

  it 'should get the end character from the comic', :vcr do
    stub_request(:get, /gateway.marvel.com\/v1\/public\/characters\/1009351\/comics/)
    .to_return(status: 200, body: File.read('spec/fixtures/hulk_comics.json'))
    stub_request(:get, /gateway.marvel.com\/v1\/public\/comics\/19843\/characters/)
    .to_return(status: 200, body: File.read('spec/fixtures/double-shot-characters.json'))
    expect(@me.end_character.name).to eq 'Avengers'
  end

  it 'should save the end character', :vcr do
    MARSHAL_FILE = 'tmp/last.character'
    stub_request(:get, /gateway.marvel.com\/v1\/public\/characters\/1009351\/comics/)
    .to_return(status: 200, body: File.read('spec/fixtures/hulk_comics.json'))
    stub_request(:get, /gateway.marvel.com\/v1\/public\/comics\/19843\/characters/)
    .to_return(status: 200, body: File.read('spec/fixtures/double-shot-characters.json'))
    @me.save
    f = Marshal.load File.read MARSHAL_FILE
    expect(f.name).to eq 'Avengers'
  end

  it 'should generate correct yaml' # this should be easy with fixtures

  it 'should extract the year correctly', :vcr do
    c = Ultron::Comics.find '50372'
    expect(MarvelExplorer.get_year c).to eq 2014
  end
end
