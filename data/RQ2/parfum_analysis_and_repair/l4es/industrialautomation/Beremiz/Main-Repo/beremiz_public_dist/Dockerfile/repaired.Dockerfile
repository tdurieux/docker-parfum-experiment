# Builds Beremiz windows installer

# initialize :
#   docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t beremiz_builder .
#
# build installer in ~/build, fetch source from repo :
#   docker run -v ~/build/:/home/devel/build beremiz_builder
#
# build installer in ~/build, taking source from ~/src :
#   docker run -v ~/src:/home/devel/src -v ~/build/:/home/devel/build --rm beremiz_builder \
#       xvfb-run make -C /home/devel/build -f /home/devel/src/LPC-2.MC9_distro/Makefile
#
# to use on code-build-test cycle :
#   docker create --name current -v ~/src:/home/devel/src -v ~/build/:/home/devel/build -i -t beremiz_builder /bin/bash
#   docker start -i current 
#       # call build operations from here
#   docker stop current
#   docker rm current