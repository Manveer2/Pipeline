pipeline {
  agent {
    docker {
      image 'python:3.9'
      args '-v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  environment {
    IMAGE_NAME = "mysecureapp"
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/Manveer2/Pipeline.git'
      }
    }

    stage('Install Python Tools') {
      steps {
        sh '''
          pip install --no-cache-dir gitleaks checkov semgrep trivy grype dockle syft
        '''
      }
    }

    stage('Secrets Scan') {
      steps {
        sh 'gitleaks detect --source . --report-path gitleaks-report.json || true'
      }
    }

    stage('IaC Security') {
      steps {
        sh '''
          checkov -d infrastructure/ || true
          tfsec infrastructure/ || true
        '''
      }
    }

    stage('SAST') {
      steps {
        sh 'semgrep --config auto . || true'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Container Scanning') {
      steps {
        sh '''
          trivy image $IMAGE_NAME || true
          grype $IMAGE_NAME || true
          dockle $IMAGE_NAME || true
        '''
      }
    }

    stage('SBOM + Signing') {
      steps {
        sh '''
          syft $IMAGE_NAME -o spdx > sbom.spdx || true
          cosign sign --key cosign.key $IMAGE_NAME || true
        '''
      }
    }

    stage('DAST') {
      steps {
        sh '''
          docker run -d -p 5000:8080 --name testapp $IMAGE_NAME
          sleep 10
          nikto -h http://localhost:5000 || true
          docker stop testapp && docker rm testapp
        '''
      }
    }
  }
}
