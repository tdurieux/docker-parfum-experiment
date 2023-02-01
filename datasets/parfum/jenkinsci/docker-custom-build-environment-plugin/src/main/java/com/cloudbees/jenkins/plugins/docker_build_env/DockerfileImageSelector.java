package com.cloudbees.jenkins.plugins.docker_build_env;

import hudson.Extension;
import hudson.FilePath;
import hudson.model.AbstractBuild;
import hudson.model.Descriptor;
import hudson.model.Job;
import hudson.model.TaskListener;
import org.kohsuke.stapler.DataBoundConstructor;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.Collections;

import static org.apache.commons.lang.StringUtils.isEmpty;

/**
 * @author <a href="mailto:nicolas.deloof@gmail.com">Nicolas De Loof</a>
 */
public class DockerfileImageSelector extends DockerImageSelector {

    private String contextPath;

    private String dockerfile;

    @DataBoundConstructor
    public DockerfileImageSelector(String contextPath, String dockerfile) {
        this.contextPath = contextPath;
        this.dockerfile = dockerfile;
    }

    @Override
    public String prepareDockerImage(Docker docker, AbstractBuild build, TaskListener listener, boolean forcePull, boolean noCache) throws IOException, InterruptedException {

        String expandedContextPath = build.getEnvironment(listener).expand(contextPath);
        FilePath filePath = build.getWorkspace().child(expandedContextPath);

        FilePath dockerFile = filePath.child(getDockerfile());
        if (!dockerFile.exists()) {
            listener.getLogger().println("Your project is missing a Dockerfile");
            throw new InterruptedException("Your project is missing a Dockerfile");
        }

        listener.getLogger().println("Build Docker image from " + expandedContextPath + "/"+getDockerfile()+" ...");
        return docker.buildImage(filePath, dockerFile.getRemote(), forcePull, noCache);
    }

    @Override
    public Collection<String> getDockerImagesUsedByJob(Job<?, ?> job) {
        // TODO get last build and parse Dockerfile "FROM"
        return Collections.EMPTY_LIST;
    }

    public String getContextPath() {
        return contextPath;
    }

    public String getDockerfile() {
        return isEmpty(dockerfile) ? "Dockerfile" : dockerfile;
    }

    private Object readResolve() {
        if (dockerfile == null) dockerfile="Dockerfile";
        return this;
    }

    @Extension
    public static class DescriptorImpl extends Descriptor<DockerImageSelector> {

        @Override
        public String getDisplayName() {
            return "Build from Dockerfile";
        }
    }
}
