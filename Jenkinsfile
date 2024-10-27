pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t wordpress_custom .'
            }
        }
        stage('Lint') {
            steps {
                sh 'docker run --rm -v $PWD/wp-content:/var/www/html/wp-content wordpress:cli php -l /var/www/html/wp-content'
            }
        }
        stage('Test') {
            steps {
                script {
                    sh 'docker-compose up -d'  // Запуск контейнеров
                    
                    // Проверяем доступность контейнера на порту 5002
                    retry(5) {
                        sleep 10
                        sh 'curl -I http://localhost:5002 | grep "200 OK"'
                    }
                }
            }
        }
        stage('Deploy') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo 'Deployment stage...'
            }
        }
    }
    post {
        always {
            sh 'docker-compose down'
        }
    }
}
