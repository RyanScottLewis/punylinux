# TODO

## Features

* Task to check for required development dependencies
* Generate ISOLINUX image
* Sync `src/fs` into `build/`
  * Install script `src/fs/bin/install`
* Detect checksum type and use the appropriate tool (md5, sha256, sha512, etc.)
  * This could probably just be accomplished with a case statement on the checksum length
* Files can accept either an array of strings or an file/URL
* Use fakeroot?
* Configuration
  * Inital ramdisk compression enabled/type
* Create packages for libraries currently under `fs/lib/`

## Refactor

* Prepend `has_` to query methods for `Package::Struct` (`files?` to `has_files?`)
* Use system-installed syslinux instead of requiring that it be defined as a package?
  * a(ny) kernel should be the ONLY required package
* Task dependency graph should severly limit which tasks are output
  * Possibly all package install files

## Documentation

* YARDoc everywhere
* README > Usage > Package Specification - Define package DSL
* Document that a package named `linux` must be defined

