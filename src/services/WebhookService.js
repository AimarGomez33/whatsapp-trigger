const axios = require('axios');

class WebhookService {
    constructor() {
        this.webhookUrl = process.env.WEBHOOK_URL;
        this.timeout = 10000; // 10 segundos
        this.retries = 3;
    }

    async sendToWebhook(message, attempt = 1) {
        if (!this.webhookUrl) {
            console.log('⚠️ ERROR: No webhook URL configured, skipping webhook send');
            console.log('   Verifica que WEBHOOK_URL esté en el archivo .env');
            return;
        }

        try {
            const payload = this.formatWebhookPayload(message);
            
            console.log(`📤 ENVIANDO WEBHOOK (intento ${attempt}/${this.retries}):`);
            console.log('   🔗 URL:', this.webhookUrl);
            console.log('   📦 Payload size:', JSON.stringify(payload).length, 'caracteres');
            console.log('   📱 Message ID:', message.id);
            console.log('   ⏰ Timeout:', this.timeout, 'ms');
            
            const response = await axios.post(this.webhookUrl, payload, {
                timeout: this.timeout,
                headers: {
                    'Content-Type': 'application/json',
                    'User-Agent': 'WhatsApp-Webhook-Trigger/1.0',
                    'X-Webhook-Source': 'whatsapp-web-js',
                    'X-Message-Id': message.id,
                    ...(process.env.API_KEY && { 'Authorization': `Bearer ${process.env.API_KEY}` })
                }
            });

            console.log('✅ WEBHOOK ENVIADO EXITOSAMENTE:');
            console.log('   📊 Status:', response.status);
            console.log('   📄 Response:', response.data);
            console.log('   🆔 Message ID:', message.id);

            return response.data;
        } catch (error) {
            console.error(`❌ ERROR ENVIANDO WEBHOOK (intento ${attempt}/${this.retries}):`);
            console.error('   🔗 URL:', this.webhookUrl);
            console.error('   ❗ Error:', error.message);
            console.error('   📊 Status:', error.response?.status);
            console.error('   📄 Response:', error.response?.data);
            console.error('   🔧 Code:', error.code);

            // Reintentar si no hemos alcanzado el límite
            if (attempt < this.retries) {
                console.log(`🔄 REINTENTANDO en 2 segundos... (${attempt + 1}/${this.retries})`);
                await this.delay(2000);
                return this.sendToWebhook(message, attempt + 1);
            }

            console.error(`💥 FALLÓ DESPUÉS DE ${this.retries} INTENTOS`);
            throw error;
        }
    }

    formatWebhookPayload(message) {
        return {
            event: 'message_received',
            timestamp: new Date().toISOString(),
            data: {
                message: {
                    id: message.id,
                    from: message.from,
                    to: message.to,
                    body: message.body,
                    type: message.type,
                    timestamp: message.timestamp,
                    isForwarded: message.isForwarded,
                    isGroup: message.isGroup,
                    groupName: message.groupName,
                    hasMedia: !!message.media,
                    media: message.media,
                    location: message.location,
                    quotedMessage: message.quotedMessage,
                    links: message.links,
                    mentions: message.mentions
                },
                contact: message.contact,
                metadata: {
                    source: 'whatsapp-web-js',
                    version: '1.0.0',
                    processed_at: new Date().toISOString()
                }
            }
        };
    }

    async sendCustomWebhook(url, data, headers = {}) {
        try {
            const response = await axios.post(url, data, {
                timeout: this.timeout,
                headers: {
                    'Content-Type': 'application/json',
                    'User-Agent': 'WhatsApp-Webhook-Trigger/1.0',
                    ...headers
                }
            });

            console.log('✅ Custom webhook enviado:', url);
            return response.data;
        } catch (error) {
            console.error('❌ Error enviando custom webhook:', error.message);
            throw error;
        }
    }

    // Webhook para diferentes eventos
    async sendStatusWebhook(status, data = {}) {
        if (!this.webhookUrl) return;

        const payload = {
            event: 'status_change',
            timestamp: new Date().toISOString(),
            data: {
                status,
                ...data,
                metadata: {
                    source: 'whatsapp-web-js',
                    version: '1.0.0'
                }
            }
        };

        try {
            await axios.post(this.webhookUrl, payload, {
                timeout: this.timeout,
                headers: {
                    'Content-Type': 'application/json',
                    'X-Event-Type': 'status',
                    ...(process.env.API_KEY && { 'Authorization': `Bearer ${process.env.API_KEY}` })
                }
            });
            console.log('✅ Status webhook enviado:', status);
        } catch (error) {
            console.error('❌ Error enviando status webhook:', error.message);
        }
    }

    setWebhookUrl(url) {
        this.webhookUrl = url;
    }

    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }
}

module.exports = WebhookService;
