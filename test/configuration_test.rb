require File.absolute_path File.dirname(__FILE__) + '/test_helper'

describe Gemojione::Configuration do
  let(:instance) { Gemojione::Configuration.new }

  #----------------------------------------------------------------
  #                          #asset_host
  #----------------------------------------------------------------

  describe '#asset_host' do
    it 'returns localhost if no configuration was given' do
      assert_equal 'http://localhost:3000', instance.asset_host
    end

    it 'returns the custom host if a configuration was given' do
      instance.asset_host = 'http://assets.example.com'
      assert_equal 'http://assets.example.com', instance.asset_host
    end
  end

  #----------------------------------------------------------------
  #                          #asset_path
  #----------------------------------------------------------------

  describe '#asset_path' do
    it 'returns / if no configuration was given' do
      assert_equal '/', instance.asset_path
    end

    it 'returns the custom host if a configuration was given' do
      instance.asset_path = '/assets/'
      assert_equal '/assets/', instance.asset_path
    end
  end

  #----------------------------------------------------------------
  #             #default_format and #default_format=
  #----------------------------------------------------------------

  describe '#default_format' do
    it 'returns :svg if no custom format was set' do
      assert_equal :svg, instance.default_format
    end

    it 'returns the format set in the configuration' do
      instance.default_format = :png
      assert_equal :png, instance.default_format
    end
  end

  describe '#default_format=' do
    describe 'if the given format is valid' do
      it 'sets the new format' do
        instance.default_format = :png
        assert_equal :png, instance.default_format
      end
    end

    describe 'if the given format is invalid' do
      it 'does not set the new format' do
        old_format = instance.default_format
        instance.default_format = 'foo'
        assert_equal old_format, instance.default_format
      end
    end
  end

  #----------------------------------------------------------------
  #                          #escaper
  #----------------------------------------------------------------

  describe '#escaper' do
    describe 'if EscapeUtils are available' do
      it 'returns EscapeUtils' do
        Kernel.const_set(:EscapeUtils, Object.new)
        assert_equal EscapeUtils, instance.escaper
        Kernel.send(:remove_const, :EscapeUtils)
      end
    end

    describe 'if EscapeUtils are not available' do
      it 'returns CGI' do
        assert_equal CGI, instance.escaper
      end
    end
  end

  #----------------------------------------------------------------
  #                        #use_sprites?
  #----------------------------------------------------------------

  describe '#use_sprites?' do
    it 'returns +false+ if no configuration for use_sprites was given' do
      assert !instance.use_sprites?
    end

    it 'returns +true+ if the use_sprites flag is set' do
      instance.use_sprites = false
      assert !instance.use_sprites?

      instance.use_sprites = true
      assert instance.use_sprites?
    end
  end
end