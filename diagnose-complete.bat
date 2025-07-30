@echo off
echo.
echo ========================================================
echo 🔍 DIAGNOSTICO COMPLETO - DETECCION DE MENSAJES
echo ========================================================
echo.

echo 🔧 PROBLEMA IDENTIFICADO:
echo =====================================
echo.
echo ❌ El webhook de n8n no está funcionando correctamente
echo    URL: https://n8n-kubectl.42web.io/webhook/whatsapp-bot
echo    Respuesta: Página HTML con JavaScript (no un webhook válido)
echo.
echo 💡 POSIBLES CAUSAS:
echo =====================================
echo 1. El workflow de n8n no está activo
echo 2. La URL del webhook es incorrecta  
echo 3. El servicio n8n tiene problemas
echo 4. Hay un proxy bloqueando las requests POST
echo.
echo 🛠️  SOLUCIONES RECOMENDADAS:
echo =====================================
echo.
echo A) VERIFICAR N8N:
echo    1. Accede a https://n8n-kubectl.42web.io
echo    2. Verifica que el workflow este ACTIVO
echo    3. Comprueba la URL exacta del webhook
echo    4. Asegurate de que el webhook acepta POST requests
echo.
echo B) PROBAR CON WEBHOOK LOCAL:
echo    1. Instalar ngrok: https://ngrok.com/
echo    2. Ejecutar: ngrok http 3000
echo    3. Usar la URL de ngrok como webhook
echo.
echo C) USAR WEBHOOK DE PRUEBA:
echo    1. Ir a https://webhook.site/
echo    2. Copiar la URL única generada
echo    3. Actualizar .env con esa URL
echo    4. Probar el sistema
echo.
echo ⚙️  ¿QUE QUIERES HACER?
echo =====================================
echo [1] Actualizar URL del webhook en .env
echo [2] Probar con webhook.site 
echo [3] Reiniciar servidor y probar
echo [4] Ver logs detallados del servidor
echo.
set /p choice="Elige una opcion (1-4): "

if "%choice%"=="1" goto update_webhook
if "%choice%"=="2" goto webhook_site
if "%choice%"=="3" goto restart_server  
if "%choice%"=="4" goto detailed_logs
goto end

:update_webhook
echo.
echo 📝 Para actualizar el webhook:
echo 1. Edita el archivo .env
echo 2. Cambia la línea: WEBHOOK_URL=https://n8n-kubectl.42web.io/webhook/whatsapp-bot
echo 3. Por la URL correcta de tu n8n o webhook.site
echo.
pause
goto end

:webhook_site
echo.
echo 🌐 Abriendo webhook.site...
start https://webhook.site/
echo.
echo 📋 PASOS:
echo 1. Copia la URL única que aparece
echo 2. Actualiza .env con: WEBHOOK_URL=https://webhook.site/#!/tu-id-unico
echo 3. Ejecuta restart-server.bat
echo.
pause
goto end

:restart_server
echo.
echo 🔄 Reiniciando servidor...
call restart-server.bat
goto end

:detailed_logs
echo.
echo 📊 Iniciando servidor con logs detallados...
echo =====================================
echo ℹ️  Envía un mensaje a tu WhatsApp cuando veas "WhatsApp Web is ready!"
echo ℹ️  Observa si aparecen logs de "NUEVO MENSAJE RECIBIDO"
echo ℹ️  Presiona Ctrl+C para detener
echo.
node src/index.js
goto end

:end
echo.
echo 🏁 Diagnóstico completado
pause
