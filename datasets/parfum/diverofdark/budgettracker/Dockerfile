FROM diverofdark/budgettracker-builder:master as net-builder
ARG IsProduction=false
ARG CiCommitName=local
ARG CiCommitHash=sha
ARG SONAR_TOKEN=test

WORKDIR /build
ADD . .
RUN dotnet restore
RUN cd BudgetTracker.JsApiGenerator && dotnet run --project BudgetTracker.JsApiGenerator.csproj

WORKDIR /build/BudgetTracker.Client
RUN npm install
RUN npm run build

WORKDIR /build/

ENV CiCommitName=$CiCommitName
RUN /root/.dotnet/tools/dotnet-sonarscanner begin \
        /k:"DiverOfDark_BudgetTracker" \
        /o:"diverofdark-github" \
        /d:sonar.host.url="https://sonarcloud.io" \
        /d:sonar.login=$SONAR_TOKEN \
        /d:sonar.branch.name=$CiCommitName /d:sonar.sources=/build/BudgetTracker.Client && \
    dotnet build BudgetTracker.sln && \
    /root/.dotnet/tools/dotnet-sonarscanner end /d:sonar.login="$SONAR_TOKEN"

RUN dotnet publish --output out/ --configuration Release --runtime linux-x64 --self-contained true BudgetTracker

FROM mcr.microsoft.com/dotnet/sdk:6.0
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -yqq update && \
    apt-get -yqq install unzip gnupg2 procps htop && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=net-builder /build/out ./net

RUN ln -fs /usr/local/bin/chromedriver /app/net/chromedriver
RUN ln -fs /opt/google/chrome/chrome /usr/bin/chrome

ADD run.sh .
RUN chmod +x run.sh

ARG CiCommitName=local
ARG CiCommitHash=sha
ARG IsProduction=false
ENV Properties__IsProduction=$IsProduction
ENV Properties__CiCommitName=$CiCommitName
ENV Properties__CiCommitHash=$CiCommitHash
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["/app/run.sh"]
