{#include Dockerfile-layout type='jvm'}
    {#quarkusbuild}{buildtool.cli} {buildtool.cmd.package}{/quarkusbuild}
    {#copy}
# We make four distinct layers so if there are application changes the library layers can be re-used
COPY --chown=185 {buildtool.build-dir}/quarkus-app/lib/ /deployments/lib/
COPY --chown=185 {buildtool.build-dir}/quarkus-app/*.jar /deployments/
COPY --chown=185 {buildtool.build-dir}/quarkus-app/app/ /deployments/app/
COPY --chown=185 {buildtool.build-dir}/quarkus-app/quarkus/ /deployments/quarkus/
    {/copy}
{/include}