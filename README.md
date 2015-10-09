# Gemojione

[![Build Status][travisUrl]][travisProject] [![Downloads][downs]][rubyUrl] [![Version][version]][rubyUrl] [![Dependencies][gemnasiumDeps]][gemnasiumProject]

A gem for EmojiOne

This gem exposes the [emojione](http://emojione.com/) unicode/image assets and APIs for working with them.

Easily lookup emoji name, unicode character, or image assets and convert emoji representations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gemojione'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gemojione

Install emoji image library assets:

    $ rake gemojione:install_assets
    ====================================================================
    = emoji image assets install
    = Target: /Users/user/src/rails-app/app/assets/images/emoji
    = Source: /Users/user/src/emoji/assets/images
    ====================================================================
    - Creating /Users/user/src/rails-app/app/assets/images/emoji...
    - Installing assets...

## Usage

You can use this gem to replace unicode emoji characters with img tags linking to the appropriate emoji image.

Image Replacement APIs:

```ruby
> Gemojione.replace_unicode_moji_with_images('I ❤ Emoji')
=> "I <img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/assets/emoji/2764.png\"> Emoji"

> Gemojione.image_url_for_unicode_moji('❤')
=> "http://localhost:3000/assets/emoji/2764.png"

> Gemojione.image_url_for_name('heart')
=> "http://localhost:3000/assets/emoji/2764.png"
```

Emoji Library Index APIs:

```ruby
> index = Gemojione::Index.new

> index.find_by_name('heart')

=> {"moji"=>"❤", "unicode"=>"2764", "unicode_alternates"=>["2764-FE0F"], "name"=>"heart", "shortname"=>":heart:", "category"=>"emoticons", "aliases"=>[], "aliases_ascii"=>["<3"], "keywords"=>["like", "love", "red", "pink", "black", "heart", "love", "passion", "romance", "intense", "desire", "death", "evil", "cold", "valentines"], "description"=>"heavy black heart"}

> index.find_by_moji('❤')
=> {"moji"=>"❤", "unicode"=>"2764", "unicode_alternates"=>["2764-FE0F"], "name"=>"heart", "shortname"=>":heart:", "category"=>"emoticons", "aliases"=>[], "aliases_ascii"=>["<3"], "keywords"=>["like", "love", "red", "pink", "black", "heart", "love", "passion", "romance", "intense", "desire", "death", "evil", "cold", "valentines"], "description"=>"heavy black heart"}
```
Default configuration integrates with Rails, but you can change it with an initializer:

```ruby
# config/initializers/gemojione.rb
Gemojione.asset_host = "emoji.cdn.com"
Gemojione.asset_path = '/assets/emoji'
```

String Helper Methods:

You can also

```ruby
include 'gemojione/string_ext'
```

and call methods directly on your string to return the same results:

```ruby
> 'I ❤ Emoji'.with_emoji_images
=> "I <img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/assets/emoji/2764.png\"> Emoji"

> 'heart'.image_url
> '❤'.image_url
=> "http://localhost:3000/assets/emoji/2764.png"

> 'heart'.emoji_data
> '❤'.emoji_data
=> {"moji"=>"❤", "unicode"=>"2764", "unicode_alternates"=>["2764-FE0F"], "name"=>"heart", "shortname"=>":heart:", "category"=>"emoticons", "aliases"=>[], "aliases_ascii"=>["<3"], "keywords"=>["like", "love", "red", "pink", "black", "heart", "love", "passion", "romance", "intense", "desire", "death", "evil", "cold", "valentines"], "description"=>"heavy black heart"}
```

## HTML Safety and Performance

This gem uses pure ruby code for compatibility with different Ruby virtual machines.  However, there can be significant performance gains to escaping incoming HTML strings using optimized, native code in the `escape_utils` gem.

The emoji gem will try to use `escape_utils` if it's available, but does not require it.  [Benchmarks show a 10x-100x improvement](https://gist.github.com/wpeterson/c851be471bd91868716c) in HTML escaping performance, based on the size of the string being processed.

To enable native HTML escaping, add this line to your application's Gemfile:

```ruby
gem 'escape_utils'
```
## Contributors: :heart:

* [@ryan-orr](https://github.com/ryan-orr): Granted the official `emoji` rubygems account
* [@mikowitz](https://github.com/mikowitz): `String` ext helpers
* [@semanticart](https://github.com/semanticart): Cleanup/Ruby 1.9.3 support
* [@parndt](https://github.com/parndt): README doc fixes
* [@neuegram](https://github.com/neuegram): XSS Security Audit
* [@jonathanwiesel](https://github.com/jonathanwiesel): Emojione support

## Contributing

1. Fork it
2. Bundle Install (`bundle install`)
3. Run the Tests (`rake test`)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[travisUrl]: https://travis-ci.org/jonathanwiesel/gemojione.svg?branch=master
[travisProject]: https://travis-ci.org/jonathanwiesel/gemojione
[downs]: https://img.shields.io/gem/dt/gemojione.svg
[version]: https://img.shields.io/gem/v/gemojione.svg
[rubyUrl]: https://rubygems.org/gems/gemojione
[gemnasiumDeps]: https://img.shields.io/gemnasium/jonathanwiesel/gemojione.svg
[gemnasiumProject]: https://gemnasium.com/jonathanwiesel/gemojione
