# Étape 1 : Environnement pour construire Flutter Web
FROM debian:latest AS build-env

# Mettre à jour les dépôts et installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    libxi6 \
    libgtk-3-0 \
    libxrender1 \
    libxtst6 \
    libxslt1.1 \
    curl \
    git \
    wget \
    unzip \
    libgconf-2-4 \
    gdb \
    libstdc++6 \
    libglu1-mesa \
    fonts-droid-fallback \
    python3 \
    && apt-get clean

# Cloner Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Configurer le chemin de Flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Vérifier l'installation et configurer Flutter
RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Créer et configurer le répertoire de l'application
RUN mkdir /app/
COPY . /app/
WORKDIR /app/

# Construire l'application Flutter Web
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

# Étape 2 : Servir avec Nginx
FROM nginx:1.21.1-alpine

# Copier les fichiers construits depuis l'étape précédente
COPY --from=build-env /app/build/web /usr/share/nginx/html


# Exposer le port 80 (port interne de Nginx)
EXPOSE 8012