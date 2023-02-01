FROM gradle:jdk11

RUN apt-get update && apt-get install --no-install-recommends -y texlive texlive-latex-extra texlive-fonts-extra \
                                         texlive-latex-recommended texlive-science texlive-fonts-extra tipa && rm -rf /var/lib/apt/lists/*;

# Install python3 + all dependancies for manim
RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-pip sox ffmpeg libcairo2 libcairo2-dev dos2unix && rm -rf /var/lib/apt/lists/*;

# Update pip for opencv dependancy
RUN pip3 install --no-cache-dir --upgrade pip

# Install manim
RUN pip3 install --no-cache-dir manimlib

COPY . /src/
WORKDIR /src

# Convert line endings for windows
RUN dos2unix antlr_config/antlrBuild

# Build jar file using gradle
RUN gradle build -x test

ENTRYPOINT ["java", "-jar", "build/libs/valgolang-1.0-SNAPSHOT.jar"]