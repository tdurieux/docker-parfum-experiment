FROM ubuntu:19.04

RUN apt update && apt install --no-install-recommends -y clang libclang-dev llvm-dev cmake libfmt-dev g++ gcc libgtest-dev gcovr && rm -rf /var/lib/apt/lists/*;
