FROM swift:5.6 AS build
RUN apt-get -q update && apt-get -q --no-install-recommends install -y libssl-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /source

COPY . .
RUN swift build --configuration release

FROM swift:5.6
WORKDIR /app
COPY --from=build /source/.build/release/release .
CMD ["/app/PostgresClientKitExample"]
