# Because Fedora is really awesome I want to take it as my base environment
# but you can also use esoteric/fashion bases like Alpine, Arch, Deepin, Devuan... (lol don't do that)
# ubuntu and debian are also reasonable choices
FROM fedora:30

# Install packages (dependencies)
RUN dnf install -y make emacs  gcc-c++  valgrind libgomp libomp wget gdb ddd procps less

WORKDIR coronasurveys

# Copy source files
COPY ./src ./src
COPY ./Makefile .
COPY ./scripts ./scripts
COPY ./seeds.txt .
COPY ./snap ./snap
COPY ./graphs ./graphs


# Compile and install project
RUN make 

# Create/modify configuration files if needed