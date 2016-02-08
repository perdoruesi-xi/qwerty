# Qwerty

Add Ons

Several add-ons are available that adjust the project structure to add support for things like i18n, code metrics, Heroku, etc. Run ```hoboken``` help from the command line for a complete list.

## Getting Started

Run the bundle command

```bundle install```

After you bundle Gemfile, you need to run the generator:

``` thor section Draw```

Replace Draw with the class name. 

The generator will create a new section class. The above code will put the following line into ```lib/qwerty/draw.rb```:

```ruby
# lib/qwerty/draw.rb
require "ruote"

module Qwerty
  class Draw < Ruote::Participant
    def on_workitem
      workitem.fields['draw'] = {
        :key => 'value'
      }
      reply # Work done, let flow resume
    end
  end
end
```

Adds a section to app.rb directly after the conveyor block.
```ruby
section(:draw)
```

We can see that by invoking the description of this new generator
``` 
thor help section 
```

```
Usage:
  thor section NAME

Options:
  -s, [--subclass=SUBCLASS]
      [--test-framework=TEST_FRAMEWORK]
                                         # Default: test_unit
```

--subclass=SUBCLASS - Specify an subclass for this section. If you wish to use this option the recommended command is as follows

``` thor section Draw --subclass Image```

Places a file into lib which contains the specified code.

```ruby
# lib/qwerty/image/draw.rb
require "ruote"

module Qwerty
	class Image
	  class Draw < Ruote::Participant
	    def on_workitem
	      workitem.fields['image']['draw'] = {
	        :key => 'value'
	      }
	      reply # Work done, let flow resume
	    end
	  end
	end
end
```
Injects a block of code into /app.rb
```ruby
section(:image) do
  action(:draw)
end
```

Start the development server
```rake server``` 

### Project Layout
```
.
├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── app.rb
├── config.ru
├── lib
│   ├── qwerty
│   │   ├── assembly.rb
│   │   ├── source.rb
│   │   └── workflow.rb
│   └── qwerty.rb
├── section.thor
├── public
│   ├── css
│   │   └── styles.css
│   ├── img
│   │   ├── favicon.png
│   │   └── sinatra.png
│   └── js
│       └── app.js
├── templates
│   ├── section.tt
│   └── action.tt
├── test
│   ├── integration
│   ├── support
│   │   └── rack_test_assertions.rb
│   ├── test_helper.rb
│   └── unit
│       └── app_test.rb
└── views
    ├── index.erb
    └── layout.erb

12 directories, 23 files
```
## Notes / Use

## Contributing

### Issues / Roadmap

Use GitHub issues for reporting bug and feature requests.

### Patches / Pull Requests
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don’t break it in a future version
  unintentionally.
* Commit, do not mess with Rakefile, version, or history (if you want to have
  your own version, that is fine but bump version in a commit by itself I can
  ignore when I pull).
* Send me a pull request. Bonus points for topic branches.

## License
(The MIT License)

Copyright (c) 2015 Korab Hoxha

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
