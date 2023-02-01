<?xml version='1.0' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.41">
    <actions>
        <org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobAction
                plugin="pipeline-model-definition@1.8.5"/>
        <org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction
                plugin="pipeline-model-definition@1.8.5">
            <jobProperties/>
            <triggers/>
            <parameters>
                <string>ImageFullName</string>
                <string>DockerfileInLocal</string>
                <string>CommitId</string>
                <string>GitUrl</string>
                <string>GitBranch</string>
                <string>UUID</string>
                <string>AppName</string>
            </parameters>
            <options/>
        </org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction>
    </actions>
    <description>SomeJobDescriptionHere</description>
    <keepDependencies>false</keepDependencies>
    <properties>
        <hudson.model.ParametersDefinitionProperty>
            <parameterDefinitions>
                <hudson.model.StringParameterDefinition>
                    <name>AppName</name>
                    <defaultValue>None</defaultValue>
                    <trim>true</trim>
                </hudson.model.StringParameterDefinition>
                <hudson.model.StringParameterDefinition>
                    <name>ImageFullName</name>
                    <defaultValue>None</defaultValue>
                    <trim>true</trim>
                </hudson.model.StringParameterDefinition>
                <hudson.model.StringParameterDefinition>
                    <name>GitUrl</name>
                    <defaultValue>None</defaultValue>
                    <trim>true</trim>
                </hudson.model.StringParameterDefinition>
                <io.jenkins.plugins.file__parameters.StashedFileParameterDefinition
                        plugin="file-parameters@146.v7d35212829d0">
                    <name>DockerfileInLocal</name>
                </io.jenkins.plugins.file__parameters.StashedFileParameterDefinition>
                <hudson.model.StringParameterDefinition>
                    <name>UUID</name>
                    <defaultValue>None</defaultValue>
                    <trim>true</trim>
                </hudson.model.StringParameterDefinition>
                <hudson.model.StringParameterDefinition>
                    <name>GitBranch</name>
                    <defaultValue>None</defaultValue>
                    <trim>true</trim>
                </hudson.model.StringParameterDefinition>
                <hudson.model.StringParameterDefinition>
                    <name>CommitId</name>
                    <defaultValue>None</defaultValue>
                    <trim>true</trim>
                </hudson.model.StringParameterDefinition>
            </parameterDefinitions>
        </hudson.model.ParametersDefinitionProperty>
    </properties>
    <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps@2.92">
        <script>pipeline {
            agent {
            label "jenkins-jenkins-agent"
            }
            parameters {
            string name: 'UUID', defaultValue: 'None'
            string name: 'AppName', defaultValue: 'None'
            string name: 'GitUrl', defaultValue: 'None'
            string name: 'GitBranch', defaultValue: 'None'
            string name: 'CommitId', defaultValue: 'None'
            string name: 'ImageFullName', defaultValue: 'None'
            stashedFile 'DockerfileInLocal'
            }
            stages {
            stage('echo received params:') {
            steps {
            echo "params.AppName: ${params.AppName}"
            echo "params.GitUrl: ${params.GitUrl}"
            echo "params.ImageFullName: ${params.ImageFullName}"
            echo "-> unstash file from param:"
            unstash 'DockerfileInLocal'
            sh 'ls -alFh'
            }
            }
            }
            }
        </script>
        <sandbox>true</sandbox>
    </definition>
    <triggers/>
    <!--    <quietPeriod>5</quietPeriod>-->
    <disabled>false</disabled>
</flow-definition>