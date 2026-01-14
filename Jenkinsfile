pipeline {
    agent any

    tools {
        maven 'MAVEN'
    }

    environment {
        IMAGE_NAME = 'my-java-app'
        NVD_API_KEY = credentials('NVD_API_KEY')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sky91win/Project6.git'
            }
        }

        stage('Maven Build + OWASP Dependency Check') {
            steps {
                sh '''
                  echo "Using system Java"
                  java -version
                  mvn -version

                  mvn clean verify \
                    org.owasp:dependency-check-maven:check
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    withSonarQubeEnv('sonarqube') {
                        sh 'mvn sonar:sonar -Dsonar.projectKey=my-java-app'
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                  if command -v docker >/dev/null 2>&1; then
                    docker build -t ${IMAGE_NAME}:latest .
                  else
                    echo "⚠ Docker not installed"
                  fi
                '''
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                  if command -v trivy >/dev/null 2>&1; then
                    trivy image ${IMAGE_NAME}:latest || true
                  else
                    echo "⚠ Trivy not installed"
                  fi
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                  if command -v docker >/dev/null 2>&1; then
                    docker stop ${IMAGE_NAME} || true
                    docker rm ${IMAGE_NAME} || true
                    docker run -d --name ${IMAGE_NAME} -p 8085:8085 ${IMAGE_NAME}:latest
                  else
                    echo "⚠ Docker not installed"
                  fi
                '''
            }
        }
    }

    post {
        success {
            echo "✅ DevSecOps Pipeline completed successfully"
        }
        failure {
            echo "❌ Pipeline failed – check logs"
        }
    }
}
