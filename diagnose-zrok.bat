@echo off
echo.
echo 🔧 DIAGNÓSTICO COMPLETO DEL SISTEMA
echo ==================================
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 1. VERIFICANDO SERVIDOR LOCAL...
echo.

:: Verificar estado del servidor
curl -s http://localhost:3000/status
if errorlevel 1 (
    echo ❌ Servidor local NO responde
    echo 🔧 Ejecuta: npm start
    goto :zrok_check
) else (
    echo ✅ Servidor local funcionando correctamente
)

echo.
echo 📋 2. PROBANDO ENDPOINT SEND-MESSAGE...
echo.

:: Probar endpoint local
echo {"number":"5217711270119","message":"Prueba local"} > temp_test.json
curl -X POST http://localhost:3000/send-message -H "Content-Type: application/json" -d @temp_test.json
del temp_test.json >nul 2>&1

echo.
echo.

:zrok_check
echo 📋 3. VERIFICANDO ZROK...
echo.

:: Verificar si zrok está instalado
zrok version >nul 2>&1
if errorlevel 1 (
    echo ❌ zrok no está instalado o no está en PATH
    echo 🔧 Descarga desde: https://zrok.io/
    goto :recommendations
) else (
    echo ✅ zrok está instalado
    zrok version
)

echo.
echo 📋 4. CONFIGURACIÓN RECOMENDADA PARA ZROK:
echo.

:recommendations
echo ============================================
echo 🎯 SOLUCIÓN PARA ERROR 502:
echo ============================================
echo.
echo El error 502 indica que zrok no puede conectar con tu servidor local.
echo.
echo 🔧 PASOS PARA SOLUCIONARLO:
echo.
echo 1. Asegúrate de que tu servidor esté corriendo:
echo    npm start
echo.
echo 2. Inicia zrok correctamente:
echo    zrok share public localhost:3000
echo.
echo 3. O usa este comando específico:
echo    zrok share public --headless localhost:3000
echo.
echo 4. La URL debe ser algo como:
echo    https://xxxxxx.share.zrok.io
echo.
echo 5. Para enviar mensajes usa:
echo    POST https://tu-url-zrok.share.zrok.io/send-message
echo.
echo ⚠️  IMPORTANTE: El número debe ser SIN @c.us:
echo    "number": "5217711270119"  ✅ Correcto
echo    "number": "5217711270119@c.us"  ❌ Incorrecto
echo.
echo 💡 FORMATO CORRECTO DEL JSON:
echo {
echo   "number": "5217711270119",
echo   "message": "¡Gracias por tu mensaje!"
echo }
echo.
echo ============================================
echo 🧪 PRUEBAS RECOMENDADAS:
echo ============================================
echo.
echo 1. Prueba local primero:
echo    curl -X POST http://localhost:3000/send-message \
echo      -H "Content-Type: application/json" \
echo      -d '{"number":"5217711270119","message":"Prueba local"}'
echo.
echo 2. Luego prueba con zrok:
echo    curl -X POST https://tu-url.share.zrok.io/send-message \
echo      -H "Content-Type: application/json" \
echo      -d '{"number":"5217711270119","message":"Prueba zrok"}'
echo.
pause
