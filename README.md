# vup

Bumpup version

[![Build Status](https://travis-ci.org/tbpgr/vup.png?branch=master)](https://travis-ci.org/tbpgr/vup)
[![badge](https://img.shields.io/badge/shards-v0.4.0-brightgreen.svg)](https://github.com/tbpgr/homebrew-vup)

## Installation

```bash
$ brew tap tbpgr/vup
$ brew install vup
```

## Usage
### show
```bash
$ cat shard.yml
name: hoge
version: 0.1.2
$ vup --show
0.1.2
```

### version up (patch)
```bash
$ cat shard.yml
name: hoge
version: 0.1.2
$ cat ./src/hoge/version.cr
module Hoge
  VERSION = "0.1.2"
end

$ vup --patch

$ cat shard.yml
name: hoge
version: 0.1.3
$ cat ./src/hoge/version.cr
module Hoge
  VERSION = "0.1.3"
end
```
### version up (minor)
```bash
$ cat shard.yml
name: hoge
version: 0.1.2
$ cat ./src/hoge/version.cr
module Hoge
  VERSION = "0.1.2"
end

$ vup --minor

$ cat shard.yml
name: hoge
version: 0.2.0
$ cat ./src/hoge/version.cr
module Hoge
  VERSION = "0.2.0"
end
```

### version up (major)
```bash
$ cat shard.yml
name: hoge
version: 0.1.2
$ cat ./src/hoge/version.cr
module Hoge
  VERSION = "0.1.2"
end

$ vup --major

$ cat shard.yml
name: hoge
version: 1.0.0
$ cat ./src/hoge/version.cr
module Hoge
  VERSION = "1.0.0"
end
```

## Development
### Rake
```bash
$ rake -T
rake build:debug    # build (debug mode)
rake build:release  # build (release mode)
rake release        # release latest package
```

## Contributing

1. Fork it ( https://github.com/tbpgr/vup/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tbpgr](https://github.com/tbpgr) tbpgr - creator, maintainer
