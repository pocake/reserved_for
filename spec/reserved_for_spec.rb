require "spec_helper"
require 'reserved_for'

describe ReservedFor do
  before do
    ReservedFor.clear_all!
    ReservedFor.usernames    = %w(alice bob charlie david)
    ReservedFor.group_names  = %w(root wheel)
    ReservedFor.white_list   = %w(david)
  end

  describe '.[definded_list]' do
    it 'should return set of reserved word' do
      expect(ReservedFor.usernames).to eq Set.new(%w(alice bob charlie david))
    end
  end

  describe '.[undefined_list]' do
    it 'should return empty set' do
      expect(ReservedFor.undefined_list_foo).to be_empty
    end
  end

  describe '.any' do
    it 'should return all reserved word excluding white_list' do
      expect(ReservedFor.any).to eq Set.new(%w(alice bob charlie root wheel))
    end
  end

  describe '.clear_all!' do
    it 'should clear all reserved list and white list' do
      ReservedFor.clear_all!
      expect(ReservedFor.any).to        be_empty
      expect(ReservedFor.white_list).to be_empty
    end
  end
end
