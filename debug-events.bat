@echo off
echo.
echo ==================================================
echo 🔍 DIAGNOSTICO COMPLETO DE DETECCION DE MENSAJES
echo ==================================================
echo.

echo ⚠️  IMPORTANTE: Antes de continuar, asegurate de cerrar el servidor actual
echo.
pause

echo.
echo 📋 Paso 1: Verificando que el puerto 3000 este libre...
netstat -ano | findstr :3000
if %ERRORLEVEL% EQU 0 (
    echo ❌ El puerto 3000 aun esta en uso
    echo ℹ️  Presiona Ctrl+C en la terminal del servidor para cerrarlo
    pause
) else (
    echo ✅ Puerto 3000 libre
)

echo.
echo 📋 Paso 2: Ejecutando script de diagnóstico de eventos...
echo ℹ️  Este script mostrara TODOS los eventos de mensajes
echo ℹ️  Envia un mensaje a tu WhatsApp cuando veas "Cliente conectado"
echo.
node debug-message-events.js

pause
