# gawk-miscutil

This is a repository for a small library of more or less generic, general
purpose, `gawk` routines. None of the library files contain full programs,
however, besides functions they may contain a `BEGIN` section in order 
to automate the proper initialization of some data structures when a
"library file" is "drawn into a `gawk` program text by means of an
`@include` statement.

The library code makes liberal use of gawk-specific extensions to awk
and therefore for the most part is not usable by other awk implementations.

## Namespaces

`Awk`, and the `gawk` implementation as well, only has global and local variables,
and only global functions. There is no such thing that resembles the limited
```static``` scope that exists in the C language. This poses a potential name
conflict problems in larger scripts and a fortiori in scripts that are included
as libraries and that are developed and maintained independently of specific
utility program scripts [^1].

To reduce the global namespace "pollution" problem, the library may use namespaces
to "hide" global data and implementation functions from the default ```awk``` namespace.
Following the elegant style set in the
[namespace example code in the GNU gawk manual](https://www.gnu.org/software/gawk/manual/html_node/Namespace-Example.html)
(last visited: 20251006), only the main interface functions are defined to be in the
```awk``` namespace.

Note that support for namespaces requires `gawk` version 5.0+.


[^1]: https://www.gnu.org/software/gawk/manual/html_node/Library-Names.html (last visited: 20251006).
