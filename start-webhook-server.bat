@echo off
echo 🎯 Iniciando servidor de pruebas para webhooks...
echo.

REM Verificar si Node.js está instalado
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js no está instalado. Por favor instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

echo 📡 Servidor de webhooks iniciando...
echo.
echo Endpoints disponibles:
echo   🌐 Monitor web: http://localhost:3001
echo   📥 Webhook: http://localhost:3001/webhook/whatsapp
echo   📋 Mensajes: http://localhost:3001/messages
echo   📊 Estado: http://localhost:3001/status
echo.

node src/test-webhook-server.js
