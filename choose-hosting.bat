@echo off
echo.
echo 🌐 SELECTOR DE HOSTING PARA WEBHOOKS
echo ===================================
echo.

echo Tu configuración actual:
echo 🔗 WEBHOOK_URL=https://n8n-kubectl.42web.io/webhook/whatsapp-bot
echo 📊 Estado: ❌ No funciona (devuelve HTML)
echo.

echo 🎯 OPCIONES DISPONIBLES:
echo ========================
echo.
echo [1] 🚀 Railway.app (RECOMENDADO)
echo     - Deploy en 2 minutos
echo     - URL permanente  
echo     - $5 USD gratis/mes
echo     - Perfecto para producción
echo.
echo [2] 🎨 Render.com (ESTABLE)
echo     - Deploy desde GitHub
echo     - 750 horas gratis/mes
echo     - Muy confiable
echo     - Ideal para largo plazo
echo.
echo [3] 🏠 ngrok (RÁPIDO/TEMPORAL)
echo     - Funciona en 30 segundos
echo     - Para pruebas inmediatas
echo     - URL cambia al reiniciar
echo     - Perfecto para confirmar que funciona
echo.
echo [4] ☁️ AWS EC2 (POTENTE/COMPLEJO)
echo     - Tier gratuito 12 meses
echo     - Control total del servidor
echo     - Setup: 1-2 horas
echo     - Para aplicaciones serias
echo.
echo [5] 🧪 webhook.site (SOLO PRUEBAS)
echo     - Para verificar que llegan datos
echo     - No ejecuta n8n
echo     - Solo diagnóstico
echo.
echo [6] 🔧 Ayuda con n8n actual
echo     - Intentar arreglar tu n8n
echo     - Verificar configuración
echo.

set /p choice="Elige una opción (1-6): "

if "%choice%"=="1" goto railway
if "%choice%"=="2" goto render  
if "%choice%"=="3" goto ngrok
if "%choice%"=="4" goto aws_ec2
if "%choice%"=="5" goto webhook_site
if "%choice%"=="6" goto fix_n8n
goto invalid

:railway
echo.
echo 🚀 RAILWAY.APP SELECCIONADO
echo ===========================
call deploy-railway.bat
goto end

:render
echo.
echo 🎨 RENDER.COM SELECCIONADO
echo =========================
call deploy-render.bat
goto end

:ngrok
echo.
echo 🏠 NGROK SELECCIONADO
echo ====================
call setup-ngrok-temp.bat
goto end

:aws_ec2
echo.
echo ☁️ AWS EC2 SELECCIONADO
echo ======================
echo.
echo ⚠️  ADVERTENCIA: AWS EC2 requiere 1-2 horas de configuración
echo    y conocimientos básicos de Linux/servidores.
echo.
echo ¿Estás seguro? Railway funciona en 2 minutos...
echo.
set /p confirm="¿Continuar con EC2? (y/n): "
if /i "%confirm%"=="y" goto ec2_guide
if /i "%confirm%"=="s" goto ec2_guide
echo.
echo 💡 Quizás prefieras Railway (opción 1) que es mucho más fácil
pause
goto end

:ec2_guide
echo.
echo 📖 Abriendo guía completa de AWS EC2...
start aws-ec2-guide.md
echo.
echo 📋 Pasos a seguir:
echo 1. Lee la guía completa en aws-ec2-guide.md
echo 2. Ve a https://aws.amazon.com/console/
echo 3. Sigue los pasos detallados
echo 4. El proceso tomará 1-2 horas
echo.
echo 💡 ALTERNATIVA RÁPIDA: Usa Railway (2 minutos)
echo    Ejecuta: choose-hosting.bat y elige opción 1
echo.
pause
goto end

:webhook_site
echo.
echo 🧪 WEBHOOK.SITE PARA PRUEBAS
echo ============================
call setup-test-webhook.bat
goto end

:fix_n8n
echo.
echo 🔧 AYUDA CON N8N ACTUAL
echo ======================
call fix-n8n-webhook.bat
goto end

:invalid
echo.
echo ❌ Opción inválida
echo Ejecuta el script de nuevo
pause
goto end

:end
echo.
echo 🏁 Proceso completado
echo.
echo 💡 SIGUIENTE PASO:
echo ==================
echo Una vez que tengas el hosting funcionando:
echo 1. Copia la nueva URL
echo 2. Ve a tu workflow de n8n
echo 3. En el nodo HTTP Request, cambia la URL a:
echo    https://tu-nueva-url.com/send-message
echo.
pause
