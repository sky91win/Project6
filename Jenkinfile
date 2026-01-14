pipeline {
    agent any

    tools {
        maven 'MAVEN'
        jdk 'JDK17'
    }

    environment {
        SONARQUBE_ENV = 'sonarqube'
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
                    -Dsonar.host.url=http://<sonar-ip>:9000 \
                    -Dsonar.login=<SONAR_TOKEN>
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
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image $IMAGE_NAME:latest'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 8080:8080 $IMAGE_NAME:latest'
            }
        }
    }
}
