# 🧪 Guía de Pruebas - WhatsApp Webhook

## ⚠️ IMPORTANTE: Limitaciones de WhatsApp Web

### ❌ Lo que NO funciona:
- **Mensajes que te envías a ti mismo** (desde el mismo número)
- Mensajes enviados desde WhatsApp Web
- Mensajes enviados desde la misma sesión que está conectada

### ✅ Lo que SÍ funciona:
- **Mensajes de otros contactos a tu número**
- Mensajes de grupos donde participas
- Mensajes de números diferentes al tuyo

## 🎯 Cómo probar correctamente:

### Opción 1: Con otro teléfono
1. Pide a alguien que te envíe un WhatsApp
2. O usa otro teléfono/número diferente
3. Envía mensaje a tu número principal

### Opción 2: Con grupos
1. Crea un grupo de WhatsApp
2. Invita a tu número principal
3. Envía mensajes desde otro número en el grupo

### Opción 3: Simulación para desarrollo
```cmd
# Ejecuta el servidor de pruebas que simula mensajes
npm run test
```

## 📱 Proceso de prueba paso a paso:

### 1. Inicia el sistema
```cmd
start.bat
```

### 2. Conecta WhatsApp
- Ve a `http://localhost:3000`
- Escanea el QR con tu WhatsApp
- Espera a ver "✅ WhatsApp conectado"

### 3. Verifica el webhook
```cmd
test-new-webhook.bat
```

### 4. Prueba real
**❌ NO hagas esto:**
- Enviar mensaje desde tu mismo WhatsApp
- Enviar desde WhatsApp Web

**✅ HAZ esto:**
- Pide a un amigo que te envíe un mensaje
- Usa otro teléfono
- Envía desde un grupo

### 5. Monitorea los logs
Deberías ver en la consola:
```
📨 Nuevo mensaje recibido
👤 De: Nombre del contacto (+5215551234567)
💬 Mensaje: Hola, esto es una prueba
🎯 Enviando a webhook...
✅ Webhook enviado exitosamente
```

## 🔧 Solución de problemas:

### Si no aparecen mensajes:
1. ✅ Verifica que WhatsApp esté conectado
2. ✅ Confirma que el mensaje NO sea tuyo
3. ✅ Revisa que el webhook esté configurado
4. ✅ Verifica que n8n esté activo

### Comandos útiles:
```cmd
# Ver estado completo
node test-new-webhook.js

# Solo webhook de prueba
curl -X POST https://n8n-kubectl.42web.io/webhook/whatsapp-bot -H "Content-Type: application/json" -d "{\"test\": true}"

# Ver logs del servidor
# (en la consola donde corre npm start)
```

## 🎯 URLs importantes:
- **Estado:** http://localhost:3000/status
- **QR Code:** http://localhost:3000/qr  
- **Monitor:** http://localhost:3001
- **n8n:** https://n8n-kubectl.42web.io

## 💡 Tip para desarrollo:
Para probar sin molestar a otros, puedes usar el simulador:
```cmd
npm run webhook-server  # En una terminal
node simulate-message.js  # En otra terminal
```

¡La clave es que el mensaje debe venir de un número DIFERENTE al tuyo!
