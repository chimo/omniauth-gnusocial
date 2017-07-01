# OmniAuth GNU social

This gem contains the GNU social strategy for OmniAuth.

## Before You Begin

You should have already installed OmniAuth into your app; if not, read the [OmniAuth README](https://github.com/intridea/omniauth) to get started.

Now sign in into the "Connected application" area of your GNU social instance ("Settings > Connections > Register an OAuth application") and create an application. Take note of your "Consumer Key" and "Consumer Secret" because that is what your web application will use to authenticate against the GNU social API.

## Using This Strategy

First start by adding this gem to your Gemfile:

```ruby
gem 'omniauth-gnusocial', :github => 'chimo/omniauth-gnusocial'
```

Next, tell OmniAuth about this provider. For a Rails app, your `config/initializers/omniauth.rb` file should look like this:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :gnusocial, "CONSUMER_KEY", "CONSUMER_SECRET", {server: "SERVER", use_authorize: true}
end
```

Replace `"CONSUMER_KEY"` and `"CONSUMER_SECRET"` with the appropriate values you obtained earlier.  
Replace `"SERVER"` with the URL to your GNU social instance.

## License

Copyright (c) 2011 by Arun Agrawal

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
