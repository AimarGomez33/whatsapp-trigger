@echo off
echo.
echo 🔧 DIAGNÓSTICO Y SOLUCIÓN PARA NGROK
echo ===================================
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 Tu configuración actual:
echo ngrok URL: https://eb67ad8ff18f.ngrok-free.app
echo Error: 502 Bad Gateway
echo.

echo 🔍 DIAGNÓSTICO PASO A PASO:
echo.

echo 1. Verificando servidor local...
curl -s http://localhost:3000/status
if errorlevel 1 (
    echo ❌ PROBLEMA ENCONTRADO: Servidor local no responde
    echo.
    echo 🔧 SOLUCIÓN:
    echo 1. Abre una nueva terminal
    echo 2. Ejecuta: cd "c:\Users\jair_\Desktop\trigger"
    echo 3. Ejecuta: npm start
    echo 4. Verifica que diga "Server running on port 3000"
    echo 5. Luego reinicia ngrok
    echo.
    goto :test_ngrok
) else (
    echo ✅ Servidor local funcionando
)

echo.
echo 2. Probando endpoint send-message localmente...
echo {"number":"5217711270119","message":"Prueba local"} > temp_test.json
curl -X POST http://localhost:3000/send-message -H "Content-Type: application/json" -d @temp_test.json
del temp_test.json >nul 2>&1

echo.
echo.

:test_ngrok
echo 3. Probando conectividad de ngrok...
curl -s https://eb67ad8ff18f.ngrok-free.app/status
if errorlevel 1 (
    echo ❌ ngrok no puede conectar con localhost:3000
    echo.
    echo 🔧 SOLUCIONES A PROBAR:
    echo.
    echo SOLUCIÓN 1 - Reiniciar todo:
    echo 1. Detén ngrok (Ctrl+C)
    echo 2. Detén el servidor Node.js (Ctrl+C)
    echo 3. Inicia el servidor: npm start
    echo 4. Espera a ver "Server running on port 3000"
    echo 5. Inicia ngrok: ngrok http 3000
    echo.
    echo SOLUCIÓN 2 - Verificar puerto:
    echo 1. Verifica que el servidor use puerto 3000
    echo 2. Ejecuta: netstat -an | findstr :3000
    echo.
    echo SOLUCIÓN 3 - Usar IP específica:
    echo 1. ngrok http 127.0.0.1:3000
    echo.
    echo SOLUCIÓN 4 - Verificar firewall:
    echo 1. Deshabilita temporalmente Windows Firewall
    echo 2. Prueba de nuevo
    echo.
) else (
    echo ✅ ngrok conecta correctamente
)

echo.
echo ========================================
echo 🧪 PRUEBA CON NGROK:
echo ========================================
echo.
echo Una vez que soluciones el problema, prueba:
echo.
echo curl -X POST https://eb67ad8ff18f.ngrok-free.app/send-message \
echo   -H "Content-Type: application/json" \
echo   -d '{
echo     "number": "5217711270119",
echo     "message": "¡Hola desde ngrok!"
echo   }'
echo.

echo ========================================
echo 💡 ORDEN CORRECTO DE INICIO:
echo ========================================
echo.
echo Terminal 1:
echo   cd "c:\Users\jair_\Desktop\trigger"
echo   npm start
echo   [Esperar a ver: Server running on port 3000]
echo.
echo Terminal 2:
echo   ngrok http 3000
echo   [Copiar la URL HTTPS que aparezca]
echo.

echo ========================================
echo 🚨 VERIFICACIONES IMPORTANTES:
echo ========================================
echo.
echo ✅ ¿El servidor muestra "Server running on port 3000"?
echo ✅ ¿WhatsApp está conectado?
echo ✅ ¿curl http://localhost:3000/status funciona?
echo ✅ ¿ngrok muestra "Forwarding" en la consola?
echo ✅ ¿El número NO tiene @c.us?
echo.

echo ¿Quieres ejecutar las verificaciones ahora? (S/N)
set /p ejecutar=

if /i "%ejecutar%"=="S" (
    echo.
    echo 🔍 Ejecutando verificaciones...
    
    echo Verificando proceso en puerto 3000...
    netstat -an | findstr :3000
    
    echo.
    echo Verificando variables de entorno...
    if exist ".env" (
        echo ✅ Archivo .env existe
        findstr "PORT" .env
    ) else (
        echo ❌ Archivo .env no existe
    )
)

pause
