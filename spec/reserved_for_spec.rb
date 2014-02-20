require "spec_helper"
require 'reserved_for'

describe ReservedFor do
  context 'default list' do
    before do
      ReservedFor.clear_all!
      ReservedFor.reset!
    end

    describe 'default usernames' do
      it 'should includes "index"' do
        expect(ReservedFor.usernames.include?('index')).to be true
      end
    end
  end

  context 'custom list' do
    before do
      ReservedFor.clear_all!
      ReservedFor.usernames    = %w(alice bob charlie david)
      ReservedFor.group_names  = %w(root wheel)
      ReservedFor.whitelist    = %w(david)
    end

    describe '.[definded_list]' do
      it 'should return set of reserved word' do
        expect(ReservedFor.usernames).to eq Set.new(%w(alice bob charlie david))
      end
    end

    describe '.[undefined_list]' do
      it 'should return nil' do
        expect(ReservedFor.undefined_list_foo).to be_nil
      end
    end

    describe '.any' do
      it 'should return all reserved word excluding whitelist' do
        expect(ReservedFor.any).to eq Set.new(%w(alice bob charlie root wheel))
      end
      it 'should return all reserved ignoring whitelist' do
        expect(ReservedFor.any(whitelist: false)).to eq Set.new(%w(alice bob charlie david root wheel))
      end
    end

    describe '.clear_all!' do
      it 'should clear all reserved list and white list' do
        ReservedFor.clear_all!
        expect(ReservedFor.any).to        be_empty
        expect(ReservedFor.whitelist).to  be_empty
      end
    end
  end
end
