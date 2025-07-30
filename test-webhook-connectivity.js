const axios = require('axios');

async function testWebhookEndpoint() {
    const webhookUrl = process.env.WEBHOOK_URL || 'https://n8n-kubectl.42web.io/webhook/whatsapp-bot';
    
    console.log('🔍 Probando conectividad con webhook:', webhookUrl);
    
    const testMessage = {
        id: 'test-' + Date.now(),
        from: '1234567890@c.us',
        body: 'Mensaje de prueba',
        timestamp: Date.now(),
        contact: {
            name: 'Test Contact',
            number: '1234567890'
        },
        type: 'chat',
        isGroup: false
    };

    try {
        const response = await axios.post(webhookUrl, testMessage, {
            headers: {
                'Content-Type': 'application/json',
                'User-Agent': 'WhatsApp-Webhook-Bot/1.0'
            },
            timeout: 10000
        });

        console.log('✅ Webhook responde correctamente:');
        console.log('   📊 Status:', response.status);
        console.log('   📦 Data:', response.data);
        console.log('   📋 Headers:', response.headers);
        
    } catch (error) {
        console.log('❌ Error conectando con webhook:');
        if (error.response) {
            console.log('   📊 Status:', error.response.status);
            console.log('   💬 Message:', error.response.statusText);
            console.log('   📦 Data:', error.response.data);
        } else if (error.request) {
            console.log('   🌐 No response received');
            console.log('   📋 Request:', error.request);
        } else {
            console.log('   ⚠️  Setup error:', error.message);
        }
    }
}

console.log('🚀 Iniciando prueba de webhook...');
testWebhookEndpoint();
