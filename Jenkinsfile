pipeline {
    agent any

    tools {
        maven 'MAVEN'
        jdk 'JDK17'
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
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''
                    mvn sonar:sonar \
                    -Dsonar.projectKey=my-java-app \
                    -Dsonar.host.url=http://34.234.88.51:9000
                    '''
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan .',
                                odcInstallation: 'OWASP'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t my-java-app:latest .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image my-java-app:latest'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop my-java-app || true
                docker rm my-java-app || true
                docker run -d --name my-java-app -p 8080:8080 my-java-app:latest
                '''
            }
        }
    }
}
