# WhatsApp Hub Evolution API — AI Integration & Developer Reference Cheatsheet

> **Context**: Use this prompt and API reference to implement WhatsApp messaging, media delivery, webhooks, and automation in external web applications (e.g. **https://www.bitechez.com/**, Next.js, Express, React, or Python projects).

---

## 1. Live Environment & Authentication Credentials
- **Production Server URL**: `https://whatsappapi-1n7u.onrender.com`
- **Local Dev Server URL**: `http://localhost:8080`
- **Active Instance Name**: `user_4qkhdrjvmfw4yhu3`
- **Active API Key**: `wapi_live_429683c4c977415caafcce10f7d57e11`
- **Internal Evolution API Token**: `429683C4C977415CAAFCCE10F7D57E11`
- **Connected WhatsApp Number**: `+919761304821`
- **Cloudflare R2 Media Bucket**: `rudram-media`
- **Auth Header**: `apikey: 429683C4C977415CAAFCCE10F7D57E11` (or `apikey: wapi_live_429683c4c977415caafcce10f7d57e11`)

---

## 2. Core API Endpoints

### A. Send Plain Text Message
- **Method & Route**: `POST https://whatsappapi-1n7u.onrender.com/message/sendText/user_4qkhdrjvmfw4yhu3`
- **Headers**: `Content-Type: application/json`, `apikey: 429683C4C977415CAAFCCE10F7D57E11`
- **Payload**:
```json
{
  "number": "+919761304821",
  "text": "Hello! Your alert from Rakshaa is confirmed."
}
```

---

### B. Send Image / Video / Audio
- **Method & Route**: `POST https://whatsappapi-1n7u.onrender.com/message/sendMedia/user_4qkhdrjvmfw4yhu3`
- **Headers**: `Content-Type: application/json`, `apikey: 429683C4C977415CAAFCCE10F7D57E11`
- **Payload**:
```json
{
  "number": "+919761304821",
  "mediatype": "image",
  "mimetype": "image/jpeg",
  "caption": "Order Confirmation receipt from BiteChez",
  "media": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600",
  "fileName": "photo.jpg"
}
```

---

### C. Send PDF / Document (Invoices, Catalogs via Cloudflare R2)
- **Method & Route**: `POST https://whatsappapi-1n7u.onrender.com/message/sendMedia/user_4qkhdrjvmfw4yhu3`
- **Headers**: `Content-Type: application/json`, `apikey: 429683C4C977415CAAFCCE10F7D57E11`
- **Payload**:
```json
{
  "number": "+919761304821",
  "mediatype": "document",
  "mimetype": "application/pdf",
  "media": "https://whatsappapi-1n7u.onrender.com/media/r2/file/documents%2FBiteChez_Invoice.pdf",
  "fileName": "BiteChez_Invoice_5482.pdf"
}
```

---

### D. Verify WhatsApp Number
- **Method & Route**: `POST https://whatsappapi-1n7u.onrender.com/chat/whatsappNumbers/user_4qkhdrjvmfw4yhu3`
- **Headers**: `apikey: 429683C4C977415CAAFCCE10F7D57E11`
- **Payload**:
```json
{
  "numbers": ["+919761304821"]
}
```

---

### E. Check Instance Connection Status
- **Method & Route**: `GET https://whatsappapi-1n7u.onrender.com/instance/connectionState/user_4qkhdrjvmfw4yhu3`
- **Headers**: `apikey: 429683C4C977415CAAFCCE10F7D57E11`
- **Response**:
```json
{
  "instance": {
    "instanceName": "user_4qkhdrjvmfw4yhu3",
    "state": "open"
  }
}
```

---

## 3. Webhooks Receiver (Node.js / Express Example)

Register your webhook URL at `POST https://whatsappapi-1n7u.onrender.com/webhook/set/user_4qkhdrjvmfw4yhu3`:
```javascript
const express = require('express');
const app = express();
app.use(express.json());

app.post('/api/webhooks/whatsapp', (req, res) => {
  const { event, instance, data } = req.body;
  console.log(`Received WhatsApp Event: ${event} for instance: ${instance}`);

  if (event === 'MESSAGES_UPSERT') {
    const sender = data.key?.remoteJid;
    const messageText = data.message?.conversation || data.message?.extendedTextMessage?.text;
    const senderName = data.pushName || 'Customer';

    console.log(`New message from ${senderName} (${sender}): ${messageText}`);
    // Process order status, trigger AI chatbot, or update database
  }

  res.status(200).json({ received: true });
});

app.listen(3000, () => console.log('WhatsApp Webhook server listening on port 3000'));
```

---

## 4. Drop-in JavaScript/TypeScript Client Class

```typescript
export class WhatsAppHubClient {
  private baseUrl: string;
  private instance: string;
  private apiKey: string;

  constructor(options?: { baseUrl?: string; instance?: string; apiKey?: string }) {
    this.baseUrl = options?.baseUrl || 'https://whatsappapi-1n7u.onrender.com';
    this.instance = options?.instance || 'user_4qkhdrjvmfw4yhu3';
    this.apiKey = options?.apiKey || '429683C4C977415CAAFCCE10F7D57E11';
  }

  async sendText(toPhone: string, text: string) {
    const cleanPhone = toPhone.replace(/\D/g, '');
    const res = await fetch(`${this.baseUrl}/message/sendText/${encodeURIComponent(this.instance)}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': this.apiKey
      },
      body: JSON.stringify({ number: cleanPhone, text: text.trim() })
    });
    return res.json();
  }

  async sendMedia(toPhone: string, mediaUrl: string, caption?: string, mediaType: 'image' | 'video' | 'document' = 'image') {
    const cleanPhone = toPhone.replace(/\D/g, '');
    const res = await fetch(`${this.baseUrl}/message/sendMedia/${encodeURIComponent(this.instance)}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': this.apiKey
      },
      body: JSON.stringify({
        number: cleanPhone,
        mediatype: mediaType,
        mimetype: mediaType === 'document' ? 'application/pdf' : (mediaType === 'video' ? 'video/mp4' : 'image/jpeg'),
        media: mediaUrl,
        caption: caption || '',
        fileName: mediaType === 'document' ? 'document.pdf' : 'media.jpg'
      })
    });
    return res.json();
  }
}
```

---

## 5. Website 1-Line Embed Widget (BiteChez, HTML, Shopify)

```html
<script src="https://whatsappapi-1n7u.onrender.com/sdk/whatsapp-widget.js" 
        data-instance="user_4qkhdrjvmfw4yhu3" 
        data-phone="+919761304821"
        data-brand="BiteChez"
        data-greeting="Hi! Need help with your order?">
</script>
```
