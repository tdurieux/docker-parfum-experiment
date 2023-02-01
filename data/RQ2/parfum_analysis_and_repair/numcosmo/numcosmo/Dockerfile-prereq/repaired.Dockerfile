FROM ubuntu:latest

# Install basic stuff
RUN apt-get update && apt-get install --no-install-recommends -y \
    nano \
    wget \
    git \
    cmake \
    pkg-config && rm -rf /var/lib/apt/lists/*;

# Install compilers
RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc-8 \
    gfortran-8 && rm -rf /var/lib/apt/lists/*;

# Install GLib and GObject related packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    gtk-doc-tools \
    gobject-introspection \
    libgirepository1.0-dev \
    libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

# Install package building tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    autotools-dev \
    libtool && rm -rf /var/lib/apt/lists/*;

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    libgsl-dev \
    libgmp-dev \
    libmpfr-dev \
    libcfitsio-dev \
    libfftw3-dev \
    libnlopt-dev \
    liblapack-dev \
    libopenblas-dev \
    libhdf5-dev \
    libflint-arb-dev && rm -rf /var/lib/apt/lists/*;

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install python
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-gi \
    python3-numpy \
    python3-matplotlib \
    python3-scipy && rm -rf /var/lib/apt/lists/*;

# Install dependencies (runtime only)
RUN apt-get update && apt-get install --no-install-recommends -y \
    libgfortran5 \
    libgsl23 \
    libgmp10 \
    libmpfr6 \
    libcfitsio5 \
    libfftw3-double3 \
    libfftw3-single3 \
    libnlopt0 \
    liblapack3 \
    libopenblas-base \
    libhdf5-100 \
    libflint-arb2 && rm -rf /var/lib/apt/lists/*;

# Set environment variables
ENV CUBACORES=1
ENV OMP_NUM_THREADS=1
ENV OMP_THREAD_LIMIT=1
