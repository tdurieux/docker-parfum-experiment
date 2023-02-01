# shouldnt need anything
FROM scratch

# expose control port
EXPOSE 8080/tcp

#ADD ./target/x86_64-unknown-linux-musl/debug/rustysd /rustysd
#ADD ./target/x86_64-unknown-linux-musl/debug/testservice /target/debug/testservice
#ADD ./target/x86_64-unknown-linux-musl/debug/testserviceclient /target/debug/testserviceclient