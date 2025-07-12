@echo off
echo.
echo 🤖 SIMULADOR DE MENSAJES WHATSAPP
echo =================================
echo.
echo Este script simula mensajes que llegan de OTROS contactos
echo (Los mensajes propios NO se detectan en WhatsApp Web)
echo.

cd /d "c:\Users\jair_\Desktop\trigger"

echo Opciones disponibles:
echo.
echo 1. Simular UN mensaje
echo 2. Simular MÚLTIPLES mensajes  
echo 3. Mensaje PERSONALIZADO (interactivo)
echo 4. Mensaje PERSONALIZADO (rápido)
echo 5. Ver guía de pruebas
echo 6. Ver ayuda completa
echo.

set /p choice="Elige una opción (1-6): "

if "%choice%"=="1" (
    echo.
    echo 📱 Simulando mensaje único...
    node simulate-message.js
) else if "%choice%"=="2" (
    echo.
    echo 📱 Simulando múltiples mensajes...
    node simulate-message.js multiple
) else if "%choice%"=="3" (
    echo.
    echo � Creador de mensaje personalizado (interactivo)...
    node simulate-message.js custom
) else if "%choice%"=="4" (
    echo.
    set /p custommsg="💬 Escribe tu mensaje: "
    set /p customname="👤 Nombre del remitente: "
    set /p customnumber="📱 Número (opcional): "
    if "%customnumber%"=="" set customnumber=5215551234567
    echo.
    echo 📱 Enviando mensaje personalizado...
    node simulate-message.js custom "%custommsg%" "%customname%" "%customnumber%"
) else if "%choice%"=="5" (
    echo.
    echo �📖 Abriendo guía de pruebas...
    type TESTING-GUIDE.md
) else if "%choice%"=="6" (
    echo.
    echo 📖 Mostrando ayuda completa...
    node simulate-message.js help
) else (
    echo.
    echo ❌ Opción inválida
)

echo.
echo =================================
echo 💡 RECUERDA: Para pruebas reales
echo    pide a OTRA PERSONA que te envíe
echo    un WhatsApp. Los mensajes propios
echo    NO se detectan.
echo =================================
echo.
pause
