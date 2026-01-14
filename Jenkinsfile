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
                    sonar-scanner \
                      -Dsonar.projectKey=my-java-app \
                      -Dsonar.sources=src \
                      -Dsonar.java.binaries=target \
                      -Dsonar.host.url=http://34.234.88.51:9000
                    '''
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                sh '''
                /opt/dependency-check/bin/dependency-check.sh \
                  --project "java-demo-app" \
                  --scan . \
                  --format HTML \
                  --out dependency-check-report
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image ${IMAGE_NAME}:latest || true'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop ${IMAGE_NAME} || true
                docker rm ${IMAGE_NAME} || true
                docker run -d --name ${IMAGE_NAME} -p 8080:8080 ${IMAGE_NAME}:latest
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
