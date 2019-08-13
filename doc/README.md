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
  * Generate LINUX image
  * Generate ISOLINUX image

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

### Tasks

View all tasks with:

```
rake -T
```

To view every single file to be generated, use:

```
rake -T -A
```

### Package Management

Define any packages you would like to include within `pkg/` and run `rake pkg`.  
All package sources will be aquired, optionally checksummed and verified by signature.  
Each package will then be built and installed into the `build/root/os/` directory.

Packages are defined similarly to Rake files; within it's own Ruby DSL:

```rb
name      :package_name                                   # Package name
version   '1.2.3'                                         # Package version
archive   "https://example.org/#{name}-#{version}.tar.gz" # Archive source
signature "#{archive}.sig"                                # GPG signature source
checksum  "#{archive}.sha256"                             # Checksum source
files     %W(/bin/#{name} /etc/#{name}/config)            # Package install files


# on_check { |package| ... }                              # Callback to check this package's checksum
# on_verify { |package| ... }                             # Callback to verify this package's signature

on_build do |package|                                     # Callback to build this package
  sh <<~EOS
    cd '#{package.build_path}'
    ./configure
    make
  EOS
end

on_install do |package|                                   # Callback to install this package
  sh <<~EOS
    cd '#{package.build_path}'
    make DESTDIR'#{paths.os_root}' install
  EOS
end
```

#### Sources

Sources given for `archive`, `signature`, and `checksum` can be URI's or the contents of the source. 
Paths can be given with the `file://` URI scheme.

#### Callbacks

When callbacks are not defined on a package they will not be run, with the exception of `on_check`
and `on_verify`. These are only called if their respective sources are also defined in the
specification. If they are defined, they are called *instead* of the default functionality.

#### Required Properties

The only required properties are `name`, `version`, and `archive`.

If there is an `on_install` callback defined, it is highly advised to properly define the `files`
list, as this is what hooks the package into the Rake task dependency graph.

The list of `files` defined on the package are the paths that will be installed onto a system when
the package is installed, relative to the system (i.e. root - `/`).

#### Linux Package

Only one package is required and it must be named `linux` and it must generate the following kernel:

```
build/root/os/boot/vmlinuz
```

### Image Management

An ISO9660 image can be generated from the resulting Linux root directory.

This processes generates an initial ramdisk (initrd), archived with `cpio` and compressed. We then
use ISOLINUX as a bootloader to load our kernel (built from the `linux` package). The kernel then
loads the initial ramdisk into memory as the root device using `initramfs` and loads `/sbin/init`.

As an example, PunyLinux is shipped with a BusyBox package specification which includes Linux core
utilities, including a simple init system. This package specification can be replaced/removed
as it is not a required package.

### Customization

Build configuration and paths can be setup by editing `Rakefile`

#### Tasks

The `Rakefile` loads all `tasks/**/*.{rake,rb}` files and you can freely edit these files or add
your own.

#### File System

Paths under `fs/` will be synced into the `build/root/os/` directory when building, any of which can
be freely modified.

If sticking with BusyBox, the init system runs `etc/init.d/rcS` after taking control. This is
currently our initialization script.

#### Bootloader

ISOLINUX can be configured by editing `src/isolinux.cfg`. This includes the kernel command
line options.

Note that you probably don't want to mess with `initrd`, `rdinit`, or `root` as this is what causes
`initramfs` to take over using the generated initial ramdisk.

## Contributing

1. Fork it (<https://github.com/RyanScottLewis/punylinux/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Ryan Scott Lewis](https://github.com/RyanScottLewis) - creator and maintainer

