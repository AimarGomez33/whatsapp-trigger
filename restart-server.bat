@echo off
echo.
echo ======================================================
echo 🔄 REINICIO COMPLETO DEL SISTEMA DE WEBHOOK
echo ======================================================
echo.

echo 📋 Paso 1: Cerrando todos los procesos de Node.js...
taskkill /F /IM node.exe 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ Procesos de Node.js cerrados
) else (
    echo ℹ️  No se encontraron procesos de Node.js corriendo
)

echo.
echo 📋 Paso 2: Esperando 3 segundos para que se liberen los puertos...
timeout /t 3 >nul

echo.
echo 📋 Paso 3: Verificando que el puerto 3000 esté libre...
netstat -ano | findstr :3000
if %ERRORLEVEL% EQU 0 (
    echo ❌ El puerto 3000 aún está ocupado, esperando más...
    timeout /t 5 >nul
) else (
    echo ✅ Puerto 3000 libre
)

echo.
echo 📋 Paso 4: Iniciando el servidor con logs detallados...
echo ℹ️  Deberías ver los logs del servidor aquí
echo ℹ️  Después de ver "WhatsApp Web is ready!", envía un mensaje a tu WhatsApp
echo ℹ️  Presiona Ctrl+C cuando termines de probar
echo.

node src/index.js

echo.
echo 🏁 Servidor detenido
pause
