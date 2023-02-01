FROM lambci/lambda:dotnetcore2.1

FROM lambci/lambda-base:build

# Run: docker run --rm --entrypoint dotnet lambci/lambda:dotnetcore2.1 --info
# Check https://dotnet.microsoft.com/download/dotnet-core/2.1 for versions
ENV DOTNET_ROOT=/var/lang/bin
ENV PATH=/root/.dotnet/tools:$DOTNET_ROOT:$PATH \
    LD_LIBRARY_PATH=/var/lang/lib:$LD_LIBRARY_PATH \
    AWS_EXECUTION_ENV=AWS_Lambda_dotnetcore2.1 \
    DOTNET_SDK_VERSION=2.1.803 \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    NUGET_XMLDOC_MODE=skip

COPY --from=0 /var/runtime /var/runtime
COPY --from=0 /var/lang /var/lang
COPY --from=0 /var/rapid /var/rapid

RUN yum install -y libunwind && \
  curl -f -L https://dot.net/v1/dotnet-install.sh | bash -s -- -v $DOTNET_SDK_VERSION -i $DOTNET_ROOT && \
  mkdir /tmp/warmup && \
  cd /tmp/warmup && \
  dotnet new && \
  cd / && \
  rm -rf /tmp/warmup /tmp/NuGetScratch /tmp/.dotnet && rm -rf /var/cache/yum

# Add these as a separate layer as they get updated frequently
# The pipx workaround is due to https://github.com/pipxproject/pipx/issues/218
RUN source /usr/local/pipx/shared/bin/activate && \
  pipx install virtualenv && \
  pipx install pipenv && \
  pipx install awscli==1.* && \
  pipx install aws-lambda-builders==1.2.0 && \
  pipx install aws-sam-cli==1.15.0 && \
  dotnet tool install --global Amazon.Lambda.Tools --version 3.3.1

CMD ["dotnet", "build"]
