@echo off
echo.
echo 🔍 DIAGNÓSTICO: WEBHOOK NO DETECTA MENSAJES
echo ==========================================
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo 📋 Problema: Los mensajes entrantes no llegan al webhook
echo Nueva URL: https://n8n-kubectl.42web.io/webhook/whatsapp-bot
echo.

echo ========================================
echo 🔍 PASO 1: VERIFICAR SERVIDOR LOCAL
echo ========================================
echo.

echo Verificando servidor WhatsApp...
curl -s http://localhost:3000/status
if errorlevel 1 (
    echo ❌ PROBLEMA: Servidor local no está corriendo
    echo.
    echo 🔧 SOLUCIÓN:
    echo 1. Abre una terminal
    echo 2. cd "c:\Users\jair_\Desktop\trigger"
    echo 3. npm start
    echo.
    goto :check_whatsapp
) else (
    echo ✅ Servidor local corriendo en puerto 3000
)

:check_whatsapp
echo.
echo ========================================
echo 📱 PASO 2: VERIFICAR CONEXIÓN WHATSAPP
echo ========================================
echo.

echo Verificando estado de WhatsApp...
curl -s http://localhost:3000/status | findstr "whatsapp_connected.*true" >nul
if errorlevel 1 (
    echo ❌ PROBLEMA: WhatsApp no está conectado
    echo.
    echo 🔧 SOLUCIÓN:
    echo 1. Ve a http://localhost:3000
    echo 2. Escanea el código QR con tu WhatsApp
    echo 3. Espera a ver "✅ WhatsApp conectado"
    echo.
    echo 💡 Si no aparece QR:
    echo - Borra la carpeta .wwebjs_auth
    echo - Reinicia el servidor
    echo.
    start http://localhost:3000
    goto :check_webhook
) else (
    echo ✅ WhatsApp está conectado
)

:check_webhook
echo.
echo ========================================
echo 🌐 PASO 3: VERIFICAR WEBHOOK DE N8N
echo ========================================
echo.

echo Probando webhook de n8n...
curl -X POST https://n8n-kubectl.42web.io/webhook/whatsapp-bot ^
  -H "Content-Type: application/json" ^
  -d "{\"test\":\"mensaje de prueba\",\"timestamp\":\"%date% %time%\"}"

echo.
if errorlevel 1 (
    echo ❌ PROBLEMA: Webhook de n8n no responde
    echo.
    echo 🔧 VERIFICAR EN N8N:
    echo 1. Ve a https://n8n-kubectl.42web.io
    echo 2. Verifica que el workflow esté ACTIVO
    echo 3. El webhook debe estar en: /webhook/whatsapp-bot
    echo 4. Método debe ser POST
    echo.
) else (
    echo ✅ Webhook de n8n responde
)

echo.
echo ========================================
echo 🧪 PASO 4: PROBAR FLUJO COMPLETO
echo ========================================
echo.

echo Simulando mensaje entrante...
node simulate-message.js custom "Prueba de mensaje entrante" "Test User" "5217711270119"

echo.
echo ========================================
echo ❌ CAUSAS COMUNES DEL PROBLEMA:
echo ========================================
echo.
echo 1. 📱 WhatsApp no conectado:
echo    - QR no escaneado
echo    - Sesión expirada
echo    - WhatsApp desconectado
echo.
echo 2. 🌐 Webhook de n8n inactivo:
echo    - Workflow no activado
echo    - URL incorrecta
echo    - n8n no disponible
echo.
echo 3. 🔧 Servidor local:
echo    - npm start no ejecutado
echo    - Puerto 3000 ocupado
echo    - Error en código
echo.
echo 4. ⚠️  Tipo de mensaje:
echo    - Mensajes propios NO se detectan
echo    - Solo mensajes de OTROS números
echo    - No desde WhatsApp Web
echo.

echo ========================================
echo 🎯 PRUEBA PASO A PASO:
echo ========================================
echo.

set /p ejecutar_prueba="¿Ejecutar diagnóstico completo? (S/N): "

if /i "%ejecutar_prueba%"=="S" (
    echo.
    echo 🔍 Ejecutando diagnóstico completo...
    echo.
    
    echo 1. Verificando configuración...
    if exist ".env" (
        echo ✅ Archivo .env existe
        findstr "WEBHOOK_URL" .env
    ) else (
        echo ❌ Archivo .env no existe
    )
    
    echo.
    echo 2. Verificando logs del servidor...
    echo ⚠️  Revisa la consola donde corre "npm start"
    echo Deberías ver algo como:
    echo   "📨 Nuevo mensaje recibido"
    echo   "🎯 Enviando a webhook..."
    echo.
    
    echo 3. Probando con curl directo...
    curl -v http://localhost:3000/webhook/test -X POST -H "Content-Type: application/json" -d "{\"test\":true}"
    
    echo.
    echo 4. Estado final del sistema...
    curl -s http://localhost:3000/status
)

echo.
echo ========================================
echo 🚀 SOLUCIONES RECOMENDADAS:
echo ========================================
echo.
echo SOLUCIÓN 1 - Reiniciar todo:
echo 1. Detener servidor (Ctrl+C)
echo 2. npm start
echo 3. Conectar WhatsApp
echo 4. Activar workflow en n8n
echo.
echo SOLUCIÓN 2 - Verificar mensaje real:
echo 1. Pide a ALGUIEN MÁS que te envíe un WhatsApp
echo 2. NO te envíes mensajes a ti mismo
echo 3. Observa los logs del servidor
echo.
echo SOLUCIÓN 3 - Probar webhook manualmente:
echo 1. curl -X POST https://n8n-kubectl.42web.io/webhook/whatsapp-bot
echo 2. Verificar respuesta en n8n
echo.

pause

echo.
echo ========================================
echo 💡 MENSAJE IMPORTANTE:
echo ========================================
echo.
echo ⚠️  RECUERDA: Los mensajes que te envías a TI MISMO
echo    NO se detectan. Necesitas que OTRA PERSONA
echo    te envíe un WhatsApp para que funcione.
echo.
echo ✅ Para probar usa: simulate-message.js
echo    Esto simula mensajes de otros usuarios.
echo.
echo 🎯 O pide a un amigo que te escriba por WhatsApp
echo    y verás inmediatamente los logs.
echo ========================================
