FROM mikkl/multiarch-mongodb:{ARCH}
CMD mongod --repair; mongod
