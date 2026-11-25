
pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-java-app"
        IMAGE_TAG  = "latest"
        APP_PORT   = "8081"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                echo "Building Java application..."
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo "Deploying application..."

                sh '''
                    docker compose up -d --build
                    docker ps
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo "Checking application health..."

                sh '''
                    for i in $(seq 1 12); do
                        if curl -fsS http://localhost:${APP_PORT}/; then
                            echo "Application is UP!"
                            exit 0
                        fi

                        echo "Waiting for application..."
                        sleep 5
                    done

                    echo "Application health check failed!"
                    exit 1
                '''
            }
        }
    }

    post {
        success {
            echo "DEPLOYMENT SUCCESSFUL!"
            echo "Application URL: http://<EC2-PUBLIC-IP>:8081"
        }

        failure {
            echo "BUILD OR DEPLOYMENT FAILED - Check Jenkins logs."
        }

        always {
            echo "Pipeline execution completed."
        }
    }
}
