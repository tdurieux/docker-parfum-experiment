FROM debian:stretch

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get -y --no-install-recommends install \
    cmake git build-essential curl file && rm -rf /var/lib/apt/lists/*;

# Google Test
ENV GTEST_ROOT=/opt/gtest
ARG GTEST_VER=release-1.11.0
RUN mkdir -p ${GTEST_ROOT} \
    && cd /tmp \
    && curl -f -o gtest.tar.gz \
      -L https://github.com/google/googletest/archive/${GTEST_VER}.tar.gz \
    && tar -zxvf gtest.tar.gz --strip-components=1 -C ${GTEST_ROOT} \
    && rm gtest.tar.gz

# Create User:Group
# The id is important as jenkins docker agents use the same id that is running
# on the slaves to execute containers
ARG JENKINS_GROUPID
RUN groupadd \
    -f \
    -g ${JENKINS_GROUPID} \
    jenkins

ARG JENKINS_USERID
RUN useradd \
    --create-home \
    --uid ${JENKINS_USERID} \
    --gid ${JENKINS_GROUPID} \
    --shell "/bin/bash" \
    jenkins

USER ${JENKINS_USERID}
