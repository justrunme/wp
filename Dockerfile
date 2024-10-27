# Используем официальный образ WordPress
FROM wordpress:latest

# Устанавливаем нужные плагины, темы или пакеты, если требуется
# Например, копируем кастомные файлы
COPY ./wp-content /var/www/html/wp-content

EXPOSE 80
