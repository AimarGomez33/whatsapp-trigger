. @echo off
echo.
echo 🧪 PRUEBA DE ENVÍO DE MENSAJES DESDE N8N
echo =======================================
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 Esta prueba simula cómo n8n envía mensajes de vuelta por WhatsApp
echo.

:: Verificar que el servidor esté corriendo
echo 🔍 Verificando servidor...
curl -s http://localhost:3000/status >nul 2>&1
if errorlevel 1 (
    echo ❌ El servidor no está corriendo
    echo 🔧 Ejecuta: npm start
    pause
    exit /b 1
)

echo ✅ Servidor corriendo
echo.

:: Pedir datos del usuario
set /p number="📱 Número de WhatsApp (ej: 5215551234567): "
set /p message="💬 Mensaje a enviar: "

if "%number%"=="" (
    echo ❌ Número requerido
    pause
    exit /b 1
)

if "%message%"=="" (
    set message=¡Hola! Este es un mensaje de prueba desde n8n
)

echo.
echo 📋 Enviando mensaje...
echo 👤 Para: +%number%
echo 💬 Mensaje: "%message%"
echo.

:: Crear archivo JSON temporal
echo { > temp_message.json
echo   "number": "%number%", >> temp_message.json
echo   "message": "%message%" >> temp_message.json
echo } >> temp_message.json

:: Enviar mensaje
curl -X POST http://localhost:3000/send-message ^
  -H "Content-Type: application/json" ^
  -d @temp_message.json

:: Limpiar archivo temporal
del temp_message.json >nul 2>&1

echo.
echo.
echo =======================================
echo  CÓMO USAR EN N8N:
echo =======================================
echo.
echo 1. Agrega un nodo HTTP Request
echo 2. Configura:
echo    - URL: http://localhost:3000/send-message
echo    - Method: POST
echo    - Headers: Content-Type: application/json
echo    - Body: {"number": "5215551234567", "message": "Tu mensaje"}
echo.
echo 3. Usa datos del webhook:
echo    - Número: {{$json.data.message.from.split('@')[0]}}
echo    - Respuesta: Tu mensaje personalizado
echo.
echo  Ejemplo de respuesta automática:
echo    {"number": "{{$json.data.message.from.split('@')[0]}}", "message": "¡Gracias por tu mensaje!"}
echo.
pause
