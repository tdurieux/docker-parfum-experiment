FROM hramos/android-base:latest

# set default environment variables
ENV GRADLE_OPTS="-Dorg.gradle.daemon=false -Dorg.gradle.jvmargs=\"-Xmx512m -XX:+HeapDumpOnOutOfMemoryError\""
ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"

# add ReactAndroid directory
ADD .buckconfig /app/.buckconfig
ADD .buckjavaargs /app/.buckjavaargs
ADD ReactAndroid /app/ReactAndroid
ADD ReactCommon /app/ReactCommon
ADD keystores /app/keystores

# set workdir
WORKDIR /app

# run buck fetches
RUN buck fetch ReactAndroid/src/test/java/com/facebook/react/modules
RUN buck fetch ReactAndroid/src/main/java/com/facebook/react
RUN buck fetch ReactAndroid/src/main/java/com/facebook/react/shell
RUN buck fetch ReactAndroid/src/test/...
RUN buck fetch ReactAndroid/src/androidTest/...

# build app
RUN buck build ReactAndroid/src/main/java/com/facebook/react
RUN buck build ReactAndroid/src/main/java/com/facebook/react/shell

ADD gradle /app/gradle
ADD gradlew /app/gradlew
ADD settings.gradle /app/settings.gradle
ADD build.gradle /app/build.gradle
ADD react.gradle /app/react.gradle

# run gradle downloads
RUN ./gradlew :ReactAndroid:downloadBoost :ReactAndroid:downloadDoubleConversion :ReactAndroid:downloadFolly :ReactAndroid:downloadGlog :ReactAndroid:downloadJSCHeaders

# compile native libs with Gradle script, we need bridge for unit and integration tests
RUN ./gradlew :ReactAndroid:packageReactNdkLibsForBuck -Pjobs=1 -Pcom.android.build.threadPoolSize=1

# add all react-native code
ADD . /app
WORKDIR /app

# https://github.com/npm/npm/issues/13306
RUN cd $(npm root -g)/npm && npm install fs-extra && sed -i -e s/graceful-fs/fs-extra/ -e s/fs.rename/fs.move/ ./lib/utils/rename.js && npm cache clean --force;

# build node dependencies
RUN npm install && npm cache clean --force;

WORKDIR /app
