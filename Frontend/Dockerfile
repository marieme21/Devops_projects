# Étape 1 : Build de l'application
FROM node:18-alpine AS build

# Crée un dossier de travail dans le conteneur
WORKDIR /app

# Copie package.json ET package-lock.json avant npm install
COPY package*.json ./

# Installe les dépendances
RUN npm install

# Copie le reste des fichiers du projet
COPY . .

# Build de l'application (React, Vue, etc.)
RUN npm run build

# Étape 2 : Phase de production
FROM nginx:stable-alpine AS production

# Copie de la config nginx
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copie les fichiers générés depuis le build vers nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Exposition du port
EXPOSE 80

# Commande pour lancer nginx
CMD ["nginx", "-g", "daemon off;"]
