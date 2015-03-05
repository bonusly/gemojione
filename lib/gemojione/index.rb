module Gemojione
  class Index
    def initialize(emoji_list=nil)
      emoji_list ||= begin
        emoji_json = File.read(File.absolute_path(File.dirname(__FILE__) + '/../../config/index.json'))
        JSON.parse(emoji_json)
      end

      @emoji_by_name = {}
      @emoji_by_moji = {}

      emoji_list.each do |key, emoji_hash|

        emoji_hash["description"] = emoji_hash["name"]
        emoji_hash["name"] = key
        @emoji_by_name[key] = emoji_hash if key

        emoji_hash["aliases"].each do |emoji_alias|
          aliased = emoji_alias.tr(':','')
          @emoji_by_name[aliased] = emoji_hash if aliased
        end

        moji = emoji_hash['moji']
        @emoji_by_moji[moji] = emoji_hash if moji
      end
      @emoji_moji_regex = /#{@emoji_by_moji.keys.join('|')}/
    end

    def find_by_moji(moji)
      @emoji_by_moji[moji]
    end

    def find_by_name(name)
      @emoji_by_name[name]
    end

    def unicode_moji_regex
      @emoji_moji_regex
    end
  end
end
