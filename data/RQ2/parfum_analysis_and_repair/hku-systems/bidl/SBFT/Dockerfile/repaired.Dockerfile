# NOTES:
# 1. The Dockerfile does not have an entry point because everything has to be managed outside of it.
# 2. Please do not install anything directly in this file.
#   You need to use "install_deps.sh" - we want to keep a possibility to develop w/o docker.
# 3. If a tool or library that you install in the "install_deps.sh" is needed only for building 3rd party
#   tools/libraries please uninstall them after the script run - we want to keep image' size minimal.
#   For example wget and pip-tools.