# 🔧 Guía Completa: n8n + WhatsApp Webhook Trigger

## 🎯 Tu configuración actual:
- ✅ WhatsApp Webhook Trigger funcionando
- ✅ Webhook URL configurada: `https://jairgomez44.app.n8n.cloud/webhook-test/...`
- ✅ Listo para recibir mensajes en n8n

---

## 🚀 Paso 1: Configurar el Webhook Trigger en n8n

### 1.1 Crear nuevo workflow
1. Ve a tu n8n: `https://jairgomez44.app.n8n.cloud`
2. Crea un nuevo workflow
3. Agrega el nodo **"Webhook"**

### 1.2 Configurar el nodo Webhook
```
HTTP Method: POST
Path: webhook-test/a32dc71c-6d7a-4e45-b34c-0ddb30be916e
Authentication: None
Response Code: 200
Response Data: JSON
```

### 1.3 Estructura del mensaje que recibirás:
```json
{
  "event": "message_received",
  "timestamp": "2025-07-12T...",
  "data": {
    "message": {
      "id": "mensaje_id_unico",
      "from": "5215551234567@c.us",
      "to": "tu_numero@c.us", 
      "body": "Hola, este es el mensaje",
      "type": "chat",
      "timestamp": 1673518200,
      "isGroup": false,
      "groupName": null,
      "hasMedia": false,
      "location": null,
      "links": ["http://..."],
      "mentions": []
    },
    "contact": {
      "id": "5215551234567@c.us",
      "name": "Juan Pérez",
      "number": "5215551234567",
      "isMyContact": true
    }
  }
}
```

---

## 🔧 Paso 2: Ejemplos de Flujos Prácticos

### 📋 Flujo Básico 1: Auto-respuesta Simple
```
Webhook → Function → HTTP Request (responder)
```

**Function Node (JavaScript):**
```javascript
// Extraer datos del mensaje
const message = $json.data.message;
const contact = $json.data.contact;

// Preparar respuesta automática
const response = {
  number: contact.number,
  message: `¡Hola ${contact.name}! 🤖
  
Recibí tu mensaje: "${message.body}"

Responderé pronto. Gracias por contactarme.`
};

return { json: response };
```

**HTTP Request Node:**
```
Method: POST
URL: http://tu-servidor:3000/send-message
Headers: Content-Type: application/json
Body: {{ $json }}
```

### 🤖 Flujo Avanzado 2: Chatbot Inteligente
```
Webhook → Switch → [Multiple Function Nodes] → HTTP Request
```

**Switch Node:** Evaluar `{{ $json.data.message.body }}`
- Rama 1: `contains(toLowerCase(), "hola")` → Saludo
- Rama 2: `contains(toLowerCase(), "precio")` → Info precios
- Rama 3: `contains(toLowerCase(), "horario")` → Info horarios
- Rama 4: Default → Respuesta genérica

**Function Node - Saludo:**
```javascript
const contact = $json.data.contact;
const hora = new Date().getHours();
let saludo;

if (hora < 12) saludo = "Buenos días";
else if (hora < 18) saludo = "Buenas tardes";
else saludo = "Buenas noches";

return {
  json: {
    number: contact.number,
    message: `${saludo} ${contact.name}! 👋
    
¿En qué puedo ayudarte hoy?

Opciones disponibles:
• Escribe "precio" para ver precios
• Escribe "horario" para horarios  
• Escribe "info" para más información`
  }
};
```

### 📊 Flujo 3: Guardar en Google Sheets
```
Webhook → Function → Google Sheets
```

**Function Node:**
```javascript
const message = $json.data.message;
const contact = $json.data.contact;

return {
  json: {
    timestamp: new Date().toISOString(),
    nombre: contact.name,
    numero: contact.number,
    mensaje: message.body,
    tipo: message.type,
    es_grupo: message.isGroup ? "Sí" : "No"
  }
};
```

### 🔔 Flujo 4: Notificaciones a Slack/Discord
```
Webhook → Function → Slack/Discord
```

**Function Node:**
```javascript
const message = $json.data.message;
const contact = $json.data.contact;

return {
  json: {
    text: `📱 Nuevo mensaje de WhatsApp
    
👤 *De:* ${contact.name} (${contact.number})
💬 *Mensaje:* ${message.body}
⏰ *Hora:* ${new Date().toLocaleString()}
${message.isGroup ? `👥 *Grupo:* ${message.groupName}` : ''}
${message.hasMedia ? '📎 *Contiene archivo adjunto*' : ''}`
  }
};
```

---

## 🎯 Paso 3: Flujos por Tipo de Negocio

### 🛒 E-commerce / Tienda Online
```javascript
// Detectar intención de compra
const mensaje = $json.data.message.body.toLowerCase();
const contact = $json.data.contact;

if (mensaje.includes("comprar") || mensaje.includes("precio")) {
  return {
    json: {
      number: contact.number,
      message: `🛒 ¡Perfecto! Te ayudo con tu compra.
      
📋 Nuestros productos disponibles:
• Producto A - $100
• Producto B - $200  
• Producto C - $300

Escribe el nombre del producto que te interesa.`
    }
  };
}
```

### 🏥 Citas Médicas / Servicios
```javascript
const mensaje = $json.data.message.body.toLowerCase();

if (mensaje.includes("cita") || mensaje.includes("turno")) {
  return {
    json: {
      number: $json.data.contact.number,
      message: `📅 Agenda tu cita médica
      
Horarios disponibles esta semana:
• Lunes 10:00 - 16:00
• Martes 09:00 - 15:00
• Miércoles 11:00 - 17:00

Escribe el día y hora que prefieres.`
    }
  };
}
```

### 🎓 Educación / Cursos
```javascript
if (mensaje.includes("curso") || mensaje.includes("clase")) {
  return {
    json: {
      number: contact.number,
      message: `🎓 Cursos disponibles:
      
📚 Programación - $500
💻 Diseño Web - $400
📱 Marketing Digital - $300

¿Cuál te interesa? Te envío más información.`
    }
  };
}
```

---

## 🔧 Paso 4: Configuraciones Avanzadas

### 🕐 Horarios de Atención
```javascript
const ahora = new Date();
const hora = ahora.getHours();
const dia = ahora.getDay(); // 0=Domingo, 6=Sábado

// Fuera de horario
if (hora < 9 || hora > 18 || dia === 0 || dia === 6) {
  return {
    json: {
      number: contact.number,
      message: `🕐 Horario de atención:
      
Lunes a Viernes: 9:00 AM - 6:00 PM
Sábados y Domingos: Cerrado

Tu mensaje ha sido recibido y te responderemos en horario hábil. ¡Gracias!`
    }
  };
}
```

### 🚫 Filtros Anti-Spam
```javascript
const mensaje = $json.data.message.body;

// Filtrar mensajes muy cortos o spam
if (mensaje.length < 3) {
  return { json: null }; // No procesar
}

// Filtrar palabras prohibidas
const palabrasProhibidas = ["spam", "oferta", "gratis"];
if (palabrasProhibidas.some(palabra => mensaje.toLowerCase().includes(palabra))) {
  return { json: null };
}
```

### 📱 Manejo de Archivos
```javascript
const message = $json.data.message;

if (message.hasMedia) {
  const tipoArchivo = message.media?.mimetype || "desconocido";
  
  return {
    json: {
      number: contact.number,
      message: `📎 Archivo recibido (${tipoArchivo})
      
Estamos procesando tu archivo. Te responderemos pronto con la información solicitada.`
    }
  };
}
```

---

## 📊 Paso 5: Monitoreo y Analytics

### 📈 Contador de Mensajes (usando n8n Memory)
```javascript
// Obtener contador actual
let contador = $workflow.memoryCurrent.mensajes || 0;
contador++;

// Guardar nuevo contador
$workflow.memorySet.mensajes = contador;

console.log(`Total mensajes procesados: ${contador}`);
```

### 📋 Dashboard Simple
Crea un workflow que:
1. **Cada hora** (Cron Trigger)
2. **Lee datos** de Google Sheets
3. **Calcula estadísticas**
4. **Envía reporte** por email/Slack

---

## 🎯 Próximos Pasos Recomendados:

1. **Empezar simple:** Crea el flujo básico de auto-respuesta
2. **Probar con tu número:** Envíate mensajes para probar
3. **Agregar lógica:** Usar Switch nodes para diferentes respuestas
4. **Integrar servicios:** Google Sheets, Slack, email, etc.
5. **Monitorear:** Agregar logs y estadísticas

### 🔗 Enlaces útiles:
- Tu webhook: `https://jairgomez44.app.n8n.cloud/webhook-test/...`
- Panel WhatsApp: `http://localhost:3000`
- Monitor mensajes: `http://localhost:3001`

¿Te gustaría que te ayude a crear algún flujo específico? 🚀
