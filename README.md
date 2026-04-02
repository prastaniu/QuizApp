## 📦 Prerequisites

### Backend Requirements
- PHP 8.0+
- MySQL 5.7+
- Composer
- Laravel 9+

### Frontend Requirements
- Node.js 14+ and npm 6+
- Vue 3+
- Modern web browser

### 1. Backend Setup (Laravel)

####  Install Dependencies
```bash
composer install
```
#### Environment Configuration
```bash
# Copy the example .env file
copy .env.example .env


# Generate application key
php artisan key:generate
```

#### Configure Database
Edit `.env` file and set your database credentials:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=quiz_app
DB_USERNAME=root
DB_PASSWORD=
```

#### Create Database
```bash
# Create the database in MySQL
mysql -u root -p
CREATE DATABASE quiz_app;
exit;
```

#### Run Migrations
```bash
php artisan migrate
```

#### Create Passport Keys (Optional - for OAuth)
```bash
php artisan passport:install
```

#### Start the Backend Server
```bash
php artisan serve
```

The backend will be available at: **http://localhost:8000**

#### ######################################################


### 2. Frontend Setup (Vue)
#### Install Dependencies
```bash
npm install
```


#### Configure API Base URL
The API base URL is configured in `src/services/api.js` and `vite.config.js`:
```javascript
baseURL: '/api'  // Proxies to http://localhost:8000/api
```

#### Start Development Server
```bash
npm run dev
```

The frontend will be available at: **http://localhost:5173**

