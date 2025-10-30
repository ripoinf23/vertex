FROM ubuntu:22.04

# Eviter les questions interactives pendant l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour et installer les dépendances de base
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    libglu1-mesa \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Installer Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Accepter les licences Flutter et vérifier l'installation
RUN flutter precache && flutter doctor

# Définir le répertoire de travail
WORKDIR /workspace

# Exposer le port pour l'application Flutter
EXPOSE 8080
