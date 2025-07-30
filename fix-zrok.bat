@echo off
echo.
echo 🔧 SOLUCIONADOR DE PROBLEMAS ZROK
echo ================================
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 Problema identificado: Error 502 en zrok
echo URL problemática: https://bg3cxugb4h3g.share.zrok.io
echo.

echo 🎯 DIAGNÓSTICO:
echo ✅ Servidor local funciona (puerto 3000)
echo ✅ WhatsApp conectado
echo ❌ zrok no puede conectar con localhost:3000
echo.

echo 🔧 SOLUCIONES A PROBAR:
echo.

echo ----------------------------------------
echo 🚀 SOLUCIÓN 1: Reiniciar zrok completamente
echo ----------------------------------------
echo.
echo 1. Cierra la terminal donde corre zrok (Ctrl+C)
echo 2. Ejecuta estos comandos:
echo.
echo    zrok disable
echo    zrok enable
echo    zrok share public localhost:3000
echo.
echo 3. Usa la NUEVA URL que te dé
echo.

echo ----------------------------------------
echo 🚀 SOLUCIÓN 2: Usar IP específica
echo ----------------------------------------
echo.
echo Si la Solución 1 no funciona, prueba:
echo.
echo    zrok share public 127.0.0.1:3000
echo.

echo ----------------------------------------
echo 🚀 SOLUCIÓN 3: Verificar firewall
echo ----------------------------------------
echo.
echo 1. Verifica que Windows Firewall no bloquee el puerto 3000
echo 2. O prueba con:
echo    zrok share public --insecure localhost:3000
echo.

echo ----------------------------------------
echo 🚀 SOLUCIÓN 4: Usar ngrok (alternativa)
echo ----------------------------------------
echo.
echo Si zrok sigue fallando, puedes usar ngrok:
echo.
echo 1. Descarga ngrok: https://ngrok.com/
echo 2. Ejecuta: ngrok http 3000
echo 3. Usa la URL https que te dé
echo.

echo ========================================
echo 🧪 PROCESO DE PRUEBA RECOMENDADO:
echo ========================================
echo.
echo 1. Terminal 1: npm start (mantener corriendo)
echo 2. Terminal 2: zrok disable ^&^& zrok enable ^&^& zrok share public localhost:3000
echo 3. Copiar la NUEVA URL
echo 4. Probar: curl -X POST https://NUEVA-URL/send-message \
echo           -H "Content-Type: application/json" \
echo           -d "{\"number\":\"5217711270119\",\"message\":\"Prueba\"}"
echo.

echo ⚠️  IMPORTANTE: 
echo - NO reutilices la URL anterior (bg3cxugb4h3g.share.zrok.io)
echo - Genera una NUEVA URL con zrok
echo - El número debe ser SIN @c.us
echo.

echo ========================================
echo 💡 FORMATO CORRECTO PARA ENVIAR MENSAJE:
echo ========================================
echo.
echo curl -X POST https://TU-NUEVA-URL.share.zrok.io/send-message \
echo   -H "Content-Type: application/json" \
echo   -d '{
echo     "number": "5217711270119",
echo     "message": "¡Hola desde zrok reparado!"
echo   }'
echo.

pause

echo.
echo ¿Quieres que ejecute automáticamente las verificaciones? (S/N)
set /p respuesta=

if /i "%respuesta%"=="S" (
    echo.
    echo 🔍 Ejecutando verificaciones automáticas...
    echo.
    
    echo Verificando servidor local...
    curl -s http://localhost:3000/status
    if errorlevel 1 (
        echo ❌ Servidor local no responde
        echo 🔧 Ejecuta: npm start
    ) else (
        echo ✅ Servidor local OK
    )
    
    echo.
    echo Verificando zrok...
    zrok version >nul 2>&1
    if errorlevel 1 (
        echo ❌ zrok no encontrado
        echo 🔧 Instala desde: https://zrok.io/
    ) else (
        echo ✅ zrok instalado
        zrok version
    )
)

echo.
echo ========================================
echo 🎯 SIGUIENTE PASO: 
echo Genera una NUEVA URL con zrok y prueba
echo ========================================
