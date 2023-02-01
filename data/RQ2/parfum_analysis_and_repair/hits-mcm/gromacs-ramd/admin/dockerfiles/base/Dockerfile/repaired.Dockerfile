# Make an image that has the basic dependencies for building GROMACS.
# This is the same for all other build images and gets used by those.

# Some optional GROMACS dependencies are obtained from the
# distribution, e.g.  fftw3, hwloc, blas and lapack so that the build
# is as fast as possible.