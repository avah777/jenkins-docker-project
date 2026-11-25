pipeline {
  agent any

  environment {
    IMAGE_NAME = "my-java-app"
    IMAGE_TAG  = "latest"
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Checking out code..."
        checkout scm
      }
    }

    stage('Build with Maven') {
      steps {
        sh 'mvn clean package -DskipTests'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
      }
    }

    stage('Deploy with Docker Compose') {
      steps {
        sh '''
          docker compose down || true
          docker compose up -d --build
          docker ps
        '''
      }
    }

    stage('Health Check') {
      steps {
        sh '''
          sleep 5
          curl -f http://localhost:8081 || exit 1
          echo "App is UP!"
        '''
      }
    }
  }

  post {
    success {
      echo "DEPLOYED! Visit http://<EC2-IP>:8081"
    }
    failure {
      echo "Build Failed - check logs"
    }
  }
}
