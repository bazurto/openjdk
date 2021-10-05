# Openjdk

This repo creates local copies of OpenJdk for Linux, Windows and Mac.  It downloads the original tarballs and adds netskope certificates.


# Requirements
- Git
- Make
- GH command

# Building a new Relese
- Find the Download URLs.  For example, the Openjdk 17 download URLs ca be found at https://jdk.java.net/17/
- Update the version in `Makefile` to match the version in the URL
- Update the `*zip_name` variables to match the files been Downloaded
- Run `make` to test the script.
- Run `make release` to create the new release in Github and upload the tarballs.


