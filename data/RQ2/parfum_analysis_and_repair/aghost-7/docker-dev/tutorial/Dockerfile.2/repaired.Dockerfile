FROM tutorial:1

# We will need this to build c/c++ dependencies. This is common enough
# in all my various projects that I include it in my base image; there are
# often transitive dependencies in Python/NodeJs/Rust projects which require
# c/c++ compilation.
RUN sudo apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# The Ubuntu image does not include curl. I prefer it, but it isn't necessary.
# Note that if you decide to not install this you will need to use wget instead
# for some of the installation commands in this tutorial.
RUN sudo apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# We will need git so we can clone repositories
RUN sudo apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# SSH is not bundled by default. I always use ssh to push to Github.
RUN sudo apt-get install --no-install-recommends -y openssh-client && rm -rf /var/lib/apt/lists/*;

# The manuals are always handy for development.
RUN sudo apt-get install --no-install-recommends -y man-db && rm -rf /var/lib/apt/lists/*;

# Get basic tab completion
RUN sudo apt-get install --no-install-recommends -y bash-completion && rm -rf /var/lib/apt/lists/*;

# vim: set ft=dockerfile:
