<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="DockerfileGPU" type="docker-deploy" factoryName="dockerfile" server-name="Docker">
    <deployment type="dockerfile">
      <settings>
        <option name="imageTag" value="unifyai/vision:latest-gpu" />
        <option name="buildOnly" value="true" />
        <option name="command" value="" />
        <option name="containerName" value="ivy_vision-gpu" />
        <option name="entrypoint" value="" />
        <option name="commandLineOptions" value="--gpus all" />
        <option name="sourceFilePath" value="DockerfileGPU" />
      </settings>
    </deployment>
    <method v="2" />
  </configuration>
</component>