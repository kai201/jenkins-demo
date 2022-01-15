def Version = "v1.0.${BUILD_NUMBER}"
def SolutionName = "${JOB_NAME.replace("/","-")}";
pipeline {
  agent {
    kubernetes { 
      cloud 'kubernetes'
      inheritFrom 'jnlp'
      containerTemplate {
        name 'maven'
        image 'maven:3-jdk-11'
        ttyEnabled true
        command 'cat'
      }
    }
  }

  stages {
    stage('代码编译打包') {
        steps {
            container('maven') {
                echo "${SolutionName}"
                echo "代码编译打包....${env.BRANCH_NAME}" 
                sh "mvn -version"
                // sh 'mvn -B -DskipTests clean package'
            }
        }
    }

    stage('代码分析') {
        steps{
          withSonarQubeEnv('sonarqube') {
            container('maven') { 
              // dir('examine'){
              // }
              sh 'java -version'
              sh "mvn package sonar:sonar -Dsonar.projectName=${SolutionName} -Dsonar.projectKey=${SolutionName}"
              // sh "mvn package sonar:sonar -Dsonar.branch.name=${env.BRANCH_NAME}"
            }
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