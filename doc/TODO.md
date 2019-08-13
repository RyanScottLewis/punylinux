# TODO

* Specs

## Features

* Task to check for required development dependencies
* Detect checksum type and use the appropriate tool (md5, sha256, sha512, etc.)
  * This could probably just be accomplished with a case statement on the checksum length
* Files can accept either an array of strings or an file/URL
* Configuration
  * Inital ramdisk compression enabled/type
* Squashfs or cramfs
* `var/log/` and log each build as well as each package build within `var/log/PKG/std{out,err}.log`

## Refactor

* Prepend `has_` to query methods for `Package::Struct` (`files?` to `has_files?`)
* Task dependency graph should severly limit which tasks are output
  * Possibly all package install files
* Package tasks depend on the package specification
* Make hybrid ISO - mkhybrid or isohybrid
* ISOLINUX
  * Generate `src/isolinux/isolinux.cfg`
  * Copy all files from `src/isolinux` into iso root
* Rename
  * `fs/...`           => `fs/os/...`
  * `src/isolinux/...` => `fs/iso/...`
* Move frontend functionality to concerns (see shoestring's Rakefile)
* Move backend functionality to middleware
  * Works like Rack middleware: 

  ```rb
  class StripBinaries

    def self.call(package)
      new.call(package)
    end

    def initialize(options={})
      @options = {
        command: 'strip --strip-all',
        pattern: %r{/s?bin/}
      }.merge(options)
    end

    def call(package)
      package.install_paths.select { |path| path.to_s =~ @options[:pattern] }.each do |path|
        sh "#{@options[:command]} '#{path}'"
      end
    end

  end

  package.on_install << StripBinaries
  ```

## Documentation

* YARDoc everywhere
* README > Usage > Package Specification - Define package DSL
* Document that a package named `linux` must be defined

