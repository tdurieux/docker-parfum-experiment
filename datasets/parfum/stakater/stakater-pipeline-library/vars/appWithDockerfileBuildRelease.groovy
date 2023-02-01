#!/usr/bin/groovy
// This function can be called if your app is built and run in your Dockerfile, 
// This will create version, build & push Image, render charts, and deploy that chart using
// the install-chart target in your Makefile

def call(body) {
    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()

    toolsImage = config.toolsImage ?: 'stakater/pipeline-tools:1.15.0'
    shouldDeploy = config.deployApp ?: false

    toolsNode(toolsImage: toolsImage) {

        def builder = new io.stakater.builder.Build()
        def docker = new io.stakater.containers.Docker()
        def stakaterCommands = new io.stakater.StakaterCommands()
        def git = new io.stakater.vc.Git()
        def slack = new io.stakater.notifications.Slack()
        def common = new io.stakater.Common()
        def templates = new io.stakater.charts.Templates()
        def utils = new io.fabric8.Utils()

        // Slack variables
        def slackChannel = "${env.SLACK_CHANNEL}"
        def slackWebHookURL = "${env.SLACK_WEBHOOK_URL}"

        def dockerRepositoryURL = config.dockerRepositoryURL ?: common.getEnvValue('DOCKER_REPOSITORY_URL')
        def dockerImage = ""
        def version = ""

        container(name: 'tools') {
            withCurrentRepo() { def repoUrl, def repoName, def repoOwner, def repoBranch ->
                def kubernetesDir = WORKSPACE + "/deployments/kubernetes"
                def chartTemplatesDir = kubernetesDir + "/templates/chart"
                def chartDir = kubernetesDir + "/chart"
                def manifestsDir = kubernetesDir + "/manifests"

                def imageName = repoName.split("dockerfile-").last().toLowerCase()
                def fullAppNameWithVersion = ""
                echo "Image NAME: ${imageName}"
                if (repoOwner.startsWith('stakater-')){
                    repoOwner = 'stakater'
                }
                echo "Repo Owner: ${repoOwner}" 
                try {
                    stage('Generate Version'){
                        dockerImage = "${dockerRepositoryURL}/${repoOwner.toLowerCase()}/${imageName}"
                        // If image Prefix is passed, use it, else pass empty string to create versions
                        def imagePrefix = config.imagePrefix ? config.imagePrefix + '-' : ''
                        version = stakaterCommands.getImageVersionForCiAndCd(repoUrl, imagePrefix, "${env.BRANCH_NAME}", "${env.BUILD_NUMBER}")
                        echo "Version: ${version}"
                        fullAppNameWithVersion = imageName + '-'+ version
                    }
                    stage('Build & Push Image') {
                        sh """
                            export DOCKER_IMAGE=${dockerImage}
                            export DOCKER_TAG=${version}
                        """
                        docker.buildImageWithTagCustom(dockerImage, version)
                        docker.pushTagCustom(dockerImage, version)
                    }
                    if(shouldDeploy){
                        stage('Publish Charts, Manifests'){
                            echo "Rendering Chart & generating manifests"
                            // Render chart from templates
                            templates.renderChart(chartTemplatesDir, chartDir, repoName.toLowerCase(), version, dockerImage)
                            // Generate manifests from chart
                            templates.generateManifests(chartDir, repoName.toLowerCase(), manifestsDir)
                        }    
                        stage('Deploy chart'){
                            echo "Deploying Chart"   
                            builder.deployHelmChart(chartDir)
                        }
                    }
                    if (utils.isCD()) {
                                                                
                        stage("Create Git Tag"){
                            print "Pushing Tag ${version} to Git"
                            git.createTagAndPushUsingToken(WORKSPACE, version)
                            stakaterCommands.createGitHubRelease(version)
                        }                        
                    }                    
                }
                catch (e) {
                    slack.sendDefaultFailureNotification(slackWebHookURL, slackChannel, [slack.createErrorField(e)])

                    def commentMessage = "Yikes! You better fix it before anyone else finds out! [Build ${env.BUILD_NUMBER}](${env.BUILD_URL}) has Failed!"
                    git.addCommentToPullRequest(commentMessage,repoOwner)

                    throw e
                }

                stage('Notify') {
                    slack.sendDefaultSuccessNotification(slackWebHookURL, slackChannel, [slack.createDockerImageField("${dockerImage}:${version}")])

                    def commentMessage = "Image is available for testing. `docker pull ${dockerImage}:${version}`"
                    git.addCommentToPullRequest(commentMessage,repoOwner)
                }
            }
        }
    }
}
