@echo off
echo.
echo 🚀 CONFIGURACIÓN DE NGROK PARA WHATSAPP
echo ======================================
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 Puerto correcto: 3000
echo Tu servidor WhatsApp ya está en puerto 3000
echo.

echo 🔧 COMANDO PARA NGROK:
echo.
echo ngrok http 3000
echo.

echo ========================================
echo 📱 PROCESO COMPLETO:
echo ========================================
echo.
echo Terminal 1: npm start
echo Terminal 2: ngrok http 3000
echo.

echo ⏳ Verificando que tu servidor esté corriendo...
curl -s http://localhost:3000/status >nul 2>&1
if errorlevel 1 (
    echo ❌ Servidor no está corriendo
    echo 🔧 Ejecuta primero: npm start
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Servidor corriendo en puerto 3000
)

echo.
echo 🎯 PASOS A SEGUIR:
echo.
echo 1. Abre una nueva terminal
echo 2. Ejecuta: ngrok http 3000
echo 3. Copia la URL HTTPS que te dé (ejemplo: https://abc123.ngrok.io)
echo 4. Usa esa URL para enviar mensajes
echo.

echo 💡 FORMATO PARA ENVIAR MENSAJE:
echo.
echo curl -X POST https://TU-URL-NGROK.ngrok.io/send-message \
echo   -H "Content-Type: application/json" \
echo   -d '{
echo     "number": "5217711270119",
echo     "message": "¡Hola desde ngrok!"
echo   }'
echo.

echo ⚠️  RECUERDA:
echo - Usar puerto 3000 (donde corre tu servidor)
echo - Número SIN @c.us
echo - Copiar la URL HTTPS de ngrok
echo.

echo ========================================
echo 🧪 PRUEBA AUTOMÁTICA:
echo ========================================

set /p ejecutar="¿Quieres que verifique ngrok? (S/N): "

if /i "%ejecutar%"=="S" (
    echo.
    echo 🔍 Verificando ngrok...
    ngrok version >nul 2>&1
    if errorlevel 1 (
        echo ❌ ngrok no encontrado
        echo 🔧 Descarga desde: https://ngrok.com/download
        echo 📱 O instala con: winget install ngrok
    ) else (
        echo ✅ ngrok instalado
        ngrok version
        echo.
        echo 🚀 Listo para ejecutar: ngrok http 3000
    )
)

echo.
echo ========================================
echo 💡 VENTAJAS DE NGROK vs ZROK:
echo ========================================
echo ✅ Más estable y confiable
echo ✅ Mejor documentación
echo ✅ Menos errores 502
echo ✅ URLs más legibles
echo ✅ Mejor soporte HTTPS
echo.

pause
