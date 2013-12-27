# Faraday::Adapter::NetHttpProgressBar

## Installation

    $ git clone https://github.com/Manbo-/faraday-adapter-net_http_progress_bar.git
    $ cd ./faraday-adapter-net_http_progress_bar
    $ rake install
    
## Usage

    require "faraday"
    require "faraday/adapter/net_http_progress_bar"
    
    connection = Faraday.new do |builder|
      builder.adapter :net_http_progress_bar
    end
    
    connection.get("http://www.ruby-lang.org/")

http://www.ruby-lang.org/: |===============================| 100% 833/833 Time: 00:00:00

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
