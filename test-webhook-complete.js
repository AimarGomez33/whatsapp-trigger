const axios = require('axios');

async function testWebhookFlow() {
    console.log('🧪 PRUEBA COMPLETA: WhatsApp → Webhook → n8n');
    console.log('='.repeat(50));
    
    // 1. Verificar servidor principal
    console.log('\n1. 📡 Verificando servidor principal...');
    try {
        const statusResponse = await axios.get('http://localhost:3000/status');
        console.log('✅ Servidor principal OK:', statusResponse.data);
        
        if (!statusResponse.data.whatsapp_connected) {
            console.log('⚠️ WhatsApp NO conectado. Ve a http://localhost:3000 y escanea QR');
            return;
        }
    } catch (error) {
        console.log('❌ Error servidor principal:', error.message);
        console.log('🔧 Solución: Ejecuta "npm start"');
        return;
    }
    
    // 2. Verificar servidor de pruebas
    console.log('\n2. 🎯 Verificando servidor de pruebas...');
    try {
        const testResponse = await axios.get('http://localhost:3001/status');
        console.log('✅ Servidor de pruebas OK:', testResponse.data);
    } catch (error) {
        console.log('❌ Error servidor de pruebas:', error.message);
        console.log('🔧 Solución: Ejecuta "start-webhook-server.bat"');
    }
    
    // 3. Simular mensaje de WhatsApp
    console.log('\n3. 📱 Simulando mensaje de WhatsApp...');
    const testMessage = {
        event: 'message_received',
        timestamp: new Date().toISOString(),
        data: {
            message: {
                id: 'test_message_' + Date.now(),
                from: '5215551234567@c.us',
                to: 'tu_numero@c.us',
                body: 'Mensaje de prueba para webhook',
                type: 'chat',
                timestamp: Math.floor(Date.now() / 1000),
                isForwarded: false,
                isGroup: false,
                groupName: null,
                hasMedia: false,
                media: null,
                location: null,
                quotedMessage: null,
                links: [],
                mentions: []
            },
            contact: {
                id: '5215551234567@c.us',
                name: 'Usuario de Prueba',
                number: '5215551234567',
                isMyContact: true
            },
            metadata: {
                source: 'whatsapp-web-js',
                version: '1.0.0',
                processed_at: new Date().toISOString()
            }
        }
    };
    
    // 4. Enviar a webhook local (servidor de pruebas)
    console.log('\n4. 🔗 Probando webhook local...');
    try {
        const localResponse = await axios.post('http://localhost:3001/webhook/whatsapp', testMessage);
        console.log('✅ Webhook local OK:', localResponse.data);
    } catch (error) {
        console.log('❌ Error webhook local:', error.message);
    }
    
    // 5. Enviar a webhook de n8n
    console.log('\n5. 🚀 Probando webhook de n8n...');
    const webhookUrl = process.env.WEBHOOK_URL || 'https://jairgomez44.app.n8n.cloud/webhook-test/a32dc71c-6d7a-4e45-b34c-0ddb30be916e';
    
    try {
        const n8nResponse = await axios.post(webhookUrl, testMessage, {
            headers: {
                'Content-Type': 'application/json',
                'User-Agent': 'WhatsApp-Webhook-Test/1.0'
            },
            timeout: 10000
        });
        console.log('✅ Webhook n8n OK:', n8nResponse.status, n8nResponse.data);
    } catch (error) {
        console.log('❌ Error webhook n8n:', error.message);
        
        if (error.code === 'ECONNREFUSED') {
            console.log('🔧 El webhook de n8n no responde. Verifica:');
            console.log('   - Workflow activo en n8n');
            console.log('   - URL correcta en .env');
        } else if (error.response?.status === 404) {
            console.log('🔧 Webhook no encontrado. Verifica:');
            console.log('   - Path correcto en n8n');
            console.log('   - URL exacta en .env');
        }
    }
    
    // 6. Verificar logs del servidor de pruebas
    console.log('\n6. 📋 Verificando mensajes recibidos...');
    try {
        const messagesResponse = await axios.get('http://localhost:3001/messages?limit=5');
        console.log('📬 Últimos mensajes:', messagesResponse.data.total, 'total');
        
        if (messagesResponse.data.messages.length > 0) {
            console.log('📨 Último mensaje:', messagesResponse.data.messages[0]);
        }
    } catch (error) {
        console.log('❌ Error obteniendo mensajes:', error.message);
    }
    
    console.log('\n' + '='.repeat(50));
    console.log('🎯 RESUMEN DE LA PRUEBA:');
    console.log('1. Si todos los pasos son ✅, el sistema funciona');
    console.log('2. Si hay ❌, sigue las soluciones indicadas');
    console.log('3. Para probar real: envía WhatsApp desde OTRO teléfono');
    console.log('\n💡 Monitoreo en tiempo real:');
    console.log('   - http://localhost:3000 (Estado WhatsApp)');
    console.log('   - http://localhost:3001 (Monitor mensajes)');
    console.log('   - https://jairgomez44.app.n8n.cloud (n8n executions)');
}

// Función para probar envío de respuesta
async function testSendMessage() {
    console.log('\n🔄 PRUEBA ADICIONAL: Envío de mensaje...');
    
    const testResponse = {
        number: '5215551234567', // Cambia por tu número
        message: '🤖 Mensaje de prueba desde el sistema\n\nSi recibes esto, ¡todo funciona perfectamente!\n\nHora: ' + new Date().toLocaleString()
    };
    
    try {
        const response = await axios.post('http://localhost:3000/send-message', testResponse);
        console.log('✅ Mensaje enviado correctamente:', response.data);
    } catch (error) {
        console.log('❌ Error enviando mensaje:', error.message);
        
        if (error.response?.data) {
            console.log('   Detalles:', error.response.data);
        }
    }
}

// Ejecutar las pruebas
async function runAllTests() {
    require('dotenv').config();
    
    await testWebhookFlow();
    
    // Preguntar si quiere probar envío de mensaje
    const readline = require('readline');
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });
    
    rl.question('\n¿Quieres probar envío de mensaje? (y/n): ', async (answer) => {
        if (answer.toLowerCase() === 'y' || answer.toLowerCase() === 'yes') {
            await testSendMessage();
        }
        
        console.log('\n🎉 Pruebas completadas');
        rl.close();
    });
}

runAllTests().catch(console.error);
