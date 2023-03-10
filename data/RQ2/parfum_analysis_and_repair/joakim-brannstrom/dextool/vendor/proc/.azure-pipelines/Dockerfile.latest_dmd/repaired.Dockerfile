# ubuntu_bionic_base
FROM dlang2/dmd-ubuntu

WORKDIR /opt

# fix_repo
COPY repo.tar.gz /opt
RUN mkdir repo
RUN tar xfz repo.tar.gz -C repo && rm repo.tar.gz

# build_with_dub
RUN cd repo && dub test
# unable to run integration tests because some requires ssh
#RUN cd repo && dub run -c integration_test