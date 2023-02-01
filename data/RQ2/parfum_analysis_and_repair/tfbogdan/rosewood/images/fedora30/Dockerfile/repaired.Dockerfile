FROM fedora:30

RUN yum install -y git cmake g++ clang-devel llvm-devel gtest-devel fmt-devel gcovr && rm -rf /var/cache/yum
RUN yum install -y make && rm -rf /var/cache/yum