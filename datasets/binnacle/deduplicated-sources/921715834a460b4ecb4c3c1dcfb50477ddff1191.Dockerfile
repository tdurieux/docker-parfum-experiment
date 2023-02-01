FROM ubuntu:18.04

RUN apt-get -y update && \
    apt-get -y install python2.7 clang-format git curl

RUN curl https://llvm.org/svn/llvm-project/cfe/trunk/tools/clang-format/git-clang-format > /usr/bin/git-clang-format
RUN chmod +x /usr/bin/git-clang-format

COPY . /gt/gtirb/
WORKDIR /gt/gtirb/

## Run clang-format on the last commit, excluding boost headers
RUN git clang-format origin/master `find . -name boost -prune -o -name \*.hpp -print -o -name \*.cpp -print`

## Run clang-format on all source files.
# RUN (find src -name "*.cpp" -or -name "*.hpp";find include -name "*.hpp")|xargs -I{} clang-format -i {}
# RUN [[ $(git diff --shortstat 2> /dev/null | tail -n1) == "" ]]
