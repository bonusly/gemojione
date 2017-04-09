class String
  #
  # @return [String] +self+ with all unicode emoji replaced with HTML tags
  #
  # @see Gemojione.replace_unicode_moji_with_images for information about the available options
  #
  def with_emoji_from_unicode(**options)
    Gemojione.replace_unicode_moji_with_images(self, **options)
  end

  #
  # @return [String] +self+ with all named emoji (:heart) replaced with HTML tags
  #
  # @see Gemojione.replace_named_moji_with_images for information about the available options
  #
  def with_emoji_from_names(**options)
    Gemojione.replace_named_moji_with_images(self, **options)
  end

  #
  # @return [String] assuming that +self+ is either a unicode or named emoji, this
  #   method returns the URL to its image file.
  #
  # @see Gemojione.image_url_for_name for information about the available options
  #
  def emoji_image_url(**options)
    @emoji_data ||= Gemojione.index.find_by_moji(self) || Gemojione.index.find_by_name(self)
    Gemojione.image_url_for_name(@emoji_data['name'], **options)
  end
end
