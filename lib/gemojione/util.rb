require 'open-uri'

module Gemojione
  module Util
    #
    # Generates a HTML tag
    #
    # @param [#to_s] tag
    #   The tag to be generated, e.g. :img or :span
    #
    # @param [#to_s] content
    #   The tag's innerHTML. If not given, the generated tag will be
    #   self-closing (yes, this does not cover every possible combination, but will
    #   work for all tags used in this gem)
    #
    # @param [Hash] attributes
    #   Attributes to be added to the generated tag
    #
    # @return [String]
    #
    # @example Generate an image tag with a custom style attribute
    #   Gemojione::Util.content_tag :img, nil, style: 'width: 32px', src: 'img.png'
    #   #=> <img src="img.png" style="width: 32px" />
    #
    def self.content_tag(tag, content = nil, **attributes)
      attribute_string = attributes.map { |k, v| %(#{k}="#{v}") if v }.compact.join(' ')
      attribute_string = ' ' + attribute_string unless attribute_string.empty?
      return %(<#{tag}#{attribute_string}>#{content}</#{tag}>) if content
      %(<#{tag}#{attribute_string} />)
    end

    #
    # Builds the URL to a gemojione asset.
    # If +ApplicationController+ is available, its +.helpers+ proxy is used,
    # otherwise, the URL is generated using the configured +asset_host+ and +asset_path+
    #
    # @param [String] name
    #   The emoji name in its unicode hex format
    #
    # @param [String, Symbol] image_format
    #   Either +svg+ or +png+, defaults to the +default_format+ set in the configuration
    #
    def self.asset_url(name, image_format: ::Gemojione.configuration.default_format)
      asset_host = ::Gemojione.configuration.asset_host.to_s
      asset_path = ::Gemojione.configuration.asset_path.to_s
      image_path = "#{image_format}/#{name}.#{image_format}"
      components = [asset_path.split('/'), image_path.split('/')].compact.reject(&:empty?)

      if defined?(ApplicationController)
        ApplicationController.helpers.asset_url(components.join('/'))
      else
        components.unshift(asset_host)
        components.join('/')
      end
    end
  end
end
