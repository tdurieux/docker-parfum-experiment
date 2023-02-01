# This dockerfile creates an image containing the runtime environment for the workspace.
# For now this is a thin layer on top of the sysroot/buildroot environment used to build.
# It re-sets the entrypoint to a shell instead of a build script, and copies in the install.
# The eventual plan for it is to only contain `<exec_depends>` of the workspace