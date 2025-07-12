@echo off
echo 🚨 SOLUCION RAPIDA: Webhook no detecta mensajes
echo.

echo ============================================
echo ¿QUE HACER AHORA MISMO?
echo ============================================
echo.

echo 1. 📱 VERIFICAR WHATSAPP CONECTADO
echo    Ve a: http://localhost:3000
echo    Debe decir "WhatsApp Conectado" (verde)
echo.

echo 2. 🔄 REINICIAR SERVIDOR CON LOGS MEJORADOS
echo    Ejecuta estos comandos:
echo.
echo    Terminal 1: npm start
echo    Terminal 2: start-webhook-server.bat
echo.

echo 3. 📧 ENVIAR MENSAJE DE PRUEBA
echo    - Usa OTRO telefono (no el que tiene WhatsApp Web)
echo    - Envia un mensaje a TU numero de WhatsApp
echo    - Ve los logs en la consola
echo.

echo 4. 🎯 VERIFICAR EN N8N
echo    Ve a: https://jairgomez44.app.n8n.cloud
echo    - El workflow debe estar ACTIVO (verde)
echo    - Ve a "Executions" para ver si llegan datos
echo.

echo 5. 🧪 PROBAR MANUALMENTE
echo    node test-webhook-complete.js
echo.

echo ============================================
echo PROBLEMAS COMUNES Y SOLUCIONES:
echo ============================================
echo.

echo ❌ "WhatsApp not ready"
echo ✅ Ve a http://localhost:3000 y escanea QR
echo.

echo ❌ "No webhook URL configured"  
echo ✅ Verifica que .env tenga WEBHOOK_URL
echo.

echo ❌ "Webhook no responde"
echo ✅ Verifica workflow activo en n8n
echo.

echo ❌ "Error 404 en webhook"
echo ✅ Verifica el path exacto en n8n
echo.

echo ❌ "No llegan mensajes"
echo ✅ Envia desde OTRO telefono, no el mismo
echo.

echo ============================================
echo COMANDOS RAPIDOS:
echo ============================================
echo.

echo Para reiniciar todo:
echo   npm start
echo   start-webhook-server.bat
echo.

echo Para probar:
echo   node test-webhook-complete.js
echo.

echo Para verificar:
echo   diagnostico-webhook.bat
echo.

echo URLs importantes:
echo   http://localhost:3000 (Estado WhatsApp)
echo   http://localhost:3001 (Monitor mensajes)  
echo   https://jairgomez44.app.n8n.cloud (n8n)
echo.

pause
