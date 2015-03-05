require 'gemojione/version'
require 'json'

# Optionally load EscapeUtils if it's available
begin
  require 'escape_utils'
rescue LoadError
  require 'cgi'
end

require 'gemojione/index'

require "gemojione/railtie" if defined?(Rails)

module Gemojione
  @asset_host = nil
  @asset_path = nil
  @escaper = defined?(EscapeUtils) ? EscapeUtils : CGI

  def self.asset_host
    @asset_host || 'http://localhost:3000'
  end

  def self.asset_host=(host)
    @asset_host = host
  end

  def self.asset_path
    @asset_path || '/'
  end

  def self.asset_path=(path)
    @asset_path = path
  end

  def self.image_url_for_name(name)
    emoji = index.find_by_name(name)
    "#{asset_host}#{ File.join(asset_path, emoji['unicode']) }.png"
  end

  def self.image_url_for_unicode_moji(moji)
    emoji = index.find_by_moji(moji)
    image_url_for_name(emoji['name'])
  end

  def self.replace_unicode_moji_with_images(string)
    return string unless string
    unless string.match(index.unicode_moji_regex)
      return safe_string(string)
    end

    safe_string = safe_string(string.dup)
    safe_string.gsub!(index.unicode_moji_regex) do |moji|
      %Q{<img alt="#{moji}" class="emoji" src="#{ image_url_for_unicode_moji(moji) }">}
    end
    safe_string = safe_string.html_safe if safe_string.respond_to?(:html_safe)

    safe_string
  end

  def self.safe_string(string)
    if string.respond_to?(:html_safe?) && string.html_safe?
      string
    else
      escape_html(string)
    end
  end

  def self.escape_html(string)
    @escaper.escape_html(string)
  end

  def self.index
    @index ||= Index.new
  end
end
