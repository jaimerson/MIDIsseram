MIDIsseram
----------

## Setup
Install ruby = 2.2.3, if you haven't already (rvm.io);

```
gem install bundler
bundle install
```

## Running

```
ruby modify_harmony.rb
ruby modify_harmony.rb 5 && timidity output/altered.mid -Ow -o - | lame - -b 64 converted/altered.mp3
```

