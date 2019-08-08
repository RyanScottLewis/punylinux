# PunyLinux

Build automation (powered by Ruby & Rake) for a very minimal Linux system.

* Package Management
  * Aquire package sources (packages defined with DSL in files within `pkg/`)
    * Optionally verify package checksum
      * Download/Write the checksum to file
      * Verify with `sha256sum`
    * Optionally verify package sources by signature
      * Download/Write the signature to file
      * Verify with `gpg`
  * Decompress package sources
  * Build package sources
  * Install packages
* Image Management
  * Generate ISOLINUX image
  * Generate SYSLINUX image (?)

## Install

* Clone this project
* Install dependencies
* Change into the project directory
* Run `rake`

### Dependencies

* Ruby (tested on ruby 2.6.3p62)
* cUrl
* tar

#### Build Automation

You must install any development dependencies required to build all packages, such as:

* make
* cmake
* ninja
* meson
* etc.

#### Compressors

Since we are simply using `tar -xf` to decompress archives, simply install any compressor you would
like to support:

* gzip
* xz
* etc.

#### Image Generation

* syslinux
* cdrkit

## Usage

Define any packages you would like to include within `pkg/` and run `rake`.  
All package sources will be aquired, optionally checksummed and verified by signature.  
Each package will then be built and installed into the `build/` directory.

### Tasks

```
rake build       # Build all package sources
rake check       # Verify checksum on all package sources
rake clean       # Remove any temporary products
rake clobber     # Remove any generated files
rake decompress  # Decompress all package sources
rake default     # See: package
rake download    # Download all package sources
rake list        # List all paths & packages
rake package     # Install all package builds
rake verify      # Verify signature on all package sources
```

