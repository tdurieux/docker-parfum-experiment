FROM fedora:31

RUN dnf install -y \
	gcc flex bison libatomic meson ninja-build xdotool \
	'pkgconfig(libdrm)' \
	'pkgconfig(pciaccess)' \
	'pkgconfig(libkmod)' \
	'pkgconfig(libprocps)' \
	'pkgconfig(libunwind)' \
	'pkgconfig(libdw)' \
	'pkgconfig(pixman-1)' \
	'pkgconfig(valgrind)' \
	'pkgconfig(cairo)' \
	'pkgconfig(libudev)' \
	'pkgconfig(glib-2.0)' \
	'pkgconfig(gsl)' \
	'pkgconfig(alsa)' \
	'pkgconfig(xmlrpc)' \
	'pkgconfig(xmlrpc_util)' \
	'pkgconfig(xmlrpc_client)' \
	'pkgconfig(json-c)' \
	'pkgconfig(gtk-doc)' \
	'pkgconfig(xv)' \
	'pkgconfig(xrandr)' \
	python3-docutils

# We need peg to build overlay
RUN dnf install -y make
RUN mkdir /tmp/peg

# originaly from http://piumarta.com/software/peg/
RUN curl -f -o "/tmp/peg/#1" "https://intel-gfx-ci.01.org/mirror/peg/{peg-0.1.18.tar.gz}"
RUN tar -C /tmp/peg -xf /tmp/peg/peg-0.1.18.tar.gz && rm /tmp/peg/peg-0.1.18.tar.gz
RUN make -C /tmp/peg/peg-0.1.18 PREFIX=/usr install
RUN rm -fr /tmp/peg

# For compile-testing on clang
RUN dnf install -y clang

# For test list comparison
RUN dnf install -y diffutils

# For the helpers for the container with IGT inside
RUN dnf install -y findutils

# Meson version switching shenanigans
RUN dnf install -y python3-pip
RUN curl -f -o "/usr/src/#1" "https://files.pythonhosted.org/packages/e8/ec/3e6a68c9e0fd4b4f4fb6877a3ccfb6f6e6d09f2b4fc87674e671bf64b7b8/{meson-0.47.2.tar.gz}"

RUN dnf clean all
