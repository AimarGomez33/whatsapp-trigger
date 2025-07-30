@echo off
echo.
echo 🏠 NGROK - SOLUCIÓN RÁPIDA TEMPORAL
echo ==================================
echo.

echo 📋 ngrok es perfecto para:
echo - Pruebas inmediatas
echo - Desarrollo local  
echo - Verificar que todo funciona
echo.
echo ⚠️  LIMITACIÓN: La URL cambia cada vez que reinicias
echo.

where ngrok >nul 2>&1
if errorlevel 1 (
    echo ❌ ngrok no está instalado
    echo.
    echo 📦 INSTALACIÓN:
    echo 1. Ve a: https://ngrok.com/download
    echo 2. Descarga ngrok para Windows
    echo 3. Descomprime en una carpeta
    echo 4. Agrega la carpeta al PATH
    echo.
    echo 💡 O instala con chocolatey:
    echo    choco install ngrok
    echo.
    start https://ngrok.com/download
    pause
    exit /b 1
)

echo ✅ ngrok está instalado
echo.

:: Verificar que el servidor local esté corriendo
echo 🔍 Verificando servidor local...
curl -s http://localhost:3000/status >nul 2>&1
if errorlevel 1 (
    echo ❌ El servidor local no está corriendo en puerto 3000
    echo 🔧 Inicia primero: node src/index.js
    echo.
    set /p choice="¿Quieres iniciarlo ahora? (y/n): "
    if /i "!choice!"=="y" (
        echo 🚀 Iniciando servidor...
        start cmd /k "cd /d "%cd%" && node src/index.js"
        echo ⏳ Esperando 5 segundos...
        timeout /t 5 >nul
    ) else (
        pause
        exit /b 1
    )
)

echo ✅ Servidor local corriendo
echo.

echo 🚀 Iniciando túnel ngrok...
echo ⏳ Se abrirá una nueva ventana con ngrok
echo.

start cmd /k "ngrok http 3000"

echo ⏳ Esperando que ngrok se inicie...
timeout /t 3 >nul

echo.
echo 📋 PASOS SIGUIENTES:
echo ==================
echo.
echo 1. En la ventana de ngrok, busca la línea:
echo    "Forwarding    https://xxxxxxxx.ngrok.io -> http://localhost:3000"
echo.
echo 2. Copia la URL de ngrok (https://xxxxxxxx.ngrok.io)
echo.
echo 3. Actualiza tu webhook de n8n con:
echo    https://xxxxxxxx.ngrok.io/webhook/whatsapp-bot
echo.
echo 4. O actualiza el .env de este proyecto con:
echo    WEBHOOK_URL=https://tu-n8n.com/webhook/whatsapp-bot
echo.
echo ⚠️  IMPORTANTE: 
echo    - La URL de ngrok cambia cada vez que lo reinicias
echo    - Para una URL fija, regístrate en ngrok.com
echo.

set /p ngrok_url="🔗 Pega la URL de ngrok aquí para actualizar .env: "

if not "%ngrok_url%"=="" (
    echo.
    echo 📝 Actualizando .env...
    
    echo # Variables del servidor > .env.new
    echo PORT=3000 >> .env.new
    echo HOST=localhost >> .env.new
    echo. >> .env.new
    echo # URL del webhook donde enviar los mensajes recibidos >> .env.new
    echo WEBHOOK_URL=%ngrok_url% >> .env.new
    echo # Configuracion de la API REST (opcional) >> .env.new
    echo API_KEY=tu_api_key_aqui >> .env.new
    echo. >> .env.new
    echo # Configuracion adicional >> .env.new
    echo DEBUG=true >> .env.new
    
    move .env .env.backup >nul 2>&1
    move .env.new .env >nul 2>&1
    
    echo ✅ .env actualizado con ngrok URL
    echo 🔄 Reinicia el servidor para aplicar cambios
)

echo.
echo 🎯 PARA PRUEBAS:
echo ===============
echo 1. Envía un mensaje a tu WhatsApp
echo 2. Deberías ver el POST en la ventana de ngrok
echo 3. Si tienes n8n configurado, debería ejecutarse
echo.
pause
