FROM alpine:3.9

ENV JAVA_HOME /opt/openjdk-13
ENV PATH $JAVA_HOME/bin:$PATH

# https://jdk.java.net/
ENV JAVA_VERSION 13-ea+19
ENV JAVA_URL https://download.java.net/java/early_access/alpine/19/binaries/openjdk-13-ea+19_linux-x64-musl_bin.tar.gz
ENV JAVA_SHA256 010ea985fba7e3d89a9170545c4e697da983cffc442b84e65dba3baa771299a5
# "For Alpine Linux, builds are produced on a reduced schedule and may not be in sync with the other platforms."

RUN set -eux; \
	\
	wget -O /openjdk.tgz "$JAVA_URL"; \
	echo "$JAVA_SHA256 */openjdk.tgz" | sha256sum -c -; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /openjdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
	rm /openjdk.tgz; \
	\
# https://github.com/docker-library/openjdk/issues/212#issuecomment-420979840
# https://openjdk.java.net/jeps/341
	java -Xshare:dump; \
	\
# basic smoke test
	java --version; \
	javac --version

# https://docs.oracle.com/javase/10/tools/jshell.htm
# https://docs.oracle.com/javase/10/jshell/
# https://en.wikipedia.org/wiki/JShell
CMD ["jshell"]
