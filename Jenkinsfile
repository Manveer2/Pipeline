pipeline {
  agent any

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
        bat 'pip install --upgrade pip'
        bat 'pip install gitleaks checkov trivy syft'
      }
    }

    stage('Secrets Scan') {
      steps {
        bat 'gitleaks detect --source . --report-path gitleaks-report.json || exit /b 0'
      }
    }

    stage('IaC Security') {
      steps {
        bat 'checkov -d infrastructure || exit /b 0'
      }
    }

    stage('SAST') {
      steps {
        bat 'wsl semgrep --config auto . || exit /b 0'
      }
    }

    stage('Build Docker Image') {
      steps {
        bat 'docker build -t %IMAGE_NAME% .'
      }
    }

    stage('Container Scanning') {
      steps {
        bat 'trivy image %IMAGE_NAME% || exit /b 0'
      }
    }

    stage('SBOM + Signing') {
      steps {
        bat 'syft %IMAGE_NAME% -o spdx > sbom.spdx || exit /b 0'
      }
    }

    stage('DAST') {
      steps {
        bat '''
          docker run -d -p 5000:8080 --name testapp %IMAGE_NAME%
          timeout /t 10
          nikto -h http://localhost:5000 || exit /b 0
          docker stop testapp && docker rm testapp
        '''
      }
    }
  }
}
