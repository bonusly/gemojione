module Gemojione
  class Index
    def initialize(emoji_list = nil)
      emoji_list ||= begin
        emoji_json = File.read(File.absolute_path(File.dirname(__FILE__) + '/../../config/index.json'))
        JSON.parse(emoji_json)
      end

      @emoji_by_name    = {}
      @emoji_by_moji    = {}
      @emoji_by_ascii   = {}
      @emoji_by_code    = {}
      @emoji_by_keyword = {}

      emoji_list.each do |key, emoji_hash|

        emoji_hash['description'] = emoji_hash['name']
        emoji_hash['name']        = key
        @emoji_by_name[key]       = emoji_hash if key

        emoji_hash['aliases'].each do |emoji_alias|
          aliased                     = emoji_alias.tr(':', '')
          @emoji_by_name[aliased]     = emoji_hash if aliased
          @emoji_by_code[emoji_alias] = emoji_hash if aliased
        end

        emoji_hash['aliases_ascii'].each do |emoji_ascii|
          @emoji_by_ascii[emoji_ascii] = emoji_hash if emoji_ascii
        end

        code                 = emoji_hash['shortname']
        @emoji_by_code[code] = emoji_hash if code

        moji                 = emoji_hash['moji']
        @emoji_by_moji[moji] = emoji_hash if moji

        emoji_hash['keywords'].each do |emoji_keyword|
          @emoji_by_keyword[emoji_keyword] ||= []
          @emoji_by_keyword[emoji_keyword] << emoji_hash
        end
      end

      @regexps = {
          code:    /#{@emoji_by_code.keys.map { |ec| Regexp.escape(ec) }.join('|')}/,
          unicode: /#{@emoji_by_moji.keys.map { |ec| Regexp.escape(ec) }.join('|')}/,
          ascii:   /#{@emoji_by_ascii.keys.map { |ec| Regexp.escape(ec) }.join('|')}/
      }
    end

    def find_by_moji(moji)
      @emoji_by_moji[moji]
    end

    def find_by_name(name)
      @emoji_by_name[name]
    end

    def find_by_ascii(ascii)
      @emoji_by_ascii[ascii]
    end

    def find_by_keyword(keyword)
      @emoji_by_keyword[keyword]
    end

    def find_by_shortname(shortname)
      @emoji_by_code[shortname]
    end

    attr_reader :regexps
  end
end
