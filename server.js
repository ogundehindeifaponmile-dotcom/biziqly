// server.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');
const twilio = require('twilio');
const sgMail = require('@sendgrid/mail');

const app = express();
app.use(cors());
app.use(express.json());

// In-memory store (Use Redis/Database in production!)
const otpStore = new Map(); 

// Rate limiter to prevent SMS bombing
const rateLimitStore = new Map();
function checkRateLimit(identifier) {
    const now = Date.now();
    const lastRequest = rateLimitStore.get(identifier);
    if (lastRequest && (now - lastRequest) < 60000) return false; // 1 min cooldown
    rateLimitStore.set(identifier, now);
    return true;
}

// --- SEND OTP ENDPOINT ---
app.post('/api/send-otp', async (req, res) => {
    const { contact, type } = req.body; // type: 'email' | 'sms'
    
    if (!contact || !type) return res.status(400).json({ error: 'Contact and type required' });
    if (!checkRateLimit(contact)) return res.status(429).json({ error: 'Too many requests. Wait 1 minute.' });

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = Date.now() + 5 * 60 * 1000; // 5 minutes
    
    // Store OTP with expiry
    otpStore.set(contact, { code: otp, expiresAt });

    try {
        if (type === 'sms') {
            const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
            await client.messages.create({
                body: `Your BizIQly verification code is: ${otp}. Valid for 5 mins.`,
                from: process.env.TWILIO_PHONE_NUMBER,
                to: contact
            });
        } else if (type === 'email') {
            sgMail.setApiKey(process.env.SENDGRID_API_KEY);
            await sgMail.send({
                to: contact,
                from: 'noreply@biziqly.com',
                subject: 'BizIQly Verification Code',
                text: `Your verification code is: ${otp}. Valid for 5 minutes.`
            });
        }
        res.json({ success: true, message: 'OTP sent successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to send OTP' });
    }
});

// --- VERIFY OTP ENDPOINT ---
app.post('/api/verify-otp', (req, res) => {
    const { contact, otp } = req.body;
    const stored = otpStore.get(contact);

    if (!stored) return res.status(400).json({ error: 'No OTP found' });
    if (Date.now() > stored.expiresAt) {
        otpStore.delete(contact);
        return res.status(400).json({ error: 'OTP expired' });
    }
    if (stored.code !== otp) return res.status(400).json({ error: 'Invalid OTP' });

    // ✅ VERIFIED! Issue session/token here
    otpStore.delete(contact); // One-time use
    res.json({ success: true, message: 'Verified!', token: uuidv4() });
});

app.listen(process.env.PORT || 3000, () => {
    console.log(`🔐 BizIQly Auth Server running on port ${process.env.PORT || 3000}`);
});
