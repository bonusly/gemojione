# encoding: UTF-8

require File.absolute_path File.dirname(__FILE__) + '/test_helper'

describe Gemojione do
  describe "image_url_for_name" do
    it 'should generate url' do
      assert_equal 'http://localhost:3000/1F300.png', Gemojione.image_url_for_name('cyclone')
    end

    it 'should generate url' do
      assert_equal 'http://localhost:3000/1F44D.png', Gemojione.image_url_for_name('+1')
    end
  end

  describe "image_url_for_unicode_moji" do
    it 'should generate url' do
      assert_equal 'http://localhost:3000/1F300.png', Gemojione.image_url_for_unicode_moji('🌀')
    end
  end

  describe "asset_host" do
    it 'should default to localhost' do
      assert_equal 'http://localhost:3000', Gemojione.asset_host
    end

    it 'should be configurable' do
      with_emoji_config(:asset_host, 'emoji') do
        assert_equal 'emoji', Gemojione.asset_host
      end
    end
  end

  describe "asset_path" do
    it 'should default to /' do
      assert_equal '/', Gemojione.asset_path
    end

    it 'should be configurable' do
      with_emoji_config(:asset_path, '/emoji') do
        assert_equal '/emoji', Gemojione.asset_path
      end
    end
  end

  describe 'default size' do
    it 'should default to nil' do
      assert_equal nil, Gemojione.default_size
    end

    it 'should be configurable' do
      with_emoji_config(:default_size, '32px') do
        assert_equal '32px', Gemojione.default_size
      end
    end
  end

  describe 'image_tag_for_moji' do
    it 'should generate a clean img tag if default_size undefined' do
      assert_equal '<img alt="🌀" class="emoji" src="http://localhost:3000/1F300.png">', Gemojione.image_tag_for_moji('🌀')
    end

    it 'should generate a img tag with style tag if default_size is defined' do
      Gemojione.default_size='42px'
      assert_equal '<img alt="🌀" class="emoji" src="http://localhost:3000/1F300.png" style="width: 42px;">', Gemojione.image_tag_for_moji('🌀')
      Gemojione.default_size=nil
    end
  end

  describe "replace_unicode_moji_with_images" do
    it 'should return original string without emoji' do
      assert_equal "foo", Gemojione.replace_unicode_moji_with_images('foo')
    end

    it 'should escape html in non html_safe aware strings' do
      replaced_string = Gemojione.replace_unicode_moji_with_images('❤<script>')
      assert_equal "<img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/2764.png\">&lt;script&gt;", replaced_string
    end

    it 'should replace unicode moji with img tag' do
      base_string = "I ❤ Emoji"
      replaced_string = Gemojione.replace_unicode_moji_with_images(base_string)
      assert_equal "I <img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/2764.png\"> Emoji", replaced_string
    end

    it 'should escape regex breaker mojis' do
      assert_equal "<img alt=\"*⃣\" class=\"emoji\" src=\"http://localhost:3000/002A-20E3.png\">", Gemojione.replace_unicode_moji_with_images('*⃣')
    end

    it 'should handle nil string' do
      assert_equal nil, Gemojione.replace_unicode_moji_with_images(nil)
    end

    describe 'with html_safe buffer' do
      it 'should escape non html_safe? strings in emoji' do
        string = HtmlSafeString.new('❤<script>')

        replaced_string = string.stub(:html_safe?, false) do
          Gemojione.replace_unicode_moji_with_images(string)
        end

        assert_equal "<img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/2764.png\">&lt;script&gt;", replaced_string
      end

      it 'should escape non html_safe? strings in all strings' do
        string = HtmlSafeString.new('XSS<script>')

        replaced_string = string.stub(:html_safe?, false) do
          Gemojione.replace_unicode_moji_with_images(string)
        end

        assert_equal "XSS&lt;script&gt;", replaced_string
      end

      it 'should not escape html_safe strings' do
        string = HtmlSafeString.new('❤<a href="harmless">')

        replaced_string = string.stub(:html_safe?, true) do
          Gemojione.replace_unicode_moji_with_images(string)
        end

        assert_equal "<img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/2764.png\"><a href=\"harmless\">", replaced_string
      end

      it 'should always return an html_safe string for emoji' do
        string = HtmlSafeString.new('❤')
        replaced_string = string.stub(:html_safe, 'safe_buffer') do
           Gemojione.replace_unicode_moji_with_images(string)
        end

        assert_equal "safe_buffer", replaced_string
      end

      it 'should always return an html_safe string for any string' do
        string = HtmlSafeString.new('Content')
        replaced_string = string.stub(:html_safe, 'safe_buffer') do
           Gemojione.replace_unicode_moji_with_images(string)
        end

        assert_equal "Content", replaced_string
      end
    end
  end

  describe 'replace_named_moji_with_images' do

    it 'should return original string without emoji' do
      assert_equal 'foo', Gemojione.replace_named_moji_with_images('foo')
    end

    it 'should escape html in non html_safe aware strings' do
      replaced_string = Gemojione.replace_named_moji_with_images(':heart:<script>')
      assert_equal "<img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/2764.png\">&lt;script&gt;", replaced_string
    end

    it 'should replace coded moji with img tag' do
      base_string = "I :heart: Emoji"
      replaced_string = Gemojione.replace_named_moji_with_images(base_string)
      assert_equal "I <img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/2764.png\"> Emoji", replaced_string
    end

    it 'should handle nil string' do
      assert_equal nil, Gemojione.replace_named_moji_with_images(nil)
    end

    describe 'with html_safe buffer' do
      it 'should escape non html_safe? strings in emoji' do
        string = HtmlSafeString.new(':heart:<script>')

        replaced_string = string.stub(:html_safe?, false) do
          Gemojione.replace_named_moji_with_images(string)
        end

        assert_equal "<img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/2764.png\">&lt;script&gt;", replaced_string
      end

      it 'should escape non html_safe? strings in all strings' do
        string = HtmlSafeString.new('XSS<script>')

        replaced_string = string.stub(:html_safe?, false) do
          Gemojione.replace_named_moji_with_images(string)
        end

        assert_equal "XSS&lt;script&gt;", replaced_string
      end

      it 'should not escape html_safe strings' do
        string = HtmlSafeString.new(':heart:<a href="harmless">')

        replaced_string = string.stub(:html_safe?, true) do
          Gemojione.replace_named_moji_with_images(string)
        end

        assert_equal "<img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/2764.png\"><a href=\"harmless\">", replaced_string
      end

      it 'should always return an html_safe string for emoji' do
        string = HtmlSafeString.new(':heart:')
        replaced_string = string.stub(:html_safe, 'safe_buffer') do
          Gemojione.replace_named_moji_with_images(string)
        end

        assert_equal "safe_buffer", replaced_string
      end

      it 'should always return an html_safe string for any string' do
        string = HtmlSafeString.new('Content')
        replaced_string = string.stub(:html_safe, 'safe_buffer') do
          Gemojione.replace_named_moji_with_images(string)
        end

        assert_equal "Content", replaced_string
      end
    end
  end

  class HtmlSafeString < String
    def initialize(*); super; end
    def html_safe; self; end
    def html_safe?; true; end
    def dup; self; end
  end

  def with_emoji_config(name, value)
    original_value = Gemojione.send(name)
    begin
      Gemojione.send("#{name}=", value)
      yield
    ensure
      Gemojione.send("#{name}=", original_value)
    end
  end
end
