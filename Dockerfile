# Используем официальный образ Node.js для сборки React-приложения
FROM node:16 AS builder

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем файлы package.json и package-lock.json и устанавливаем зависимости
COPY package*.json ./
RUN npm install

# Копируем все остальные файлы проекта
COPY . .

# Собираем проект
RUN npm run build

# Используем образ Nginx для запуска приложения React
FROM nginx:alpine

# Копируем собранные файлы React из предыдущего этапа в контейнер Nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Определяем порт, на котором будет работать Nginx
EXPOSE 80

# Запускаем Nginx
CMD ["nginx", "-g", "daemon off;"]