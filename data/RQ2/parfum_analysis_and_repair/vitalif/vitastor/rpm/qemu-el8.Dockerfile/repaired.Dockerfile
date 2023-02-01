# This is an attempt to automatically build patched RPM specs
# More or less broken, better use *.spec.patch for now (and copy src/qemu_driver.c to SOURCES/qemu-vitastor.c)

# Build packages for CentOS 8 inside a container
# cd ..; podman build -t qemu-el8 -v `pwd`/packages:/root/packages -f rpm/qemu-el8.Dockerfile .