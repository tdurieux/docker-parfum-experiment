FROM foo AS build
COPY . /
RUN echo hello

FROM scratch 
COPY --from=build /bar /bar