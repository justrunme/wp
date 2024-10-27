pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "wordpress_custom"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Сборка пользовательского образа WordPress (если требуется)
                    DOCKER_IMAGE = docker.build("${DOCKER_IMAGE}", ".")
                }
            }
        }

        stage('Lint') {
            steps {
                script {
                    // Запуск PHP-кода через линтер, чтобы поймать ошибки синтаксиса и другие проблемы
                    sh 'docker run --rm -v $(pwd)/wp-content:/var/www/html/wp-content wordpress:cli php -l /var/www/html/wp-content'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Простое тестирование доступности страницы
                    sh 'curl -I http://localhost:5002 | grep "200 OK"'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Развертывание контейнера WordPress с использованием docker-compose
                    sh 'docker-compose down' // Останавливаем контейнеры перед обновлением
                    sh 'docker-compose up -d' // Запускаем контейнеры в режиме detached
                }
            }
        }
    }

    post {
        always {
            script {
                // Завершение и удаление контейнеров после запуска
                sh 'docker-compose down'
            }
        }
    }
}
