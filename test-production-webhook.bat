@echo off
echo.
echo 🚀 PRUEBA DEL WEBHOOK DE PRODUCCIÓN
echo ====================================
echo.
echo 🎯 Webhook: https://jairgomez44.app.n8n.cloud/webhook/whatsapp-bot
echo 💡 Este webhook está SIEMPRE ACTIVO (no necesita activación manual)
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 Verificando configuración...
echo.

:: Verificar archivo .env
if exist ".env" (
    echo ✅ Archivo .env encontrado
    findstr "WEBHOOK_URL" .env
) else (
    echo ❌ Archivo .env no encontrado
    goto :end
)

echo.
echo 🧪 Ejecutando prueba del webhook de producción...
echo.

node test-new-webhook.js

echo.
echo ============================================
echo 🎯 WEBHOOK DE PRODUCCIÓN - CARACTERÍSTICAS:
echo ============================================
echo ✅ Siempre activo (24/7)
echo ✅ No necesita activación manual
echo ✅ Respuesta inmediata a mensajes
echo ✅ Más confiable para uso real
echo ✅ No se desactiva por inactividad
echo.
echo 💡 Para probar con mensaje personalizado:
echo    node simulate-message.js custom
echo.
echo 📱 Para prueba real:
echo    Pide a alguien que te envíe un WhatsApp
echo    (NO te envíes mensajes a ti mismo)
echo.

:end
pause
