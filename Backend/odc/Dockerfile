# 1. Utiliser une image de base avec Python
FROM python:3.10-slim

# 2. Définir le répertoire de travail dans le conteneur
WORKDIR /app

# 3. Copier les fichiers du projet dans le conteneur
COPY . /app

# 4. Installer les dépendances
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# 5. Exposer le port de Django
EXPOSE 8000

# 6. Commande pour démarrer le serveur
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
