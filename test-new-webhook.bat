@echo off
echo.
echo =======================================================
echo 🚀 PRUEBA COMPLETA DEL NUEVO WEBHOOK
echo =======================================================
echo.

:: Cambiar al directorio del proyecto
cd /d "c:\Users\jair_\Desktop\trigger"

:: Verificar si Node.js está instalado
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js no está instalado
    echo Descárgalo de: https://nodejs.org/
    pause
    exit /b 1
)

:: Verificar dependencias
if not exist "node_modules" (
    echo 📦 Instalando dependencias...
    npm install
)

:: Ejecutar la prueba
echo 🧪 Iniciando prueba del webhook...
echo.
node test-new-webhook.js

echo.
echo =======================================================
echo 🎯 PRÓXIMOS PASOS SI TODO FUNCIONÓ:
echo =======================================================
echo 1. Tu servidor local debe estar corriendo (npm start)
echo 2. WhatsApp debe estar conectado (QR escaneado)
echo 3. El workflow debe estar ACTIVO en n8n
echo 4. Envía un WhatsApp desde OTRO teléfono para probar
echo.
pause
