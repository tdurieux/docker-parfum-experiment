/*
 * Copyright Strimzi authors.
 * License: Apache License 2.0 (see the file LICENSE or http://apache.org/licenses/LICENSE-2.0.html).
 */
package io.strimzi.operator.cluster.model;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import io.strimzi.api.kafka.model.connect.build.Artifact;
import io.strimzi.api.kafka.model.connect.build.Build;
import io.strimzi.api.kafka.model.connect.build.DownloadableArtifact;
import io.strimzi.api.kafka.model.connect.build.JarArtifact;
import io.strimzi.api.kafka.model.connect.build.MavenArtifact;
import io.strimzi.api.kafka.model.connect.build.OtherArtifact;
import io.strimzi.api.kafka.model.connect.build.Plugin;
import io.strimzi.api.kafka.model.connect.build.TgzArtifact;
import io.strimzi.api.kafka.model.connect.build.ZipArtifact;
import io.strimzi.operator.cluster.ClusterOperatorConfig;
import io.strimzi.operator.common.InvalidConfigurationException;
import io.strimzi.operator.common.Util;

/**
 * This class is used to generate the Dockerfile used by Kafka Connect Build. It takes the API definition with the
 * desired plugins and generates a Dockerfile which pulls and installs them. To generate the Dockerfile, it is using
 * the PrintWriter.
 */
public class KafkaConnectDockerfile {
    private static final String BASE_PLUGIN_PATH = "/opt/kafka/plugins/";
    private static final String ROOT_USER = "root:root";
    private static final String NON_PRIVILEGED_USER = "1001";

    private static final String ENV_VAR_HTTP_PROXY = "HTTP_PROXY";
    private static final String ENV_VAR_HTTPS_PROXY = "HTTPS_PROXY";
    private static final String ENV_VAR_NO_PROXY = "NO_PROXY";

    private static final String HTTP_PROXY = System.getenv(ClusterOperatorConfig.HTTP_PROXY);
    private static final String HTTPS_PROXY = System.getenv(ClusterOperatorConfig.HTTPS_PROXY);
    private static final String NO_PROXY = System.getenv(ClusterOperatorConfig.NO_PROXY);

    private final String dockerfile;

    private static final String DEFAULT_MAVEN_IMAGE = "quay.io/strimzi/maven-builder:latest";
    private final String mavenBuilder;

    public static Cmd run(String cmd, String... args) {
        return new Cmd(new StringBuilder(), cmd, args);
    }

    public static class Cmd {

        private final StringBuilder stringBuilder;
        boolean doneFirst = false;

        private Cmd(StringBuilder stringBuilder, String cmd, String... args) {
            this.stringBuilder = stringBuilder;
            append(cmd, args);
        }

        private Cmd append(String cmd, String[] args) {
            append(cmd);
            for (var s : args) {
                append(s);
            }
            return this;
        }

        private Cmd append(String str) {
            if (Objects.requireNonNull(str).isEmpty()) {
                throw new IllegalArgumentException();
            }
            if (doneFirst) {
                stringBuilder.append(' ');
            }
            doneFirst = true;

            stringBuilder.append('\'');
            for (var i = 0; i < str.length(); i++) {
                char ch = str.charAt(i);
                if (ch == '\'') {
                    stringBuilder.append("'\"'\"'");
                } else {
                    stringBuilder.append(ch);
                }
            }
            stringBuilder.append('\'');
            return this;
        }

        public Cmd redirectTo(String str) {
            stringBuilder.append(" >");
            return append(str);
        }

        public Cmd pipeTo(String cmd, String... args) {
            stringBuilder.append(" |");
            return append(cmd, args);
        }

        public Cmd andRun(String cmd, String... args) {
            stringBuilder.append(" \\\n      &&");
            return append(cmd, args);
        }

        public String toString() {
            return stringBuilder.toString();
        }

    }

    /**
     * Broker configuration template constructor
     *
     * @param fromImage     Image which should be used as a base image in the FROM statement
     * @param connectBuild  The Build definition from the API
     */
    public KafkaConnectDockerfile(String fromImage, Build connectBuild) {
        this.mavenBuilder = System.getenv().getOrDefault(ClusterOperatorConfig.STRIMZI_DEFAULT_MAVEN_BUILDER, DEFAULT_MAVEN_IMAGE);
        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);

        printHeader(writer); // Print initial comment
        connectorPluginsPreStage(writer, connectBuild.getPlugins());
        from(writer, fromImage); // Create FROM statement
        user(writer, ROOT_USER); // Switch to root user to be able to add plugins
        proxy(writer); // Configures proxy environment variables
        connectorPlugins(writer, connectBuild.getPlugins());
        user(writer, NON_PRIVILEGED_USER); // Switch back to the regular unprivileged user

        dockerfile = stringWriter.toString();

        writer.close();
    }

    /**
     * Generates initial stage for multi-stage build
     * @param writer        Writer for printing the Docker commands
     * @param plugins       List of plugins which should be added to the container image
     */
    private void connectorPluginsPreStage(PrintWriter writer, List<Plugin> plugins) {
        Map<String, List<MavenArtifact>> artifactMap = plugins.stream().collect(Collectors.toMap(plugin -> plugin.getName(),
            plugin -> plugin.getArtifacts().stream().filter(artifact -> artifact instanceof MavenArtifact).map(artifact -> (MavenArtifact) artifact).collect(Collectors.toList())));
        artifactMap.entrySet().removeIf(plugin -> plugin.getValue().isEmpty());

        if (artifactMap.size() > 0) {
            writer.println("FROM " + mavenBuilder + " AS downloadArtifacts");
            artifactMap.entrySet().forEach(plugin -> {
                plugin.getValue().forEach(mvn -> {
                    String repo = mvn.getRepository() == null ? MavenArtifact.DEFAULT_REPOSITORY : maybeAppendSlash(mvn.getRepository());
                    String artifactHash = Util.hashStub(mvn.getGroup() + "/" + mvn.getArtifact() + "/" + mvn.getVersion());
                    String artifactDir = plugin.getKey() + "/" + artifactHash;

                    Cmd cmd = run("curl", "-f", "-L", "--create-dirs", "--output", "/tmp/" + artifactDir + "/pom.xml", assembleResourceUrl(repo, mvn, "pom"))
                            .andRun("mvn", "dependency:copy-dependencies",
                                    "-DoutputDirectory=/tmp/artifacts/" + artifactDir, "-f", "/tmp/" + artifactDir + "/pom.xml")
                            .andRun("curl", "-f", "-L", "--create-dirs", "--output",
                                    "/tmp/artifacts/" + artifactDir + "/" + mvn.getArtifact() + "-" + mvn.getVersion() + ".jar",
                                    assembleResourceUrl(repo, mvn, "jar"));
                    writer.append("RUN ").println(cmd);
                    writer.println();
                });
            });
        }
    }

    private String assembleResourceUrl(String repo, MavenArtifact mvn, String extension) {
        return String.format("%s%s/%s/%s/%s-%s.%s",
                repo,
                mvn.getGroup().replace(".", "/"),
                mvn.getArtifact().replace(".", "/"),
                mvn.getVersion(),
                mvn.getArtifact(),
                mvn.getVersion(),
                extension);
    }

    /**
     * Generates the FROM statement to the Dockerfile. It uses the image passes in the parameter as the base image.
     *
     * @param writer        Writer for printing the Docker commands
     * @param fromImage     Base image which should be used
     */
    private void from(PrintWriter writer, String fromImage) {
        writer.println("FROM " + fromImage);
        writer.println();
    }

    /**
     * Generates proxy arguments if set in the operator
     *
     * @param writer        Writer for printing the Docker commands
     */
    private void proxy(PrintWriter writer) {
        if (HTTP_PROXY != null) {
            writer.println(String.format("ARG %s=%s", ENV_VAR_HTTP_PROXY.toLowerCase(Locale.ENGLISH), HTTP_PROXY));
            writer.println();
        }

        if (HTTPS_PROXY != null) {
            writer.println(String.format("ARG %s=%s", ENV_VAR_HTTPS_PROXY.toLowerCase(Locale.ENGLISH), HTTPS_PROXY));
            writer.println();
        }

        if (NO_PROXY != null) {
            writer.println(String.format("ARG %s=%s", ENV_VAR_NO_PROXY.toLowerCase(Locale.ENGLISH), NO_PROXY));
            writer.println();
        }
    }

    /**
     * Generates the USER statement in the Dockerfile to switch the user under which the next commands will be running.
     *
     * @param writer    Writer for printing the Docker commands
     * @param user      User to which the Dockefile should switch
     */
    private void user(PrintWriter writer, String user) {
        writer.println("USER " + user);
        writer.println();
    }

    /**
     * Adds the commands to download and possibly unpack the connector plugins
     *
     * @param writer    Writer for printing the Docker commands
     * @param plugins   List of plugins which should be added to the container image
     */
    private void connectorPlugins(PrintWriter writer, List<Plugin> plugins) {
        for (Plugin plugin : plugins)   {
            addPlugin(writer, plugin);
        }
    }

    /**
     * Adds a particular connector plugin to the container image. It will go through the individual artifacts and add
     * them one by one depending on their type.
     *
     * @param writer    Writer for printing the Docker commands
     * @param plugin    A single plugin which should be added to the new container image
     */
    private void addPlugin(PrintWriter writer, Plugin plugin)    {
        printSectionHeader(writer, "Connector plugin " + plugin.getName());

        String connectorPath = BASE_PLUGIN_PATH + plugin.getName();

        for (Artifact art : plugin.getArtifacts())  {
            if (art instanceof JarArtifact) {
                addJarArtifact(writer, connectorPath, (JarArtifact) art);
            } else if (art instanceof TgzArtifact) {
                addTgzArtifact(writer, connectorPath, (TgzArtifact) art);
            } else if (art instanceof ZipArtifact) {
                addZipArtifact(writer, connectorPath, (ZipArtifact) art);
            } else if (art instanceof MavenArtifact) {
                addMavenArtifact(writer, plugin.getName(), (MavenArtifact) art);
            } else if (art instanceof OtherArtifact) {
                addOtherArtifact(writer, connectorPath, (OtherArtifact) art);
            } else {
                throw new RuntimeException("Unexpected artifact type " + art.getType());
            }
        }
    }

    private void checkUrlIsPresent(DownloadableArtifact art) {
        if (art.getUrl() == null || art.getUrl().isEmpty()) {
            throw new InvalidConfigurationException("`" + art.getType() + "` artifact is missing a URL.");
        }
    }

    private void checkGavIsPresent(MavenArtifact art) {
        if (art.getGroup() == null || art.getGroup().isEmpty()) {
            throw new InvalidConfigurationException("`" + art.getType() + "` artifact is missing a group ID.");
        }
        if (art.getArtifact() == null || art.getArtifact().isEmpty()) {
            throw new InvalidConfigurationException("`" + art.getType() + "` artifact is missing an artifact ID.");
        }
        if (art.getVersion() == null || art.getVersion().isEmpty()) {
            throw new InvalidConfigurationException("`" + art.getType() + "` artifact is missing a version number.");
        }
    }

    private Cmd downloadArtifact(String artifactDir, String artifactPath, DownloadableArtifact artifact)  {
        Cmd cmd = run("mkdir", "-p", artifactDir);

        if (Boolean.TRUE.equals(artifact.getInsecure()))    {
            return cmd.andRun("curl", "-f", "-k", "-L", "--output", artifactPath, artifact.getUrl());
        } else {
            return cmd.andRun("curl", "-f", "-L", "--output", artifactPath, artifact.getUrl());
        }
    }

    /**
     * Add command sequence for downloading files and checking their checksums.
     *
     * @param writer            Writer for printing the Docker commands
     * @param connectorPath     Path where the connector to which this artifact belongs should be downloaded
     * @param jar               The JAR-type artifact
     */
    private void addJarArtifact(PrintWriter writer, String connectorPath, JarArtifact jar) {
        checkUrlIsPresent(jar);
        String artifactHash = Util.hashStub(jar.getUrl());
        String artifactDir = connectorPath + "/" + artifactHash;
        String artifactPath = artifactDir + "/" + artifactHash + ".jar";
        addUnmodifiedArtifact(writer, jar, artifactDir, artifactPath);
    }

    /**
     * Add command sequence for downloading files and checking their checksums.
     *
     * @param writer            Writer for printing the Docker commands
     * @param connectorPath     Path where the connector to which this artifact belongs should be downloaded
     * @param other             The Other-type artifact
     */
    private void addOtherArtifact(PrintWriter writer, String connectorPath, OtherArtifact other) {
        checkUrlIsPresent(other);
        String artifactHash = Util.hashStub(other.getUrl());
        String artifactDir = connectorPath + "/" + artifactHash;
        String fileName = other.getFileName() != null ? other.getFileName() : artifactHash;
        String artifactPath = artifactDir + "/" + fileName;

        addUnmodifiedArtifact(writer, other, artifactDir, artifactPath);
    }

    /**
     * Adds download command for artifacts which are just downloaded without any unpacking or other processing.
     * @param writer            Writer for printing the Docker commands
     * @param art               Artifact which should be downloaded
     * @param artifactDir       Directory into which the artifact should be downloaded
     * @param artifactPath      Full path of the artifact
     */
    private void addUnmodifiedArtifact(PrintWriter writer, DownloadableArtifact art, String artifactDir, String artifactPath) {
        Cmd run = downloadArtifact(artifactDir, artifactPath, art);

        if (art.getSha512sum() != null && !art.getSha512sum().isEmpty()) {
            // Checksum exists => we need to check it
            String shaFile = artifactPath + ".sha512";
            run.andRun("echo", art.getSha512sum() + " " + artifactPath)
                    .redirectTo(shaFile)
                .andRun("sha512sum", "--check", shaFile)
                .andRun("rm", "-f", shaFile);
        }
        writer.append("RUN ").println(run);
        writer.println();
    }

    /**
     * Add command sequence for downloading and unpacking TAR.GZ archives and checking their checksums.
     *
     * @param writer            Writer for printing the Docker commands
     * @param connectorPath     Path where the connector to which this artifact belongs should be downloaded
     * @param tgz               The TGZ-type artifact
     */
    private void addTgzArtifact(PrintWriter writer, String connectorPath, TgzArtifact tgz) {
        checkUrlIsPresent(tgz);
        String artifactHash = Util.hashStub(tgz.getUrl());
        String artifactDir = connectorPath + "/" + artifactHash;
        String archivePath = connectorPath + "/" + artifactHash + ".tgz";

        Cmd run = downloadArtifact(artifactDir, archivePath, tgz);

        if (tgz.getSha512sum() != null && !tgz.getSha512sum().isEmpty()) {
            // Checksum exists => we need to check it
            String shaFile = archivePath + ".sha512";
            run.andRun("echo", tgz.getSha512sum() + " " + archivePath)
                    .redirectTo(shaFile)
                .andRun("sha512sum", "--check", shaFile)
                .andRun("rm", "-f", shaFile);
        }
        run.andRun("tar", "xvfz", archivePath, "-C", artifactDir)
            .andRun("rm", "-vf", archivePath);
        writer.append("RUN ").println(run);
        writer.println();
    }

    /**
     * Add command sequence for downloading and unpacking TAR.ZIP archives and checking their checksums.
     *
     * @param writer            Writer for printing the Docker commands
     * @param connectorPath     Path where the connector to which this artifact belongs should be downloaded
     * @param zip               The ZIP-type artifact
     */
    private void addZipArtifact(PrintWriter writer, String connectorPath, ZipArtifact zip) {
        checkUrlIsPresent(zip);
        String artifactHash = Util.hashStub(zip.getUrl());
        String artifactDir = connectorPath + "/" + artifactHash;
        String archivePath = connectorPath + "/" + artifactHash + ".zip";

        Cmd run = downloadArtifact(artifactDir, archivePath, zip);

        if (zip.getSha512sum() != null && !zip.getSha512sum().isEmpty()) {
            // Checksum exists => we need to check it
            String shaFile = archivePath + ".sha512";
            run.andRun("echo", zip.getSha512sum() + " " + archivePath)
                    .redirectTo(shaFile)
                .andRun("sha512sum", "--check", shaFile)
                .andRun("rm", "-f", shaFile);
        }

        run.andRun("unzip", archivePath, "-d", artifactDir)
            .andRun("find", artifactDir, "-type", "l").pipeTo("xargs", "rm", "-f")
            .andRun("rm", "-vf", archivePath);

        writer.append("RUN ").println(run);
        writer.println();
    }

    /**
     * Add command sequence for downloading Maven artifact
     *
     * @param writer            Writer for printing the Docker commands
     * @param connectorName     Name of the connector to which this artifact belongs should be downloaded
     * @param mvn               The maven artifact
     */
    private void addMavenArtifact(PrintWriter writer, String connectorName, MavenArtifact mvn) {
        checkGavIsPresent(mvn);
        String artifactHash = Util.hashStub(mvn.getGroup() + "/" + mvn.getArtifact() + "/" + mvn.getVersion());

        Cmd run = run("/tmp/artifacts/" + connectorName + "/" + artifactHash, BASE_PLUGIN_PATH + connectorName + "/" + artifactHash);
        writer.append("COPY --from=downloadArtifacts ").println(run);
        writer.println();
    }

    /**
     * @param checked The string to check whether contains the slash as the last character
     * @return The string with slash ('/') as the last character
     */
    private String maybeAppendSlash(String checked) {
        if (checked.lastIndexOf('/') + 1 == checked.length()) {
            return checked;
        } else {
            return checked + "/";
        }
    }

    /**
     * Internal method which prints the section header into the Dockerfile. This makes it more human readable.
     *
     * @param sectionName   Name of the section for which is this header printed
     */
    private void printSectionHeader(PrintWriter writer, String sectionName)   {
        writer.println("##########");
        writer.println("# " + sectionName);
        writer.println("##########");
    }

    /**
     * Prints the file header which is on the beginning of the Dockerfile.
     */
    private void printHeader(PrintWriter writer)   {
        writer.println("##############################");
        writer.println("##############################");
        writer.println("# This file is automatically generated by the Strimzi Cluster Operator");
        writer.println("# Any changes to this file will be ignored and overwritten!");
        writer.println("##############################");
        writer.println("##############################");
        writer.println();
    }

    /**
     * Returns the generated Dockerfile for building new Kafka Connect image with additional connectors.
     *
     * @return  Dockerfile
     */
    public String getDockerfile() {
        return dockerfile;
    }

    /**
     * Returns the hash stub identifying the Dockerfile. This can be used to detect changes.
     *
     * @return  Dockerfile hash stub
     */
    public String hashStub()    {
        return Util.hashStub(dockerfile);
    }


}