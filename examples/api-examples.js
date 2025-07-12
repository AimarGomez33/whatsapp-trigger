const axios = require('axios');

class WhatsAppAPI {
    constructor(baseUrl = 'http://localhost:3000') {
        this.baseUrl = baseUrl;
    }

    async getStatus() {
        try {
            const response = await axios.get(`${this.baseUrl}/status`);
            return response.data;
        } catch (error) {
            throw new Error(`Error getting status: ${error.message}`);
        }
    }

    async sendMessage(number, message, media = null) {
        try {
            const payload = {
                number,
                message,
                ...(media && { media })
            };

            const response = await axios.post(`${this.baseUrl}/send-message`, payload);
            return response.data;
        } catch (error) {
            throw new Error(`Error sending message: ${error.message}`);
        }
    }

    async getQR() {
        try {
            const response = await axios.get(`${this.baseUrl}/qr`);
            return response.data;
        } catch (error) {
            throw new Error(`Error getting QR: ${error.message}`);
        }
    }

    async disconnect() {
        try {
            const response = await axios.post(`${this.baseUrl}/disconnect`);
            return response.data;
        } catch (error) {
            throw new Error(`Error disconnecting: ${error.message}`);
        }
    }
}

// Ejemplos de uso
async function examples() {
    const whatsapp = new WhatsAppAPI();

    try {
        console.log('📊 Verificando estado...');
        const status = await whatsapp.getStatus();
        console.log('Estado:', status);

        if (!status.whatsapp_connected) {
            console.log('📱 WhatsApp no conectado, obteniendo QR...');
            const qr = await whatsapp.getQR();
            console.log('QR:', qr);
            return;
        }

        console.log('✅ WhatsApp conectado, enviando mensaje de prueba...');
        
        // Cambia este número por uno válido para pruebas
        const testNumber = '5215551234567'; // Formato: código país + número
        const message = '🤖 Mensaje de prueba desde WhatsApp Webhook Trigger\n\n' +
                       'Tiempo: ' + new Date().toLocaleString() + '\n' +
                       'Si recibes este mensaje, ¡todo funciona correctamente!';

        const result = await whatsapp.sendMessage(testNumber, message);
        console.log('✅ Mensaje enviado:', result);

    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

// Test de conexión webhook
async function testWebhook() {
    console.log('🧪 Probando webhook...');
    
    const testPayload = {
        event: 'message_received',
        timestamp: new Date().toISOString(),
        data: {
            message: {
                id: 'test_message_' + Date.now(),
                from: '5215551234567@c.us',
                body: 'Mensaje de prueba para webhook',
                type: 'chat',
                timestamp: Math.floor(Date.now() / 1000),
                isForwarded: false,
                isGroup: false
            },
            contact: {
                name: 'Usuario de Prueba',
                number: '5215551234567'
            }
        }
    };

    try {
        const response = await axios.post('http://localhost:3001/webhook/whatsapp', testPayload);
        console.log('✅ Webhook test exitoso:', response.data);
    } catch (error) {
        console.error('❌ Error en webhook test:', error.message);
    }
}

// Ejecutar ejemplos si este archivo se ejecuta directamente
if (require.main === module) {
    const command = process.argv[2];
    
    switch (command) {
        case 'test':
            examples();
            break;
        case 'webhook':
            testWebhook();
            break;
        case 'status':
            new WhatsAppAPI().getStatus().then(console.log).catch(console.error);
            break;
        default:
            console.log(`
🔧 WhatsApp API Examples

Uso: node examples/api-examples.js [comando]

Comandos disponibles:
  test     - Prueba completa del API
  webhook  - Prueba del webhook
  status   - Verificar estado de conexión

Ejemplos:
  node examples/api-examples.js test
  node examples/api-examples.js webhook
  node examples/api-examples.js status
            `);
    }
}

module.exports = WhatsAppAPI;
