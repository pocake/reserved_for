require "spec_helper"
require 'reserved_for'
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
  end
end
