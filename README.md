# gawk-miscutil

This is a repository for a small library of more or less generic, general
purpose, `gawk` routines. None of the library files contain full programs,
however, besides functions they may contain a `BEGIN` section in order 
to automate the proper initialization of some data structures when a
"library file" is "drawn into a `gawk` program text by means of an
`@include` statement.

The library code makes liberal use of gawk-specific extensions to awk
and therefore for the most part is not usable by other awk implementations.

The library may use namespaces to "hide" global data from the default
"awk" namespace. Note that support for namespaces requires `gawk` version
5.0+.
