require "spec_helper"
require 'reserved_for/string_extension'

describe "String" do
  before do
    ReservedFor.clear_all!
    ReservedFor.usernames    = %w(alice bob charlie david)
    ReservedFor.group_names  = %w(root wheel)
    ReservedFor.white_list   = %w(david)
  end

  describe '#reserved_for?' do
    it 'alice is reserved' do
      expect('alice'.reserved_for?).to be true
    end
    it 'foo is not reserved' do
      expect('foo'.reserved_for?).to be false
    end
    it 'david is white_listed' do
      expect('david'.reserved_for?).to be false
    end
  end

  describe '#reserved_for_[defined_list]?' do
    it 'alice is reserved_for_usernames' do
      expect('alice'.reserved_for_usernames?).to be true
    end

  end
end
