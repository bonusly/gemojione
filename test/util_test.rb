require File.absolute_path File.dirname(__FILE__) + '/test_helper'
require 'ostruct'

describe Gemojione::Util do
  let(:util) { Gemojione::Util }
  let(:config) { Gemojione.configuration }

  #----------------------------------------------------------------
  #                         .asset_url
  #----------------------------------------------------------------

  describe '.asset_url' do
    describe 'if ActionController is available' do
      before(:each) do
        Object.new.tap do |proxy|
          def proxy.asset_url(s)
            s
          end

          Kernel.const_set(:ApplicationController, OpenStruct.new(helpers: proxy))
        end
      end

      after(:each) { Kernel.send(:remove_const, :ApplicationController) }

      it 'uses its helper proxy to generate the asset url' do
        config.asset_path = 'assets'
        assert_equal 'assets/svg/emoji.svg', util.asset_url(:emoji)

        config.asset_path = '/'
        assert_equal 'svg/emoji.svg', util.asset_url(:emoji)
      end

      it 'respects the given image format' do
        assert_equal 'png/emoji.png', util.asset_url(:emoji, image_format: :png)
      end
    end

    describe 'if ActionController is not available' do
      before(:each) { config.asset_host = 'http://www.example.com' }

      it 'it generates the url based on the configured asset_host' do
        config.asset_path = 'assets'
        assert_equal 'http://www.example.com/assets/svg/emoji.svg', util.asset_url(:emoji)

        config.asset_path = ''
        assert_equal 'http://www.example.com/svg/emoji.svg', util.asset_url(:emoji)

        config.asset_path = '/'
        assert_equal 'http://www.example.com/svg/emoji.svg', util.asset_url(:emoji)
      end

      it 'respects the given image format' do
        assert_equal 'http://www.example.com/png/emoji.png', util.asset_url(:emoji, image_format: :png)
      end
    end
  end

  #----------------------------------------------------------------
  #                        .content_tag
  #----------------------------------------------------------------

  describe '.content_tag' do
    it 'generates a tag of the given name' do
      assert_equal '<span>foobar</span>', util.content_tag(:span, 'foobar')
    end

    it 'generates a self-closing tag if no content was given' do
      assert_equal '<br />', util.content_tag(:br)
    end

    it 'generates HTML attributes for the given options' do
      options = {src: 'img1.png', style: 'width: 64px'}
      assert_equal '<img src="img1.png" style="width: 64px" />', util.content_tag(:img, nil, **options)
    end
  end
end
