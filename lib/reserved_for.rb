require "reserved_for/version"

module ReservedFor
  before do
    ReservedFor.clear_all!
    ReservedFor.usernames  = %w(alice bob charlie david)
    ReservedFor.white_list = %w(david)
  end

  describe '.clear_all!' do
    it 'should clear all reserved list and white list' do
      ReservedFor.clear_all!
      expect(ReservedFor.usernames).to be_empty
    end
  end
end
