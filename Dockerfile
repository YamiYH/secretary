# Etapa 1: Compilación
FROM debian:bookworm-slim AS build-env

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y curl git unzip python3

# Clonar el SDK de Flutter (canal stable)
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Ejecutar doctor para descargar herramientas y configurar
RUN flutter doctor -v

# Copiar el código de la app al contenedor
WORKDIR /app
COPY . .

# Obtener dependencias y compilar para web
RUN flutter pub get
RUN flutter build web --release

# Etapa 2: Servidor de Producción
FROM nginx:stable-alpine

# Copiar los archivos compilados desde la etapa anterior
# Flutter genera la salida en build/web
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Exponer el puerto que Railway espera (por defecto Railway usa el 80 o asigna uno dinámico)
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]