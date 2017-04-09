# encoding: UTF-8

require File.absolute_path File.dirname(__FILE__) + '/test_helper'
require 'gemojione/string_ext'

describe String, 'with Emoji extensions' do
  describe '#with_emoji_from_unicode' do
    it 'should replace unicode moji with the requested type of HTML tag' do
      string = "I #{UNIMOJI[:heart]} Emoji"
      replaced_string = string.with_emoji_from_unicode(use_sprites: false, image_format: :svg)
      assert_match /I <img.*src=".*2764\.svg".* Emoji/, replaced_string

      replaced_string = string.with_emoji_from_unicode(use_sprites: false, image_format: :png)
      assert_match /I <img.*src=".*2764\.png".* Emoji/, replaced_string

      replaced_string = string.with_emoji_from_unicode(use_sprites: true)
      assert_match /I <span.*class="emojione emojione-2764".* Emoji/, replaced_string
    end
  end

  describe '#with_emoji_from_names' do
    it 'should replace named moji with the requested type of HTML tag' do
      string = 'I :heart: Emoji'
      replaced_string = string.with_emoji_from_names(use_sprites: false, image_format: :svg)
      assert_match /I <img.*src=".*2764\.svg".* Emoji/, replaced_string

      replaced_string = string.with_emoji_from_names(use_sprites: false, image_format: :png)
      assert_match /I <img.*src=".*2764\.png".* Emoji/, replaced_string

      replaced_string = string.with_emoji_from_names(use_sprites: true)
      assert_match /I <span.*class="emojione emojione-2764".* Emoji/, replaced_string
    end
  end

  describe '#emoji_image_url' do
    it 'should return the image url for the emoji' do
      assert_equal 'http://localhost:3000/svg/1F300.svg', UNIMOJI[:cyclone].emoji_image_url(image_format: :svg)
      assert_equal 'http://localhost:3000/png/1F300.png', UNIMOJI[:cyclone].emoji_image_url(image_format: :png)
      assert_equal 'http://localhost:3000/svg/1F300.svg', 'cyclone'.emoji_image_url(image_format: :svg)
      assert_equal 'http://localhost:3000/png/1F300.png', 'cyclone'.emoji_image_url(image_format: :png)
    end
  end
end
