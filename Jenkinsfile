pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'wordpress_custom'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    // Собираем Docker-образ для WordPress
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Lint') {
            steps {
                script {
                    // Проверяем PHP файлы на ошибки синтаксиса
                    sh 'docker run --rm -v "$PWD/wp-content":/var/www/html/wp-content wordpress:cli php -l /var/www/html/wp-content'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Запускаем контейнеры для тестирования
                    sh 'docker-compose up -d'
                    sleep 20  // Ждём, чтобы сервисы были готовы
                    retry(5) {
                        sleep 10
                        // Проверяем доступность WordPress
                        sh 'curl -I http://localhost:5002 | grep "200 OK"'
                    }
                }
            }
        }

        stage('Deploy') {
            when {
                expression { return currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    // Команды для деплоя, если это требуется
                    echo 'Deployment steps here...'
                }
            }
        }
    }

    post {
        always {
            script {
                // Завершаем и удаляем все контейнеры после выполнения
                sh 'docker-compose down'
            }
        }
    }
}
