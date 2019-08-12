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

## Documentation

* YARDoc everywhere
* README > Usage > Package Specification - Define package DSL
* Document that a package named `linux` must be defined

