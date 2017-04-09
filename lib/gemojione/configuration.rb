module Gemojione
  class Configuration
    AVAILABLE_FORMATS = %i(svg png)

    def default_format
      @default_format || :svg
    end

    #
    # Sets the default format for generated emoji image tags.
    #
    # Available options are:
    #   - :svg
    #   - :png
    #
    def default_format=(format)
      @default_format = format.to_sym if AVAILABLE_FORMATS.include?(format.to_sym)
    end

    def use_sprites?
      !!@use_sprites
    end

    #
    # @param [Boolean] bool
    #   if set to +true+, most gemojione helpers
    #   will use CSS class names to replace emoji codes instead of image tags
    #
    attr_writer :use_sprites

    def asset_host
      @asset_host || 'http://localhost:3000'
    end

    attr_writer :asset_host

    def asset_path
      @asset_path || '/'
    end

    attr_writer :asset_path
    attr_accessor :default_size

    def escaper
      @escaper ||= defined?(EscapeUtils) ? EscapeUtils : CGI
    end
  end
end