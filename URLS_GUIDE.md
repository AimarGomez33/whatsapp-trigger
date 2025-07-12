# 🌐 Guía de URLs - WhatsApp Webhook Trigger

## 🏠 Puerto 3000 - Servidor Principal (API de WhatsApp)

### ✅ http://localhost:3000/
**¡NUEVA PÁGINA PRINCIPAL!**
- 📊 Panel de control completo
- 🟢/🔴 Estado de conexión de WhatsApp
- 📝 Lista de todos los endpoints
- ⚙️ Configuración actual
- 📱 Enlaces para conectar WhatsApp
- 🔄 Se actualiza automáticamente cada 30 segundos

### 📊 http://localhost:3000/status
```json
{
  "status": "running",
  "whatsapp_connected": true,
  "timestamp": "2025-07-12T..."
}
```

### 📱 http://localhost:3000/qr
- Obtiene el código QR para conectar WhatsApp
- Solo funciona si WhatsApp no está conectado

### 💬 http://localhost:3000/send-message
```bash
curl -X POST http://localhost:3000/send-message \
  -H "Content-Type: application/json" \
  -d '{
    "number": "5215551234567",
    "message": "Hola desde la API!"
  }'
```

---

## 🎯 Puerto 3001 - Servidor de Monitoreo (Webhooks)

### 🏠 http://localhost:3001/
- 📱 Monitor web para ver mensajes recibidos
- 📋 Lista de todos los mensajes en tiempo real
- 🗑️ Botón para limpiar mensajes
- 🔄 Se actualiza automáticamente cada 5 segundos

### 📥 http://localhost:3001/webhook/whatsapp
- **Endpoint para recibir webhooks**
- Aquí llegan los mensajes de WhatsApp
- Formato JSON estructurado
- Para integrar con n8n, usa esta URL

### 📋 http://localhost:3001/messages
```json
{
  "total": 5,
  "limit": 10,
  "messages": [...]
}
```

---

## 🔧 ¿Cuál usar para qué?

### 🎯 **Para enviar mensajes** → `http://localhost:3000`
```bash
# Enviar mensaje
POST http://localhost:3000/send-message

# Ver estado
GET http://localhost:3000/status
```

### 📱 **Para recibir mensajes** → `http://localhost:3001`
```bash
# Ver mensajes recibidos
GET http://localhost:3001/messages

# Webhook endpoint (para n8n)
POST http://localhost:3001/webhook/whatsapp
```

### 🏠 **Para monitorear** → Ambos tienen páginas web
- `http://localhost:3000/` → Control y estado de WhatsApp
- `http://localhost:3001/` → Monitor de mensajes recibidos

---

## 🚨 Solución: "Cannot GET /"

### ❌ Problema anterior:
- `http://localhost:3000/` daba error "Cannot GET /"
- Solo funcionaban endpoints específicos como `/status`

### ✅ Solución aplicada:
- ✅ Se agregó una página principal bonita en `/`
- ✅ Ahora `http://localhost:3000/` muestra toda la información
- ✅ Panel de control completo con estado y enlaces

### 🔄 Para aplicar la solución:
1. **Detén el servidor** (Ctrl+C en la terminal)
2. **Reinicia:** `npm start`
3. **Ve a:** `http://localhost:3000/`
4. **¡Disfruta!** Ya no más "Cannot GET /"

---

## 💡 Tips útiles

### 🔗 **Integración con n8n:**
```
URL del webhook en n8n: http://localhost:3001/webhook/whatsapp
```

### 🔄 **Auto-refresh:**
- Página principal (3000): cada 30 segundos
- Monitor (3001): cada 5 segundos

### 📱 **Estados de WhatsApp:**
- 🟢 Verde = Conectado y funcionando
- 🔴 Rojo = Necesita escanear QR

### 🛠️ **Desarrollo:**
- Modo debug activado: logs detallados en consola
- Errores mostrados en tiempo real
- Reintentos automáticos para webhooks
