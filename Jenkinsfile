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
                    sh 'docker-compose up -d'  // Запускаем контейнеры перед тестом
                    sh 'sleep 10'              // Ожидаем запуска контейнеров
                    sh 'curl -I http://localhost:5002 | grep "200 OK"'  // Тестируем доступность
                }
            }
        }
        stage('Deploy') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                echo 'Deployment stage...'
                // Добавьте команды деплоя, если нужно
            }
        }
    }
    post {
        always {
            sh 'docker-compose down'
        }
    }
}
