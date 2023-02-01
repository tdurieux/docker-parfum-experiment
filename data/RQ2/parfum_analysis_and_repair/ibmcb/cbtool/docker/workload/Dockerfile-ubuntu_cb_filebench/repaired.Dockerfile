FROM REPLACE_NULLWORKLOAD_UBUNTU

# filebench-install-man
RUN apt-get update && apt-get install --no-install-recommends -y libaio1 bison flex gawk build-essential libtool automake && rm -rf /var/lib/apt/lists/*;
RUN cd /home/REPLACE_USERNAME; git clone https://github.com/filebench/filebench.git
RUN cd /home/REPLACE_USERNAME/filebench; libtoolize; aclocal; autoheader; automake --add-missing; autoconf; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; make; sudo make install
# filebench-install-man

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
