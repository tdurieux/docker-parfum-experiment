FROM registry.cn-hangzhou.aliyuncs.com/xiaomimace/mace-dev:latest

# Update source
RUN apt-get update -y && apt-get install -y --no-install-recommends gitlab-ci-multi-runner && rm -rf /var/lib/apt/lists/*; # Install gitlab runner
RUN curl -f -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash


# set timezone
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENTRYPOINT gitlab-runner run
