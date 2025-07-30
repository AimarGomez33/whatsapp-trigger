require('dotenv').config();
const express = require('express');
const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');
const axios = require('axios');

class DebugWhatsAppServer {
    constructor() {
        this.app = express();
        this.port = process.env.PORT || 3000;
        this.webhookUrl = process.env.WEBHOOK_URL;
        this.client = null;
        this.isReady = false;
        
        console.log('🔧 SERVIDOR DE DIAGNÓSTICO INICIADO');
        console.log('📋 Configuración:');
        console.log(`   🌐 Puerto: ${this.port}`);
        console.log(`   🔗 Webhook URL: ${this.webhookUrl || 'NO CONFIGURADO'}`);
        console.log('');
        
        this.setupExpress();
        this.setupWhatsApp();
    }

    setupExpress() {
        console.log('⚙️  Configurando Express...');
        
        this.app.use(express.json());
        this.app.use((req, res, next) => {
            console.log(`🌐 ${new Date().toISOString()} - ${req.method} ${req.path}`);
            next();
        });

        this.app.get('/status', (req, res) => {
            const status = {
                status: 'running',
                whatsapp_connected: this.isReady,
                webhook_configured: !!this.webhookUrl,
                timestamp: new Date().toISOString()
            };
            console.log('📊 Status check:', status);
            res.json(status);
        });

        this.app.post('/send-message', async (req, res) => {
            console.log('📤 Solicitud de envío de mensaje:', req.body);
            
            if (!this.isReady) {
                console.log('❌ WhatsApp no está listo');
                return res.status(503).json({ error: 'WhatsApp not ready' });
            }

            try {
                const { number, message } = req.body;
                const chatId = number.includes('@') ? number : `${number}@c.us`;
                
                console.log(`📱 Enviando mensaje a ${chatId}: ${message}`);
                await this.client.sendMessage(chatId, message);
                console.log('✅ Mensaje enviado correctamente');
                
                res.json({ success: true, message: 'Message sent' });
            } catch (error) {
                console.error('❌ Error enviando mensaje:', error);
                res.status(500).json({ error: error.message });
            }
        });
    }

    setupWhatsApp() {
        console.log('⚙️  Configurando WhatsApp...');
        
        this.client = new Client({
            authStrategy: new LocalAuth({
                name: 'debug-session'
            }),
            puppeteer: {
                headless: false, // Cambiar a true en producción
                args: [
                    '--no-sandbox',
                    '--disable-setuid-sandbox',
                    '--disable-dev-shm-usage'
                ]
            }
        });

        this.client.on('qr', (qr) => {
            console.log('📱 CÓDIGO QR GENERADO - Escanéalo con tu teléfono:');
            qrcode.generate(qr, { small: true });
        });

        this.client.on('ready', () => {
            this.isReady = true;
            console.log('✅ WHATSAPP WEB ESTÁ LISTO!');
            console.log('🎯 Ahora puedes enviar un mensaje a tu WhatsApp para probarlo');
            console.log('🔍 Esperando mensajes entrantes...');
            console.log('=' .repeat(60));
        });

        this.client.on('authenticated', () => {
            console.log('🔐 WhatsApp autenticado correctamente');
        });

        this.client.on('auth_failure', (msg) => {
            console.error('❌ Error de autenticación WhatsApp:', msg);
        });

        this.client.on('disconnected', (reason) => {
            this.isReady = false;
            console.log('🔌 WhatsApp desconectado:', reason);
        });

        // EVENTO PRINCIPAL DE MENSAJES
        this.client.on('message', async (message) => {
            console.log('🎉 ¡EVENTO MESSAGE DETECTADO!');
            console.log('=' .repeat(60));
            console.log('📱 Información del mensaje:');
            console.log(`   🆔 ID: ${message.id._serialized}`);
            console.log(`   👤 De: ${message.from}`);
            console.log(`   💬 Texto: ${message.body}`);
            console.log(`   📅 Timestamp: ${message.timestamp}`);
            console.log(`   🏷️  Tipo: ${message.type}`);
            console.log(`   👁️  Es mío: ${message.fromMe}`);
            console.log(`   👥 Es grupo: ${message.isGroupMsg || false}`);

            // Solo procesar mensajes que NO sean míos
            if (message.fromMe) {
                console.log('⏭️  Ignorando mensaje enviado por mí');
                console.log('=' .repeat(60));
                return;
            }

            try {
                // Obtener información del contacto
                const contact = await message.getContact();
                const chat = await message.getChat();
                
                console.log('👤 Información del contacto:');
                console.log(`   📛 Nombre: ${contact.name || contact.pushname || 'Sin nombre'}`);
                console.log(`   📞 Número: ${contact.number}`);
                console.log(`   🏷️  Es contacto: ${contact.isMyContact}`);

                // Preparar datos para webhook
                const messageData = {
                    id: message.id._serialized,
                    from: message.from,
                    body: message.body,
                    timestamp: message.timestamp,
                    type: message.type,
                    contact: {
                        name: contact.name || contact.pushname,
                        number: contact.number,
                        isMyContact: contact.isMyContact
                    },
                    isGroup: chat.isGroup,
                    groupName: chat.isGroup ? chat.name : null
                };

                console.log('📦 Datos preparados para webhook:');
                console.log(JSON.stringify(messageData, null, 2));

                // Enviar a webhook
                if (this.webhookUrl) {
                    console.log('🚀 Enviando a webhook...');
                    await this.sendToWebhook(messageData);
                } else {
                    console.log('⚠️  No hay webhook configurado');
                }

            } catch (error) {
                console.error('❌ Error procesando mensaje:', error);
            }
            
            console.log('=' .repeat(60));
        });

        // También escuchar message_create para ver si hay diferencia
        this.client.on('message_create', (message) => {
            console.log('🌟 EVENTO MESSAGE_CREATE DETECTADO:');
            console.log(`   De: ${message.from}, Texto: ${message.body}, Es mío: ${message.fromMe}`);
        });

        console.log('🚀 Inicializando cliente WhatsApp...');
        this.client.initialize();
    }

    async sendToWebhook(messageData) {
        try {
            console.log(`🔗 Enviando POST a: ${this.webhookUrl}`);
            
            const response = await axios.post(this.webhookUrl, messageData, {
                headers: {
                    'Content-Type': 'application/json',
                    'User-Agent': 'WhatsApp-Debug-Bot/1.0'
                },
                timeout: 10000
            });

            console.log('✅ Webhook response:');
            console.log(`   📊 Status: ${response.status}`);
            console.log(`   📦 Data: ${JSON.stringify(response.data).substring(0, 200)}...`);
            
        } catch (error) {
            console.error('❌ Error enviando webhook:');
            if (error.response) {
                console.error(`   📊 Status: ${error.response.status}`);
                console.error(`   💬 Status Text: ${error.response.statusText}`);
                console.error(`   📦 Data: ${JSON.stringify(error.response.data).substring(0, 200)}...`);
            } else if (error.request) {
                console.error('   🌐 No response received');
                console.error(`   📋 Request: ${error.request}`);
            } else {
                console.error(`   ⚠️  Setup error: ${error.message}`);
            }
        }
    }

    start() {
        this.app.listen(this.port, () => {
            console.log(`🌐 Servidor Express corriendo en http://localhost:${this.port}`);
            console.log('🔍 Endpoints disponibles:');
            console.log(`   📊 GET  /status - Estado del servidor`);
            console.log(`   📤 POST /send-message - Enviar mensaje`);
            console.log('');
        });
    }
}

// Iniciar servidor
const server = new DebugWhatsAppServer();
server.start();

// Manejar cierre del proceso
process.on('SIGINT', () => {
    console.log('\n🛑 Cerrando servidor...');
    if (server.client) {
        server.client.destroy();
    }
    process.exit(0);
});
