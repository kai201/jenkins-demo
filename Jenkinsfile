def Version = "v1.0.${BUILD_NUMBER}"
def SolutionName = "dotnet" //"${JOB_NAME.replaceAll("/","-").replaceAll("%2F","/")}";
pipeline {
  agent {
    kubernetes { 
      cloud 'kubernetes'
      inheritFrom 'jnlp'
      // containerTemplate {
      //   name 'dotnet'
      //   // image 'mcr.microsoft.com/dotnet/sdk:5.0'
      //   image 'yeohang/sonarscanner-dotnet-runtime:5.0'
      //   ttyEnabled true
      //   command 'cat'
      // }
    }
  }

  stages {
    stage('代码编译打包') {
        steps {
            sh 'java --version'
            // container('dotnet') {
            //   sh 'java --version'
            //   echo "代码编译打包....${env.BRANCH_NAME}" 
            //   sh 'dotnet --version'
            //   // sh 'dotnet build'
            // }
        }
    }

    stage('代码分析-DotNet') {
        steps{
          withSonarQubeEnv('sonarqube') { 
          //   container('dotnet') { 
          //     dir('dotnet'){
          //       sh """
          //       export PATH=$PATH:/root/.dotnet/tools && \
          //       dotnet --version  && \
          //       dotnet tool install --global dotnet-sonarscanner --version 5.4.1  && \
          //       dotnet sonarscanner begin /k:dotnet /n:dotnet /v:${Version} && \
          //       dotnet build && \
          //       dotnet sonarscanner end
          //       """ 
          //   }
          // }
          }
        }
    }

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
            // container('kubectl') {
            //     echo "部署....${env.BRANCH_NAME}" 
            //     sh "which kubectl"
            // }

            sshPublisher(publishers: [
                    sshPublisherDesc(configName: 'mengtu', transfers: [
                        sshTransfer(execCommand: 'ls && cd www/java && mv -f README.md TEST.md',remoteDirectory: 'www/java',sourceFiles:'README.md',removePrefix:'')
                    ])
            ])
        }
    }
  }

  post { 
    success { echo "success"  }
    failure { echo "failure"  }
    always  { echo "always"  }
  }
}