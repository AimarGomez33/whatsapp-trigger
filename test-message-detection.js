const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');

console.log('🔍 DIAGNOSTICO: DETECCION DE MENSAJES ENTRANTES');
console.log('=' .repeat(50));
console.log('');

const client = new Client({
    authStrategy: new LocalAuth({
        name: 'test-detection'
    }),
    puppeteer: {
        headless: false,
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox'
        ]
    }
});

let messageCount = 0;

client.on('qr', (qr) => {
    console.log('📱 Escanea este código QR:');
    qrcode.generate(qr, { small: true });
    console.log('');
});

client.on('ready', () => {
    console.log('✅ WhatsApp conectado y listo');
    console.log('🎯 AHORA ENVÍA UN MENSAJE A ESTE WHATSAPP DESDE OTRO TELÉFONO');
    console.log('📋 Se mostrará TODA la información del mensaje recibido');
    console.log('=' .repeat(50));
    console.log('');
});

client.on('message', async (message) => {
    messageCount++;
    
    console.log(`🎉 ¡MENSAJE #${messageCount} DETECTADO!`);
    console.log('=' .repeat(30));
    console.log(`⏰ Timestamp: ${new Date().toISOString()}`);
    console.log(`🆔 Message ID: ${message.id._serialized}`);
    console.log(`📱 From: ${message.from}`);
    console.log(`💬 Body: ${message.body}`);
    console.log(`📋 Type: ${message.type}`);
    console.log(`👁️  From Me: ${message.fromMe}`);
    console.log(`🏷️  Is Group: ${message.isGroupMsg || false}`);
    
    if (message.fromMe) {
        console.log('⏭️  IGNORANDO: Es un mensaje enviado por mí');
    } else {
        console.log('✅ PROCESANDO: Es un mensaje entrante válido');
        
        try {
            const contact = await message.getContact();
            console.log(`👤 Contact Name: ${contact.name || contact.pushname || 'Sin nombre'}`);
            console.log(`📞 Contact Number: ${contact.number}`);
            
            console.log('');
            console.log('🎯 ESTE MENSAJE DEBERÍA ACTIVAR EL WEBHOOK');
            console.log('   Si ves esto, la detección funciona correctamente');
            console.log('   El problema estaría en el envío al webhook o en n8n');
        } catch (error) {
            console.log(`❌ Error obteniendo contacto: ${error.message}`);
        }
    }
    
    console.log('=' .repeat(30));
    console.log('');
});

client.on('message_create', (message) => {
    console.log(`📤 MESSAGE_CREATE: ${message.fromMe ? 'Enviado' : 'Recibido'} - ${message.body?.substring(0, 50) || 'Sin texto'}...`);
});

client.on('authenticated', () => {
    console.log('🔐 Autenticado correctamente');
});

client.on('auth_failure', (msg) => {
    console.error('❌ Error de autenticación:', msg);
});

client.on('disconnected', (reason) => {
    console.log('🔌 Desconectado:', reason);
});

console.log('🚀 Inicializando WhatsApp...');
client.initialize();

process.on('SIGINT', () => {
    console.log('\n🛑 Cerrando...');
    client.destroy();
    process.exit(0);
});
