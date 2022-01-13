def Version = "v1.0.${BUILD_NUMBER}"
pipeline {
  agent {
    kubernetes { 
      cloud 'kubernetes'
      inheritFrom 'jnlp'
      // containerTemplate { name 'maven' image 'maven:3-alpine' ttyEnabled true command 'cat' }
    }
  }

  stages {
    stage('代码编译打包') {
        steps {
            echo "代码编译打包....${env.BRANCH_NAME}" 
            // container('maven') {
            //     sh 'mvn -version'
            //     sh 'mvn -B -DskipTests clean package'
            // }
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