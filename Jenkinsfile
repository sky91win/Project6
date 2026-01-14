pipeline {
    agent any

    tools {
        maven 'MAVEN'
    }

    environment {
        IMAGE_NAME = 'my-java-app'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sky91win/Project6.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh '''
                echo "Using system Java"
                which java
                java -version
                mvn -version
                mvn clean package
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''
                    mvn sonar:sonar \
                      -Dsonar.projectKey=my-java-app
                    '''
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                sh '''
                if [ -f /opt/dependency-check/bin/dependency-check.sh ]; then
                  /opt/dependency-check/bin/dependency-check.sh \
                    --project "java-demo-app" \
                    --scan . \
                    --format HTML \
                    --out dependency-check-report
                else
                  echo "⚠ OWASP Dependency-Check not installed, skipping stage"
                fi
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                if command -v docker >/dev/null 2>&1; then
                  docker build -t ${IMAGE_NAME}:latest .
                else
                  echo "⚠ Docker not installed, skipping Docker build"
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
                  echo "⚠ Trivy not installed, skipping scan"
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
                  docker run -d --name ${IMAGE_NAME} -p 8080:8080 ${IMAGE_NAME}:latest
                else
                  echo "⚠ Docker not installed, skipping container run"
                fi
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully"
        }
        failure {
            echo "❌ Pipeline failed – check logs"
        }
    }
}
