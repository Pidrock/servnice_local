# ImgixLocal

Run a local imgix instance, so you can have scalable images available without being online.

## Installation

Add this line to your application's Gemfile:

    gem 'imgix_local'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install imgix_local

## Requirements

You need to have ImageMagick (or GraphicsMagick) installed, on OSX you can install it with Homebrew (http://brew.sh/):

```
brew install imagemagick graphicsmagick
```

If you are using something more exotic consult your documentation, or ping me.

## Usage

To start the server after installation you type:

```
bundle exec imgix_server
```

The server will listen on port `9384`, if you want to change that you can set the `PORT` environment-variable:

```
PORT=4567 bundle exec imgix_server
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/imgix_local/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
