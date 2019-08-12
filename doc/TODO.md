# TODO

## Features

* Task to check for required development dependencies
* Detect checksum type and use the appropriate tool (md5, sha256, sha512, etc.)
  * This could probably just be accomplished with a case statement on the checksum length
* Files can accept either an array of strings or an file/URL
* Configuration
  * Inital ramdisk compression enabled/type

## Refactor

* Prepend `has_` to query methods for `Package::Struct` (`files?` to `has_files?`)
* Task dependency graph should severly limit which tasks are output
  * Possibly all package install files
* Rename `build/root/` to `build/os/`
* Package tasks depend on the package specification
* Dir structure
  build/root/ => build/root/linux/
  build/iso/  => build/root/iso/

## Documentation

* YARDoc everywhere
* README > Usage > Package Specification - Define package DSL
* Document that a package named `linux` must be defined

