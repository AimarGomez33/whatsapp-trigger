@echo off
echo 🔍 DIAGNOSTICO: WhatsApp Webhook no detecta mensajes
echo.
echo ================================================
echo 1. VERIFICANDO CONFIGURACION
echo ================================================

if not exist ".env" (
    echo ❌ Archivo .env no encontrado
    pause
    exit /b 1
)

echo ✅ Archivo .env encontrado

findstr "WEBHOOK_URL" .env
echo.

echo ================================================
echo 2. VERIFICANDO SERVIDOR PRINCIPAL (puerto 3000)
echo ================================================

echo Probando conexion al servidor principal...
curl -s -o nul -w "%%{http_code}" http://localhost:3000/status 2>nul
if %errorlevel%==0 (
    echo ✅ Servidor principal respondiendo en puerto 3000
) else (
    echo ❌ Servidor principal NO responde en puerto 3000
    echo.
    echo 🔧 SOLUCION: Ejecuta "npm start" o "start.bat"
    echo.
)

echo.
echo ================================================
echo 3. VERIFICANDO SERVIDOR DE PRUEBAS (puerto 3001)
echo ================================================

curl -s -o nul -w "%%{http_code}" http://localhost:3001/status 2>nul
if %errorlevel%==0 (
    echo ✅ Servidor de pruebas respondiendo en puerto 3001
) else (
    echo ❌ Servidor de pruebas NO responde en puerto 3001
    echo.
    echo 🔧 SOLUCION: Ejecuta "start-webhook-server.bat"
    echo.
)

echo.
echo ================================================
echo 4. PROBANDO WEBHOOK DE N8N
echo ================================================

echo Probando conexion a n8n webhook...
curl -s -X POST -H "Content-Type: application/json" -d "{\"test\":\"conexion\"}" "https://jairgomez44.app.n8n.cloud/webhook-test/a32dc71c-6d7a-4e45-b34c-0ddb30be916e" 2>nul
if %errorlevel%==0 (
    echo ✅ Webhook de n8n accesible
) else (
    echo ❌ Webhook de n8n NO accesible
    echo.
    echo 🔧 SOLUCION: Verifica que el workflow este ACTIVO en n8n
    echo.
)

echo.
echo ================================================
echo 5. PASOS PARA SOLUCIONAR
echo ================================================

echo 📋 Lista de verificacion:
echo.
echo 1. ¿Esta corriendo el servidor principal?
echo    Comando: npm start
echo    URL: http://localhost:3000
echo.
echo 2. ¿Esta WhatsApp conectado?
echo    Ve a: http://localhost:3000
echo    Debe mostrar "WhatsApp Conectado"
echo.
echo 3. ¿Esta activo el workflow en n8n?
echo    Ve a: https://jairgomez44.app.n8n.cloud
echo    El workflow debe estar en estado "Active"
echo.
echo 4. ¿Esta configurado correctamente el webhook?
echo    Path en n8n: webhook-test/a32dc71c-6d7a-4e45-b34c-0ddb30be916e
echo    Method: POST
echo.
echo 5. ¿Estas enviando mensajes correctamente?
echo    - Envia un WhatsApp a tu numero desde OTRO telefono
echo    - NO desde el mismo telefono que tiene WhatsApp Web
echo.

pause
