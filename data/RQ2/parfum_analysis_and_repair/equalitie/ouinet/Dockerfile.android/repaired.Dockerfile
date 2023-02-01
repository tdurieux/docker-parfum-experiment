FROM registry.gitlab.com/equalitie/ouinet
# The JAXB package replaces J2EE functionality required by `sdkmanager`
# which is no longer in OpenJDK >= 11.
# See <https://stackoverflow.com/a/57779795> and <https://stackoverflow.com/a/62544345>,
# though no direct alteration of `sdkmanager` is performed here (but see below).
RUN apt-get update && apt-get install -y --no-install-recommends \
      default-jdk \
      libjaxb-java \
      unzip \
    && rm -rf /var/lib/apt/lists/*
# Exploit `sdmanager` script's compatibility with AIX' JDK to
# wrap `java` invocation with a script that adds J2EE compatibility JARs to the class path.
# We could have also used `update-alternatives` or `dpkg-divert` to replace `/usr/bin/java`,
# but this solution avoids using the kludge in the general case of invoking `java`.
# However, it also affects the Gradle wrapper and maybe other similar wrappers.
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" \
    JAVA_EXTRA_CLASSPATH="/usr/share/java/jaxb-impl.jar"
RUN javaw="$JAVA_HOME/jre/sh/java" \
    && mkdir -p "$(dirname "$javaw")" \
    && /bin/echo -en '#!/bin/bash\n\
cp="$JAVA_EXTRA_CLASSPATH" java="$JAVA_HOME/bin/java"\n\
test "$cp" || exec "$java" "$@"\n\
\n\
args=()\n\
for arg in "$@"; do\n\
    if [[ "$setcp" ]]; then\n\
        cp="$arg:$cp" setcp=\n\
    elif [[ "$arg" =~ ^-(cp|-?classpath)$ ]]; then\n\
        setcp=y\n\
    else\n\
        args+=("$arg")\n\
    fi\n\
done\n\
exec "$java" -cp "$cp" "${args[@]}"\n\
' > "$javaw" \
    && chmod a+rx "$javaw"
ENV UNZIPOPT=-q