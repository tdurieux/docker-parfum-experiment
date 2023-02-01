#   docker build -t emscripten:latest --build-arg EMSCRIPTEN_SDK=sdk-tag-1.38.21-64bit https://raw.githubusercontent.com/trzecieu/emscripten-docker/master/docker/trzeci/emscripten/Dockerfile
#   docker build -t impacto-emscripten .
# (after 1.38.22 we should switch to trzeci/emscripten:latest)
#   docker run --rm -v /path/to/build/directory:/build -v /path/to/impacto/repository/root:/src -u emscripten impacto-emscripten