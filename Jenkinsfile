def Version = "v1.0.${BUILD_NUMBER}"
def SolutionName = "${JOB_NAME.replace("/","-").replace("%2F","/")}"

pipeline {
  agent {
    kubernetes { 
      cloud 'kubernetes'
      inheritFrom 'jnlp'
      containerTemplate {
        name 'dotnet'
        // image 'mcr.microsoft.com/dotnet/sdk:5.0'
        image 'mcr.microsoft.com/dotnet/core/sdk:3.0'
        ttyEnabled true
        command 'cat'
      }
      // containerTemplate {
      //   name 'maven'
      //   image 'maven:3-jdk-11'
      //   ttyEnabled true
      //   command 'cat'
      // }
    }
  }

  stages {

    // stage('代码编译打包') {
    //     steps {
    //         container('maven') {
    //             echo "${SolutionName}"
    //             echo "代码编译打包....${env.BRANCH_NAME}" 
    //             // sh "mvn -version"
    //             // sh "which mvn"
    //             // sh 'mvn -B -DskipTests clean package'
    //         }
    //     }
    // }



    stage('代码分析-DotNet') {
        steps{
          withSonarQubeEnv('sonarqube') {
            container('dotnet') { 
              dir('dotnet'){
                sh """
                export PATH=$PATH:/root/.dotnet/tools && \
                dotnet --version  && \
                dotnet tool install --global dotnet-sonarscanner --version 5.4.1  && \
                dotnet sonarscanner begin /k:dotnet /n:dotnet /v:${Version} && \
                dotnet build && \
                dotnet sonarscanner end
                """
              }
            }
          }
        }
    }
    // stage('代码分析') {
    //     steps{
    //       withSonarQubeEnv('sonarqube') {
    //         container('maven') { 
    //           dir('java'){
    //             sh 'java -version'
    //             sh "mvn package sonar:sonar -Dsonar.projectName=${SolutionName} -Dsonar.projectKey=${SolutionName.replaceAll("/","_")}"
    //             // sh "mvn package sonar:sonar -Dsonar.branch.name=${env.BRANCH_NAME}"
    //           }
    //         }
    //       }
    //     }
    // }
    stage('提交镜像') {
        steps {
            container('kaniko') {
                script { 
                    echo "提交镜像....${env.BRANCH_NAME}" 
                    sh "which kaniko"
                }
            }
        }
    }

    stage('部署') {
        steps {
            container('kubectl') {
                echo "部署....${env.BRANCH_NAME}" 
                sh "which kubectl"
            }
        }
    }
  }

  post { 
    success { echo "success"  }
    failure { echo "failure"  }
    always  { echo "always"  }
  }

}