require "spec_helper"
require 'reserved_for'

describe ReservedFor do
  context 'default list' do
    before do
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

  describe '.configure' do
    it 'has default config' do
      ReservedFor.configure do |config|
        # do nothing
      end
      expect(ReservedFor.options).to eq({
        use_default_reserved_list:  true,
        check_plural:               true,
        case_sensitive:             false,
      })
    end

    it 'can set config' do
      ReservedFor.configure do |config|
        config.use_default_reserved_list = false
        config.check_plural              = false
        config.case_sensitive            = true
      end
      expect(ReservedFor.options).to eq({
        use_default_reserved_list:  false,
        check_plural:               false,
        case_sensitive:             true,
      })
    end

    it 'raise error for invalid option name' do
      expect {
        ReservedFor.configure do |config|
          config.invalid_option_name_foo = true
        end
      }.to raise_error(ReservedFor::InvalidOptionError, 'invalid options: [:invalid_option_name_foo]')
    end
  end

  context 'use_default_reserved_list' do
    context 'enabled' do
      before do
        ReservedFor.configure do |config|
          config.use_default_reserved_list = true
        end
      end
      it 'should contain something' do
        expect(ReservedFor.any).not_to be_empty
      end
    end

    context 'disabled' do
      before do
        ReservedFor.configure do |config|
          config.use_default_reserved_list = false
        end
      end
      it 'should be empty' do
        expect(ReservedFor.any).to be_empty
      end
    end
  end

  context 'plural' do
    context 'enabled' do
      before do
        ReservedFor.configure do |config|
          config.check_plural = true
        end
        ReservedFor.fruits = %(apple)
      end

      it {
        expect(ReservedFor.fruits.include?('apple')).to be  true
        expect(ReservedFor.fruits.include?('apples')).to be true
      }
    end

    context 'disabled' do
      before do
        ReservedFor.configure do |config|
          config.check_plural = false
        end
        ReservedFor.fruits = %(apple)
      end

      it {
        expect(ReservedFor.fruits.include?('apple')).to be  true
        expect(ReservedFor.fruits.include?('apples')).to be false
      }
    end
  end

  context 'case sensitive' do
    context 'enabled' do
      before do
        ReservedFor.configure do |config|
          config.case_sensitive = true
        end
        ReservedFor.fruits = %(apple)
      end
      it {
        expect(ReservedFor.fruits.include?('apple')).to be true
        expect(ReservedFor.fruits.include?('APPLE')).to be true
        expect(ReservedFor.fruits.include?('Apple')).to be true
      }
    end

    context 'disabled' do
      before do
        ReservedFor.fruits = %(apple)
        ReservedFor.configure do |config|
          config.case_sensitive = false
        end
      end
      it {
        expect(ReservedFor.fruits.include?('apple')).to be true
        expect(ReservedFor.fruits.include?('APPLE')).to be false
        expect(ReservedFor.fruits.include?('Apple')).to be false
      }
    end
  end

  context 'plural and case sensitive' do
    before do
      ReservedFor.configure do |config|
        config.case_sensitive = true
      end
      ReservedFor.fruits = %(apple)
    end
    it {
      expect(ReservedFor.fruits.include?('apple')).to be true
      expect(ReservedFor.fruits.include?('APPLE')).to be true
      expect(ReservedFor.fruits.include?('apples')).to be true
      expect(ReservedFor.fruits.include?('APPLES')).to be true
    }
  end
end
