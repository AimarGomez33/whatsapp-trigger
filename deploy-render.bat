@echo off
echo.
echo 🎨 DEPLOY CON RENDER
echo ===================
echo.

echo 📋 Pasos para deploy en Render.com:
echo.
echo 1️⃣  PREPARACIÓN:
echo    - Sube tu código a GitHub
echo    - Ve a: https://render.com  
echo    - Registrate con GitHub
echo.
echo 2️⃣  CREAR SERVICIO:
echo    - Click "New" → "Web Service"
echo    - Conecta tu repositorio GitHub
echo    - Branch: main
echo    - Build Command: npm install
echo    - Start Command: node src/index.js
echo.
echo 3️⃣  CONFIGURACIÓN:
echo    - Nombre: whatsapp-webhook-bot
echo    - Environment: Node
echo    - Plan: Free
echo.

set /p choice="¿Ya tienes el código en GitHub? (y/n): "

if /i "%choice%"=="n" goto github_setup
if /i "%choice%"=="no" goto github_setup
goto render_setup

:github_setup
echo.
echo 📦 SUBIR A GITHUB:
echo ==================
echo.
echo 1. Ve a: https://github.com/new
echo 2. Nombre del repo: whatsapp-webhook-bot
echo 3. Público o privado (ambos funcionan)
echo 4. NO agregues README, .gitignore ni license
echo 5. Click "Create repository"
echo.

set /p repo_url="🔗 Pega la URL del repositorio creado: "

if "%repo_url%"=="" (
    echo ❌ URL requerida
    pause
    exit /b 1
)

echo.
echo 🔄 Subiendo código a GitHub...

:: Inicializar git si no existe
if not exist .git (
    git init
    git add .
    git commit -m "Initial commit - WhatsApp Webhook Bot"
)

:: Agregar remoto y push
git remote add origin %repo_url% 2>nul
git branch -M main
git push -u origin main

if errorlevel 1 (
    echo ❌ Error subiendo a GitHub
    echo 🔧 Verifica que git esté configurado y tengas acceso al repo
    pause
    exit /b 1
)

echo ✅ Código subido a GitHub!
echo.

:render_setup
echo.
echo 🎨 CONFIGURAR EN RENDER:
echo =======================
echo.
echo 📋 Ahora ve a Render y configura:
echo.
echo 1. Abre: https://render.com
echo 2. Click "New" → "Web Service"  
echo 3. Conecta con tu repositorio
echo 4. Configuración:
echo    ┌─────────────────────────────────┐
echo    │ Name: whatsapp-webhook-bot      │
echo    │ Environment: Node               │
echo    │ Build Command: npm install      │
echo    │ Start Command: node src/index.js│
echo    │ Plan: Free                      │
echo    └─────────────────────────────────┘
echo.
echo 5. Variables de entorno (Environment):
echo    ┌─────────────────────────────────┐
echo    │ PORT = 10000                    │
echo    │ WEBHOOK_URL = (la de n8n)       │
echo    │ DEBUG = true                    │
echo    └─────────────────────────────────┘
echo.
echo 6. Click "Create Web Service"
echo.

start https://render.com

echo ⏳ Render tardará 5-10 minutos en hacer el deploy
echo 📱 La URL será: https://whatsapp-webhook-bot.onrender.com
echo.

pause

echo.
echo 📋 DESPUÉS DEL DEPLOY:
echo ======================
echo.
echo 1. Copia la URL de Render
echo 2. Ve a tu n8n workflow
echo 3. En el nodo HTTP Request, cambia:
echo    - URL: https://tu-app.onrender.com/send-message
echo.
echo 4. Para enviar mensajes desde n8n:
echo    ┌─────────────────────────────────────────────┐
echo    │ POST https://tu-app.onrender.com/send-message│
echo    │ {                                           │
echo    │   "number": "{{$json.from.split('@')[0]}}", │
echo    │   "message": "Tu respuesta automática"      │
echo    │ }                                           │
echo    └─────────────────────────────────────────────┘
echo.
pause
