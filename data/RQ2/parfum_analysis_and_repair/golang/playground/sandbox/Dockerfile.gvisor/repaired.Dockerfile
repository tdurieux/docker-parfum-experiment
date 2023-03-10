# This is the environment that the untrusted playground programs run within
# under gvisor.

############################################################################
# Import the sandbox server's container (which is assumed to be
# already built, as enforced by the Makefile), just so we can copy its
# binary out of it. The same binary is used as both as the server and the
# gvisor-contained helper.
FROM golang/playground-sandbox AS server

############################################################################
# This is the actual environment things run in: a minimal busybox with glibc
# binaries so we can use cgo.