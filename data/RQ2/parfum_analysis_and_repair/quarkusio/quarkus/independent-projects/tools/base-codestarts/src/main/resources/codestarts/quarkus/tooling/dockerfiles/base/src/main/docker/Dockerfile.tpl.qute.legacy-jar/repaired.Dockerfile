{#include Dockerfile-layout type='legacy-jar'}
    {#quarkusbuild}{buildtool.cli} {buildtool.cmd.package-legacy-jar}{/quarkusbuild}
    {#copy}
COPY {buildtool.build-dir}/lib/* /deployments/lib/
COPY {buildtool.build-dir}/*-runner.jar /deployments/quarkus-run.jar
    {/copy}
{/include}