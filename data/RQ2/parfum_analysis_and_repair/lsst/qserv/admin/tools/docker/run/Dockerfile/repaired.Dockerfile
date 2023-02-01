#-------------------------------------------------------------------------------------------------------------
# The 'lite-qserv' target produces the Qserv unified binary container image -- the end deployment artifact for
# Qserv. This target layers Qserv binaries and scripts on top of the 'lite-run-base' base image (see
# 'lite-run-base' target in ../base/Dockerfile), and sets the ownership of the copied files and the default
# runtime user to 'qserv'.
#
# The target expects a build context where binaries, libs, etc. are in top level directories 'bin/', 'lib64/',
# etc.  This is typically accomodated by providing Qserv's 'build/install/'' directory as the build context.
#
# Argument QSERV_RUN_BASE specifies the image name+tag of the base image on which to build.  The default value
# can be overriden via the -e option to 'docker run'.
#-------------------------------------------------------------------------------------------------------------