@echo off
echo.
echo 🧪 SIMULADOR DE MENSAJE ENTRANTE
echo ==============================
echo.
echo ℹ️  Este script simula un mensaje que llega del webhook de n8n
echo    hacia el endpoint /send-message de nuestro servidor
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

:: Verificar que el servidor esté corriendo
echo 🔍 Verificando servidor...
curl -s http://localhost:3000/status >nul 2>&1
if errorlevel 1 (
    echo ❌ El servidor no está corriendo
    echo 🔧 Asegurate de que debug-server.js esté ejecutándose
    pause
    exit /b 1
)

echo ✅ Servidor corriendo
echo.

:: Mostrar configuración actual
echo 📋 Configuración actual:
curl -s http://localhost:3000/status | find "whatsapp_connected"
echo.

:: Pedir datos para la simulación
set /p number="📱 Número de destino (ej: 5215551234567): "
set /p message="💬 Mensaje a enviar: "

if "%number%"=="" (
    set number=5215551234567
    echo ℹ️  Usando número por defecto: %number%
)

if "%message%"=="" (
    set message=🧪 Mensaje de prueba desde el simulador
    echo ℹ️  Usando mensaje por defecto: %message%
)

echo.
echo 🚀 Enviando mensaje de prueba...
echo 👤 Para: +%number%
echo 💬 Mensaje: "%message%"
echo.

:: Crear JSON y enviar
echo { > temp_test.json
echo   "number": "%number%", >> temp_test.json
echo   "message": "%message%" >> temp_test.json
echo } >> temp_test.json

curl -X POST http://localhost:3000/send-message ^
  -H "Content-Type: application/json" ^
  -d @temp_test.json ^
  -w "\n📊 HTTP Status: %%{http_code}\n"

del temp_test.json >nul 2>&1

echo.
echo ✅ Prueba completada
echo.
echo 💡 NOTA: Esta prueba envía un mensaje DESDE el bot
echo    Para probar recepción, envía un mensaje AL número del bot
echo.
pause
