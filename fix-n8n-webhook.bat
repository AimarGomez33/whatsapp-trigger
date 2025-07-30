@echo off
echo.
echo 🔧 SOLUCION PARA WEBHOOK DE N8N
echo ==============================
echo.

echo ❌ PROBLEMA IDENTIFICADO:
echo    El webhook de n8n está devolviendo HTML con JavaScript
echo    en lugar de procesar el POST request correctamente.
echo.
echo 💡 POSIBLES CAUSAS Y SOLUCIONES:
echo ================================
echo.
echo 1️⃣  WORKFLOW NO ACTIVO:
echo    - Ve a https://n8n-kubectl.42web.io
echo    - Asegurate de que el workflow esté ACTIVO (toggle en ON)
echo    - El nodo webhook debe mostrar "Waiting for webhook call"
echo.
echo 2️⃣  URL INCORRECTA:
echo    - En n8n, ve al nodo webhook
echo    - Copia la URL exacta que aparece
echo    - Debe ser algo como: /webhook/whatsapp-bot o /webhook/[ID-UNICO]
echo.
echo 3️⃣  CONFIGURACION DEL WEBHOOK:
echo    - El nodo webhook debe aceptar: POST requests
echo    - Content-Type: application/json
echo    - No debe tener autenticación especial
echo.
echo 4️⃣  PROBLEMA DE HOSTING:
echo    - El servicio 42web.io podría tener limitaciones
echo    - Prueba con webhook.site primero para confirmar que funciona
echo.
echo ⚙️  PASOS RECOMENDADOS:
echo =====================
echo 1. Ejecuta: setup-test-webhook.bat (para probar con webhook.site)
echo 2. Si funciona con webhook.site, el problema es n8n
echo 3. Revisa la configuración de n8n paso a paso
echo 4. Considera usar otro hosting para n8n si el problema persiste
echo.
echo 🔗 PARA VOLVER A N8N:
echo    Cuando arregles n8n, ejecuta este script y pon la URL correcta
echo.
set /p n8n_url="🔗 Nueva URL de n8n (o Enter para cancelar): "

if "%n8n_url%"=="" (
    echo ℹ️  Operación cancelada
    pause
    exit /b 0
)

echo.
echo 📝 Actualizando .env con URL de n8n...

:: Crear nuevo .env
echo # Variables del servidor > .env.new
echo PORT=3000 >> .env.new
echo HOST=localhost >> .env.new
echo. >> .env.new
echo # URL del webhook donde enviar los mensajes recibidos >> .env.new
echo WEBHOOK_URL=%n8n_url% >> .env.new
echo # Configuracion de la API REST (opcional) >> .env.new
echo API_KEY=tu_api_key_aqui >> .env.new
echo. >> .env.new
echo # Configuracion adicional >> .env.new
echo DEBUG=true >> .env.new

:: Reemplazar archivo
move .env .env.backup >nul 2>&1
move .env.new .env >nul 2>&1

echo ✅ Configuración actualizada
echo ⚠️  Reinicia el servidor para aplicar los cambios
echo.
pause
