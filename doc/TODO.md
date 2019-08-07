# TODO

* Features
  * Detect checksum type and use the appropriate tool (md5, sha256, sha512, etc.)
    * This could probably just be accomplished with a case statement on the checksum length
  * Detect file path (`file://` URI) and load the file for sources (archive, checksum, signature)
    * If path is relative like one of the following, it is relative to the package's path (`package.path` or `package.specification_path`)
      * `file://foobar.tar`
      * `file://./foobar.tar`
* Remove
  * Remove `read` from  `lib/path/import.rb`
* Rename
  * Prepend `has_` to query methods for `Package::Struct` (`files?` to `has_files?`)
* Refactor
  * Load files with `**/*` for loading packages
  * Whole object model is screwy
    * `Path` wraps `Pathname` which wraps `Pathname`
    * The `so-and-so/import` files feel gross
  * Class method for defining `Pathname` delegates on `Path::Struct`

