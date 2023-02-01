FROM {docker-base-image} AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM {docker-build-image} AS build
WORKDIR /src
{project-path-list}
RUN dotnet restore "{project-path}"
COPY . .
WORKDIR "/src/{project-folder}"
RUN dotnet build "{project-name}" -c Release -o /app/build

FROM build AS publish
RUN apt-get update -yq \
    && apt-get install --no-install-recommends curl gnupg -yq \
    && curl -f -sL https://deb.nodesource.com/setup_14.x | bash \
    && apt-get install --no-install-recommends nodejs -yq && rm -rf /var/lib/apt/lists/*;
RUN dotnet publish "{project-name}" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "{assembly-name}.dll"]
