FROM ghcr.io/agarlicmonkey/clove/linux_build:1.2

#Install static analysis tools
RUN apt-get install --no-install-recommends -y cppcheck && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-tidy && rm -rf /var/lib/apt/lists/*;

CMD [ "/bin/bash" ]