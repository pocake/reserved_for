require "spec_helper"

describe ReservedFor do
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

  describe '.[definded_list]' do
    it 'should return set of reserved word' do
      expect(ReservedFor.usernames).to eq Set.new(%w(alice bob charlie david))
    end
  end

  describe '.[undefined_list]' do
    it 'should return empty set' do
      expect(ReservedFor.undefined_list_foo).to eq Set.new
    end
  end

  describe '.any' do
    it 'should return all reserved word excluding white_list' do
      ReservedFor.clear_all!
      ReservedFor.list_a = %w(1 2 3)
      ReservedFor.list_b = %w(a b c)
      ReservedFor.white_list = %w(3 c)
      expect(ReservedFor.any).to eq Set.new(%w(1 2 a b))
    end
  end

end
