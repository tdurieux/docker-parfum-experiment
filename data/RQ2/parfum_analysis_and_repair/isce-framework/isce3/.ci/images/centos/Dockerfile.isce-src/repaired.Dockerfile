FROM nisar/dev:latest

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

# Set ISCE repo
ENV ISCE_ORG ericmg
ENV ISCE_REPO github-fn.jpl.nasa.gov/${ISCE_ORG}/isce.git

# install tools for RPM generation
RUN set -ex \
 && sudo yum update -y \
 && sudo yum install -y \
      make ruby-devel rpm-build rubygems \
      which autoconf automake bison libffi-devel libtool readline-devel sqlite-devel zlib-devel openssl-devel \
 && command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import - \
 && curl -f -L get.rvm.io | bash -s stable \
 && source /home/conda/.rvm/scripts/rvm \
 && sudo /home/conda/.rvm/bin/rvm install 2.3.0 \
 && export PATH=/home/conda/.rvm/gems/ruby-2.3.0/bin:/home/conda/.rvm/gems/ruby-2.3.0@global/wrappers/:$PATH \
 && sudo gem install --no-ri --no-rdoc fpm && rm -rf /var/cache/yum

# install doxygen and sphinx for doc generation;
# install valgrind for memory leak check
RUN set -ex \
  && source /opt/docker/bin/entrypoint_source \
  && sudo yum install -y doxygen doxygen-latex texlive texlive-*.noarch \
       ghostscript graphviz valgrind \
  && sudo conda install --yes sphinx \
  && mkdir -p /home/conda/texmf/tex/latex/commonstuff \
  && wget https://mirrors.ctan.org/macros/latex/contrib/anyfontsize/anyfontsize.sty -P /home/conda/texmf/tex/latex/commonstuff && rm -rf /var/cache/yum

# install cppcheck for C++ code analysis
RUN set -ex \
  && source /opt/docker/bin/entrypoint_source \
  && mkdir ~/tmp \
  && wget -q --no-check-certificate -O ~/tmp/cppcheck-1.87.tar.gz https://github.com/danmar/cppcheck/archive/1.87.tar.gz \
  && tar -zxf ~/tmp/cppcheck-1.87.tar.gz -C ~/tmp \
  && cd ~/tmp/cppcheck-1.87 \
  && make SRCDIR=build CFGDIR=cfg HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" && rm ~/tmp/cppcheck-1.87.tar.gz

# copy repo
COPY . isce

# build ISCE
RUN set -ex \
 && source /opt/docker/bin/entrypoint_source \
 && cd ~ \
 && mkdir build \
 && mkdir build/valgrind \
 && cd build \
 && cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/isce -DWITH_CUDA=ON \
      -DMEMORYCHECK_COMMAND_OPTIONS="--trace-children=yes --leak-check=full --dsymutil=yes --track-origins=yes --xml=yes --xml-file=/home/conda/build/valgrind/memcheck.%p.xml" \
      -DISCE_CUDA_ARCHS=3.7 \
      -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=true ../isce \
 && make -j`nproc` VERBOSE=1 \
 && sudo mkdir /opt/isce \
 && sudo make install \
 && ~/tmp/cppcheck-1.87/cppcheck --std=c++14 --enable=all --inconclusive --force --inline-suppr --xml --xml-version=2 /home/conda/isce/cxx 2> cppcheck.xml
