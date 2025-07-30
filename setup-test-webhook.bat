@echo off
echo.
echo 🌐 CONFIGURACION DE WEBHOOK DE PRUEBA
echo ===================================
echo.

echo 📋 Pasos para configurar webhook de prueba:
echo.
echo 1. Ve a: https://webhook.site/
echo 2. Copia la URL única que aparece (algo como: https://webhook.site/xxxxxx-xxxx-xxxx)
echo 3. Pega esa URL aquí:
echo.
set /p webhook_url="🔗 Nueva URL del webhook: "

if "%webhook_url%"=="" (
    echo ❌ URL requerida
    pause
    exit /b 1
)

echo.
echo 📝 Actualizando archivo .env...

:: Crear nuevo .env con la nueva URL
echo # Variables del servidor > .env.new
echo PORT=3000 >> .env.new
echo HOST=localhost >> .env.new
echo. >> .env.new
echo # URL del webhook donde enviar los mensajes recibidos >> .env.new
echo WEBHOOK_URL=%webhook_url% >> .env.new
echo # Configuracion de la API REST (opcional) >> .env.new
echo API_KEY=tu_api_key_aqui >> .env.new
echo. >> .env.new
echo # Configuracion adicional >> .env.new
echo DEBUG=true >> .env.new
echo. >> .env.new

:: Reemplazar el archivo original
move .env .env.backup >nul 2>&1
move .env.new .env >nul 2>&1

echo ✅ Archivo .env actualizado
echo ✅ Backup guardado como .env.backup
echo.
echo 🔄 Nueva configuración:
type .env
echo.
echo ⚠️  IMPORTANTE: Reinicia el servidor para aplicar los cambios
echo    1. Presiona Ctrl+C en la terminal del debug-server
echo    2. Ejecuta: node debug-server.js
echo    3. Envía un mensaje a tu WhatsApp
echo    4. Revisa webhook.site para ver si llegan los datos
echo.
pause
