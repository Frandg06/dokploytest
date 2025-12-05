# Usamos la imagen oficial de PHP con Apache (ya incluye el servidor web)
FROM php:8.2-apache

# 1. Instalar dependencias mínimas necesarias para Laravel y MySQL
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# 2. Activar mod_rewrite de Apache (Vital para las rutas de la API de Laravel)
RUN a2enmod rewrite

# 3. Cambiar la raíz de Apache a la carpeta /public de Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# 4. Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Copiar los archivos del proyecto
WORKDIR /var/www/html
COPY . .

# 6. Instalar paquetes de Composer (Optimizado para producción)
RUN composer install --no-dev --optimize-autoloader

# 7. Dar permisos a las carpetas de almacenamiento
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 8. Comandos finales de optimización de Laravel
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan migrate --force

# El puerto 80 ya viene expuesto por defecto en esta imagen
EXPOSE 80