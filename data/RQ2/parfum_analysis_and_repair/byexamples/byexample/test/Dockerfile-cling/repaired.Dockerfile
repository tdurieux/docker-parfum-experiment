FROM continuumio/miniconda3

RUN     conda install -y -c conda-forge/label/cf202003 cling \
    &&  conda clean -y --all

# Build the container with
#
#   $ sudo docker build -f Dockerfile-cling -t mycling .  # <- don't forget this dot at the end!
#
# Change 'mycling' to the name that you want.
#
# To use this docker container with byexample to run C++ examples
# run byexample as
#
#  $ dockercmd="sudo docker run --rm -it -v <some-folder>:/mnt -w /mnt mycling cling %a"
#  $ byexample -l cpp -x-shebang="cpp:$dockercmd" <files>
#
# The container will have access to <some-folder>, where should be your files,
# via the local /mnt folder, which will become the working directory.
#
# See the documentation of "docker run" for more information
#