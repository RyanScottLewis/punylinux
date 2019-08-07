# PunyLinux

Build automation (powered by Ruby & Rake) for a very minimal Linux system.

* Package Management
  * Aquire package sources (packages defined with DSL in files within `src/pkg`)
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

