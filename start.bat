@echo off
echo 🚀 Iniciando WhatsApp Webhook Trigger...
echo.

REM Verificar si Node.js está instalado
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js no está instalado. Por favor instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

REM Verificar si las dependencias están instaladas
if not exist "node_modules" (
    echo 📦 Instalando dependencias...
    npm install
    if errorlevel 1 (
        echo ❌ Error instalando dependencias
        pause
        exit /b 1
    )
)

REM Verificar si existe el archivo .env
if not exist ".env" (
    echo ⚠️  Archivo .env no encontrado. Creando uno por defecto...
    echo PORT=3000 > .env
    echo HOST=localhost >> .env
    echo WEBHOOK_URL=https://n8n-kubectl.42web.io/webhook/whatsapp-bot >> .env
    echo DEBUG=true >> .env
    echo.
    echo ✅ Archivo .env creado. Puedes editarlo para personalizar la configuración.
    echo.
)

echo 📱 Iniciando servidor principal...
echo.
echo Endpoints disponibles:
echo   📊 Estado: http://localhost:3000/status
echo   📱 QR Code: http://localhost:3000/qr
echo   💬 Enviar mensaje: POST http://localhost:3000/send-message
echo.
echo 💡 Para el servidor de pruebas, ejecuta en otra terminal:
echo    node src/test-webhook-server.js
echo.
echo 🧪 Para simular mensajes de prueba:
echo    node simulate-message.js
echo.
echo ⚠️  IMPORTANTE: Los mensajes que te envías a TI MISMO no funcionan
echo    Necesitas que OTRA PERSONA te envíe un WhatsApp
echo.
echo ⚠️  La primera vez necesitarás escanear el código QR con WhatsApp
echo.

npm start
