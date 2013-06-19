# LinkPreview

Link preview feature find open graph or normal meta tags.

## Installation

Add this line to your application's Gemfile:

    gem 'link-preview'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install link-preview

## Usage

```ruby
   page = LinkPreview::Page.new('http://globoesporte.globo.com/futebol/times/corinthians/noticia/2013/06/sheik-cobra-responsabilidade-dos-companheiros-durante-folga.html')

   page.parse!

   # Return the title of the page
   #
   page.title

   # Return the description of the page.
   #
   page.description

   # Return all images from page
   #
   page.images

   # Return the favicon link
   #
   page.favicon

   # Return the uri
   #
   page.uri
```

Obs.: The Page class is compatible with Active Model Serializers, :).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
