# xxx

# build error
## 1. lto1: internal compiler error: in add_symbol_to_partition_1, at lto/lto-partition.c:155
$ sudo apt-get install clang
$ CC=clang CXX=clang++ LD=clang make
$ LDFLAGS=-fno-lto make
