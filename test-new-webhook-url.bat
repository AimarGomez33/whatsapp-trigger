@echo off
echo.
echo 🎯 PRUEBA DE NUEVA URL DE WEBHOOK
echo =================================
echo.
echo Nueva URL: https://n8n-kubectl.42web.io/webhook/whatsapp-bot
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 Verificando configuración actualizada...
echo.

:: Verificar archivo .env
if exist ".env" (
    echo ✅ Archivo .env encontrado
    findstr "WEBHOOK_URL" .env
) else (
    echo ❌ Archivo .env no encontrado
)

echo.
echo 🧪 Probando nueva URL de webhook...
echo.

:: Crear mensaje de prueba
set mensaje_prueba={"event":"test","timestamp":"%date% %time%","data":{"message":{"body":"Prueba de nueva URL webhook","from":"5217711270119@c.us"},"contact":{"name":"Test User"}}}

echo Enviando mensaje de prueba...
curl -X POST https://n8n-kubectl.42web.io/webhook/whatsapp-bot ^
  -H "Content-Type: application/json" ^
  -d "%mensaje_prueba%"

echo.
echo.
echo ========================================
echo 📋 ARCHIVOS ACTUALIZADOS:
echo ========================================
echo.
echo ✅ .env - URL principal actualizada
echo ✅ start.bat - Configuración por defecto
echo ✅ simulate-message.js - Simulador actualizado  
echo ✅ test-new-webhook.js - Pruebas actualizadas
echo ✅ TESTING-GUIDE.md - Documentación actualizada
echo ✅ start-all-services.bat - Script de servicios
echo.

echo ========================================
echo 🎯 TU NUEVA CONFIGURACIÓN:
echo ========================================
echo.
echo Webhook URL: https://n8n-kubectl.42web.io/webhook/whatsapp-bot
echo n8n Instance: https://n8n-kubectl.42web.io
echo.

echo ========================================
echo 🚀 PRÓXIMOS PASOS:
echo ========================================
echo.
echo 1. Reinicia tu servidor WhatsApp:
echo    npm start
echo.
echo 2. Configura tu workflow en n8n:
echo    https://n8n-kubectl.42web.io
echo.
echo 3. Asegúrate de que el webhook esté ACTIVO
echo.
echo 4. Prueba enviando mensaje personalizado:
echo    test-send-message.bat
echo.
echo 5. O simula mensaje para probar n8n:
echo    node simulate-message.js custom "Prueba nueva URL" "Sistema Test"
echo.

pause

echo.
echo 🧪 ¿Quieres ejecutar una prueba completa ahora? (S/N)
set /p ejecutar_prueba=

if /i "%ejecutar_prueba%"=="S" (
    echo.
    echo 🔍 Ejecutando prueba completa...
    
    echo 1. Verificando servidor local...
    curl -s http://localhost:3000/status
    if errorlevel 1 (
        echo ❌ Servidor local no responde
        echo 🔧 Ejecuta: npm start
    ) else (
        echo ✅ Servidor local funcionando
    )
    
    echo.
    echo 2. Probando simulador con nueva URL...
    node simulate-message.js custom "¡Nueva URL funcionando!" "Test System" "5217711270119"
    
    echo.
    echo 3. Verificando configuración...
    node test-new-webhook.js
)

echo.
echo ========================================
echo ✅ CONFIGURACIÓN ACTUALIZADA EXITOSAMENTE
echo ========================================
