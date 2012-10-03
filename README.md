pointhq-updater
===============

Automatically updates Point HQ A-records.

## Usage:
Simply run `ruby updater.rb` and enter your `username` and `apitoken`, then select which zone/record you wish to perform updates on. The script will generate a `config.yml` in the working directory which will save all this information for next time you run (i.e. via `cron`). If you wish to change zone/record run `ruby updater.rb --update`.

## Credits
Uses the [point](https://rubygems.org/gems/point) gem by Adam Cooke, as well as [highline](https://rubygems.org/gems/highline) for IO.

## Notes
This (like most things I make) is pretty rough around the edges. I wrote this for quite a specific use case, please feel free to fork/tidy/fix/add etc. etc. :)