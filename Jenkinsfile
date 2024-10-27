pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                script {
                    docker.build("wordpress_custom")
                }
            }
        }
        stage('Lint') {
            steps {
                sh 'docker run --rm -v ${WORKSPACE}/wp-content:/var/www/html/wp-content wordpress:cli php -l /var/www/html/wp-content'
            }
        }
        stage('Test') {
            steps {
                script {
                    // Запуск контейнеров с помощью docker-compose
                    sh 'docker-compose up -d'
                    // Увеличенное время ожидания перед выполнением curl
                    sleep 60

                    // Проверка статуса контейнеров для диагностики
                    sh 'docker ps'
                    
                    retry(5) {
                        sleep 10
                        sh 'curl -I http://localhost:5002 | grep "200 OK"'
                    }
                }
            }
        }
        stage('Deploy') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo 'Deploying application...'
                // Шаги по развертыванию приложения
            }
        }
    }
    post {
        always {
            // Останов и удаление контейнеров
            sh 'docker-compose down'
        }
    }
}
