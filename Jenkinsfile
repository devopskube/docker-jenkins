#!/usr/bin/env groovy
@Grab('org.yaml:snakeyaml:1.17')
import org.yaml.snakeyaml.*

/* Only keep the 5 most recent builds. */
def projectProperties = [
        buildDiscarder(logRotator(numToKeepStr: '5')),
        disableConcurrentBuilds(),
        [$class: 'GithubProjectProperty', displayName: 'Docker Jenkins', projectUrlStr: 'https://github.com/devopskube/docker-jenkins.git']
]
properties(projectProperties)

def IMAGE_NAME = 'devopskube/jenkins'
def tag_name = ''
def image_name = ''
def dockerUser = "${System.env.'DOCKER_USER'}"
def dockerPwd = "${System.env.'DOCKER_PWD'}"

podTemplate(label: 'docker-mysql', containers: [
            containerTemplate(name: 'jnlp', image: 'jenkinsci/jnlp-slave:2.62-alpine', args: '${computer.jnlpmac} ${computer.name}'),
            containerTemplate(name: 'docker', image: 'docker:1.12.3-dind', ttyEnabled: true, command: 'cat', privileged: true, instanceCap: 1)
        ],
        volumes: [
            hostPathVolume(mountPath: "/var/run/docker.sock", hostPath: "/var/run/docker.sock")
        ]) {
    node() {
        stage('Checkout') { // happens on master?
            git url: 'https://github.com/devopskube/docker-mysql.git'
            tag_name = sh (
                    script: 'git tag -l --points-at HEAD',
                    returnStdout: true
            ).trim()

            def projectFile = readFile("project.yml")

            Yaml yaml = new Yaml();
            Map map = (Map) yaml.load(projectFile);
            image_name = map.get("imageName")
        }
        container('docker') {
            stage('Build') {
                println("Build ${IMAGE_NAME}")
                sh("docker build -t ${IMAGE_NAME} .")
            }
            stage('Tag and Push latest') {
                println("Tagging ${IMAGE_NAME}:latest")
                sh "docker tag ${IMAGE_NAME} ${IMAGE_NAME}:latest"

                println("Login in to docker registry")
                sh "docker login --username ${dockerUser} --password ${dockerPwd}"

                println("pushing latest")
                sh "docker push ${IMAGE_NAME}:latest"
            }
            stage('Tag and Push concrete Tag') {
                if (tag_name?.trim()) {
                    println("Tagging ${IMAGE_NAME}:${tag_name}")
                    sh "docker tag ${IMAGE_NAME} ${IMAGE_NAME}:${tag_name}"

                    println("Login in to docker registry")
                    sh "docker login --username ${dockerUser} --password ${dockerPwd}"

                    println "pushing ${tag_name}"
                    sh "docker push ${IMAGE_NAME}:${tag_name}"
                }
                else {
                    println("Pushing concrete Tag not necessary")
                }
            }
        }
    }
}
