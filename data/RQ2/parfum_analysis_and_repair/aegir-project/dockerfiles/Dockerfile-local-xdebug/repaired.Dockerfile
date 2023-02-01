# This Dockerfile is used to change the Aegir user UID to match the host system's user.
# This allows seamless file sharing via docker volumes.

# Use --build-arg option when running docker build to set the desired UID of the "aegir" user.

# Local almost always wants xdebug.