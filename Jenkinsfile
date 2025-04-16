pipeline {
  agent any

  tools {
    python 'Python3'
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

    stage('Secrets Scan') {
      steps {
        bat 'gitleaks detect --source . --report-path gitleaks-report.json'
      }
    }

    stage('IaC Security') {
      steps {
        bat 'checkov -d infrastructure/'
        bat 'tfsec infrastructure/'
      }
    }

    stage('SAST') {
      steps {
        bat 'semgrep --config auto .'
      }
    }

    stage('Build Docker Image') {
      steps {
        bat 'docker build -t %IMAGE_NAME% .'
      }
    }

    stage('Container Scanning') {
      steps {
        bat 'trivy image %IMAGE_NAME%'
        bat 'grype %IMAGE_NAME%'
        bat 'dockle %IMAGE_NAME%'
      }
    }

    stage('SBOM + Signing') {
      steps {
        bat 'syft %IMAGE_NAME% -o spdx > sbom.spdx'
        bat 'cosign sign --key cosign.key %IMAGE_NAME%'
      }
    }

    stage('DAST') {
      steps {
        bat 'docker run -d -p 8080:8080 --name testapp %IMAGE_NAME%'
        bat 'nikto -h http://localhost:8080'
        bat 'docker stop testapp && docker rm testapp'
      }
    }
  }
}
