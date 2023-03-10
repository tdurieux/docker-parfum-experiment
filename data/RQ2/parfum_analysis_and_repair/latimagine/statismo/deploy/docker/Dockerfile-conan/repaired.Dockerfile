FROM conanio/gcc7:1.24.0

ARG git_branch=develop

RUN pip install --no-cache-dir conan --upgrade

RUN git clone https://github.com/kenavolic/statismo --branch $git_branch /home/conan/statismo
WORKDIR "/home/conan/statismo"
RUN bash /home/conan/statismo/deploy/pack/conan/conan_install.sh /home/conan/statismo
