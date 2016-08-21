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
    = Source: /Users/user/src/emoji/assets
    ====================================================================
    - Creating /Users/user/src/rails-app/app/assets/images/emoji...
    - Installing assets...

## Usage

You can use this gem to replace unicode emoji characters with img tags linking to the appropriate emoji image.

Image Replacement APIs:

```ruby
> Gemojione.replace_unicode_moji_with_images('I ❤ Emoji')
=> "I <img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/assets/emoji/2764.png\"> Emoji"

> Gemojione.replace_named_moji_with_images('I :heart: Emoji')
=> "I <img alt=\"❤\" class=\"emoji\" src=\"http://localhost:3000/assets/emoji/2764.png\"> Emoji"

> Gemojione.image_url_for_unicode_moji('❤')
=> "http://localhost:3000/assets/emoji/2764.png"

> Gemojione.image_url_for_name('heart')
=> "http://localhost:3000/assets/emoji/2764.png"
```

Sprite Replacement APIs:
```ruby
Gemojione.use_sprite=true
> Gemojione.replace_unicode_moji_with_images("I ❤ Emoji")
=> "I <span class=\"emojione emojione-2764\" alt=\"❤\" title=\"❤\">❤</span> Emoji"

> Gemojione.replace_named_moji_with_images("I :heart: Emoji")
=> "I <span class=\"emojione emojione-2764\" alt=\"❤\" title=\"❤\">❤</span> Emoji"

```

Emoji Library Index APIs:

```ruby
> index = Gemojione::Index.new

> index.find_by_name('heart')

=> {"moji"=>"❤", "unicode"=>"2764", "unicode_alternates"=>["2764-FE0F"], "name"=>"heart", "shortname"=>":heart:", "category"=>"symbols", "aliases"=>[], "aliases_ascii"=>["<3"], "keywords"=>["like", "love", "red", "pink", "black", "heart", "love", "passion", "romance", "intense", "desire", "death", "evil", "cold", "valentines"], "description"=>"heavy black heart"}

> index.find_by_moji('❤')
=> {"moji"=>"❤", "unicode"=>"2764", "unicode_alternates"=>["2764-FE0F"], "name"=>"heart", "shortname"=>":heart:", "category"=>"symbols", "aliases"=>[], "aliases_ascii"=>["<3"], "keywords"=>["like", "love", "red", "pink", "black", "heart", "love", "passion", "romance", "intense", "desire", "death", "evil", "cold", "valentines"], "description"=>"heavy black heart"}

> index.find_by_keyword('teeth')
=> [{"unicode"=>"1F62C", "unicode_alternates"=>[], "name"=>"grimacing", "shortname"=>":grimacing:", "category"=>"people", "aliases"=>[], "aliases_ascii"=>[], "keywords"=>["face", "grimace", "teeth", "disapprove", "pain", "silly", "smiley", "emotion", "selfie"], "moji"=>"😬", "description"=>"grimacing face"}, {"unicode"=>"1F479", "unicode_alternates"=>[], "name"=>"japanese_ogre", "shortname"=>":japanese_ogre:", "category"=>"people", "aliases"=>[], "aliases_ascii"=>[], "keywords"=>["monster", "japanese", "oni", "demon", "troll", "ogre", "folklore", "devil", "mask", "theater", "horns", "teeth"], "moji"=>"👹", "description"=>"japanese ogre"}]
```
Default configuration integrates with Rails, but you can change it with an initializer:

```ruby
# config/initializers/gemojione.rb
Gemojione.asset_host = "emoji.cdn.com"
Gemojione.asset_path = '/assets/emoji'
Gemojione.default_size = '64px'
Gemojione.use_svg = true
Gemojione.use_sprite = true
```

You can also serve the assets directly from the gem in your rails app:

```ruby
# config/application.rb
config.assets.paths << Gemojione.images_path
config.assets.precompile << "emoji/*.png" 
# or 
config.assets.precompile << "emoji/*.svg"

#for spritesheets
config.assets.paths << Gemojione.sprites_path
config.assets.precompile << "emojione.sprites.css"
config.assets.precompile << "emojione.sprites.png"
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
=> {"moji"=>"❤", "unicode"=>"2764", "unicode_alternates"=>["2764-FE0F"], "name"=>"heart", "shortname"=>":heart:", "category"=>"symbols", "aliases"=>[], "aliases_ascii"=>["<3"], "keywords"=>["like", "love", "red", "pink", "black", "heart", "love", "passion", "romance", "intense", "desire", "death", "evil", "cold", "valentines"], "description"=>"heavy black heart"}
```

## HTML Safety and Performance

This gem uses pure ruby code for compatibility with different Ruby virtual machines.  However, there can be significant performance gains to escaping incoming HTML strings using optimized, native code in the `escape_utils` gem.

The emoji gem will try to use `escape_utils` if it's available, but does not require it.  [Benchmarks show a 10x-100x improvement](https://gist.github.com/wpeterson/c851be471bd91868716c) in HTML escaping performance, based on the size of the string being processed.

To enable native HTML escaping, add this line to your application's Gemfile:

```ruby
gem 'escape_utils'
```

## Spritesheet scaling
Default size for sprite tag is 64px x 64px, [zoom](http://caniuse.com/#feat=css-zoom) or [transform: scale()](http://caniuse.com/#feat=transforms2d) can be used for custom scaling. transform: scale() is more widely supported.
```css
.emojione{
  transform: scale(.5);
  margin: -15px;
}
```

## Contributors: :heart:

This gem is a former fork of the [emoji](https://github.com/wpeterson/emoji) gem that has been adapted for EmojiOne.

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

## Notes
run `rake resprite` to regenerate the spritesheets if you're adding new images

[travisUrl]: https://travis-ci.org/jonathanwiesel/gemojione.svg?branch=master
[travisProject]: https://travis-ci.org/jonathanwiesel/gemojione
[downs]: https://img.shields.io/gem/dt/gemojione.svg
[version]: https://img.shields.io/gem/v/gemojione.svg
[rubyUrl]: https://rubygems.org/gems/gemojione
[gemnasiumDeps]: https://img.shields.io/gemnasium/jonathanwiesel/gemojione.svg
[gemnasiumProject]: https://gemnasium.com/jonathanwiesel/gemojione
