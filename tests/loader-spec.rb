require_relative '../lib/loader'
require_relative '../lib/error'

describe Loader do
  subject(:loader) { Loader.new }

  before do
    loader.populate_environment()
  end

  describe 'populate_environment' do
    let(:env) { create(:environment, value: []) }

    it 'should populate the environment with all the utils' do
      expect (env << 1).to change { env }.by(Dir['../lib/utils'].length)
    end
  end

  describe 'read_util' do
    it 'loads an utility and returns its metadata' do
      utils = Dir['../lib/utils/*']

      utils.each do |util|
        metadata = loader.load_util(utils.first)

        expect(metadata).to have_key(:method)
        expect(metadata).to have_key(:description)
        expect(metadata).to include(:method, :description)
      end
    end
  end

  describe 'load_util' do
    it 'returns NoLibraries when the util has no metadata' do
      expect { loader.load_util('unknown_util') }.
        to raise_error { |error| expect(error).equal?(ErrorType::NoLibraries) }
    end
  end
end
