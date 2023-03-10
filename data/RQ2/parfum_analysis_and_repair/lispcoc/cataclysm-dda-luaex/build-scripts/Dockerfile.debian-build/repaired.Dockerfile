#HOWTO:
# run this from the root of the cdda repo using `docker build -f build-scripts/Dockerfile.debian-build . -t cdda`
# (note: the -t cdda is optional but convenient. It tags the resulting image with `cdda`)
# (note: the `.` is required and orients Docker to the file/dir struture you want to bring into the image with COPY once the setup is done)

# basing the build on debian testing is an easy way to bring in clang-6.0. Debian testing is quite stable.
# (We want clang for faster builds, and clang 6 is latest)
FROM debian:testing

# read latest package index on repos
RUN apt-get -qq update && apt-get -qq -y install curl openssl ca-certificates sudo wget --no-install-recommends && rm -rf /var/lib/apt/lists/*; # we want apt-fast because it makes apt installs way faster by downloading many packages at once, and these packages are used for a fast/easy install of apt-fast

# we strip 'sudo' calls out of the script so we don't have to bother with sudo even though it's installed, and we avoid the recommended packages from the apt install in the script as they tend to be bloat on a server-like setup like this build image
RUN curl -f -sL https://git.io/vokNn | sed s/'sudo '//g | sed s/'apt-get install'/'apt-get install --no-install-recommends'/g | bash && echo "DOWNLOADBEFORE=true" >> /etc/apt-fast.conf

# ensure we know about the latest packages
RUN apt-fast -qq update

# random convenience packages
RUN apt-fast -qq install --no-install-recommends aptitude man software-properties-common gpg

# CDDA: for building
RUN apt-fast -qq install --no-install-recommends build-essential clang-6.0 cmake ccache
# we probably don't want gcc/g++ so we don't accidentally build with them; note, we may find that we might actually want them
RUN apt-get -qq remove gcc g++ && apt-get -qq autoremove

# CDDA: general stuff; gettext is required for localization
RUN apt-fast -qq install --no-install-recommends gettext

# CDDA: libraries for curses-based terminal cdda
RUN apt-fast -qq install --no-install-recommends libncurses5-dev libncursesw5-dev

# CDDA: libraries for tiles build
RUN apt-fast -qq install --no-install-recommends  libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libsdl2-mixer-dev libfreetype6-dev

# general packages for a much nicer time inside the container (we install psmisc for `killall`)
RUN apt-fast -qq install --no-install-recommends tree watch tmux fish colormake vim emacs git silversearcher-ag lsof psmisc dstat

# install opensssh-server and prepare for running it
#TODO: find a nice way of getting ssh keys into the image - by grabbing .pub keys from somewhere?
RUN apt-fast -qq install --no-install-recommends openssh-server && mkdir -p /run/sshd


# experimental: trying to get X11 forwarding or x2go to run; xauth seems to be required
RUN apt-fast install -qq --no-install-recommends xauth

# install lldb, the llvm debugger (lldb is quite good, and the clang compiler is based on llvm so it's kinda connected)
# NOTE: we have to add `--privileged` to `docker run` to be able to debug inside the container, or else we get a pretty cryptic error once we `run` inside the debugger
# NOTE: we can probably run an external debugger and attach it to the process inside the container somehow, to be able to debug inside the container using a full IDE on the host
RUN apt-fast -qq install --no-install-recommends lldb-6.0


# we prefer to build as a regular user (cdda) rather than root
RUN mkdir /cdda
# --disabled-password is a way to rush through the user generation (it's inelegant though), and then we set the password 'lol'
#TODO: bring the password in as an ARG with an option
RUN adduser cdda --disabled-password && echo cdda:lol | chpasswd
USER cdda
WORKDIR /home/cdda

# copy everything from the source directory on the host (the `.` in docker build) - except the contents of .dockerignore
COPY --chown=cdda:cdda . .

# we build in build dirs rather than at the repo root
# TODO: move build dirs to a directory ABOVE the source so we can Docker mount in the source dir for 'live' builds of code you're hacking on on the host
RUN mkdir cmake-build-debug cmake-build-debug-tiles

WORKDIR /home/cdda/cmake-build-debug


WORKDIR /home/cdda/cmake-build-debug

RUN env CC=clang-6.0 CXX=clang++-6.0 cmake ..

RUN echo `pwd` configured for build; to actually build, run "make -j`nproc --all`" here

WORKDIR /home/cdda/cmake-build-debug-tiles

RUN env CC=clang-6.0 CXX=clang++-6.0 cmake -DTILES=ON ..

RUN echo `pwd` configured for build; to actually build, run "make -j`nproc --all`" here


## ssh server stuff (experimental and not needed except for testing ssh stuff with CDDA! you don't need ssh to get a shell inside the container!)
## uncomment this to get ssh
##
## tell Docker to expose port 22 by default on `docker run` (the result is that it's mapped to a random port on the host so you can ssh in with ssh cdda@localhost:{RANDOMPORT}. Running `docker ps` will reveal the external port.
## Note that you DO NOT need SSH to get a shell inside the container. This is for testing only.
## Crash course: The usual way into the container is `docker {run or exec} -it {container/image name} bash` (or better yet, tmux or fish rather than bash). Docker run is to start a running container from an image, docker exec is to execute a process inside an already-started container.
## TODO: expose 22 to fixed port by default, perhaps with an ARG?
#EXPOSE 22
##
## the CMD entry tells Docker to run that command by default when you `docker run` the image as a container
## NOTE: disabled as it's probably not a good default for the container. However, when enabled, `docker run` gives you a somewhat persistent container that accepts SSH connections, and then for a regular shell inside the container you do `docker exec -it {containername} bash` (or ssh if you wish)
#USER root
#WORKDIR /run/sshd
#CMD ["/usr/sbin/sshd", "-De", "-f", "/etc/ssh/sshd_config"]
