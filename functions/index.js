const functions = require('firebase-functions');
const admin = require('firebase-admin');
const crypto = require('crypto');
const Stripe = require('stripe');

admin.initializeApp();
const db = admin.firestore();

// Set via Firebase config or env
// firebase functions:config:set stripe.secret="sk_live_..." stripe.webhook_secret="whsec_..." razorpay.secret="<key_secret>" razorpay.key="<key_id>"
const stripe = new Stripe(process.env.STRIPE_SECRET || functions.config().stripe?.secret);
const stripeWebhookSecret = process.env.STRIPE_WEBHOOK_SECRET || functions.config().stripe?.webhook_secret;
const razorpayKeySecret = process.env.RAZORPAY_SECRET || functions.config().razorpay?.secret;

async function setUserRole(uid, role, source) {
  await db.collection('users').doc(uid).set({ role, entitlementSource: source, updatedAt: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });
}

exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;
  try {
    event = stripe.webhooks.constructEvent(req.rawBody, sig, stripeWebhookSecret);
  } catch (err) {
    console.error('Stripe signature verification failed', err);
    return res.status(400).send('Bad signature');
  }

  const data = event.data.object;
  try {
    if (event.type === 'customer.subscription.created' || event.type === 'customer.subscription.updated') {
      const uid = data.metadata?.uid;
      if (uid && data.status === 'active') await setUserRole(uid, 'pro', 'stripe');
    }
    if (event.type === 'customer.subscription.deleted') {
      const uid = data.metadata?.uid;
      if (uid) await setUserRole(uid, 'user', 'stripe');
    }
    return res.status(200).send('ok');
  } catch (e) {
    console.error(e);
    return res.status(500).send('error');
  }
});

exports.razorpayWebhook = functions.https.onRequest(async (req, res) => {
  // Verify Razorpay signature
  const signature = req.headers['x-razorpay-signature'];
  const body = JSON.stringify(req.body);
  const expectedSignature = crypto.createHmac('sha256', razorpayKeySecret).update(body).digest('hex');
  if (expectedSignature !== signature) {
    console.error('Razorpay signature invalid');
    return res.status(400).send('Bad signature');
  }

  try {
    const event = req.body.event;
    const payload = req.body.payload || {};
    if (event === 'subscription.activated' || event === 'subscription.charged') {
      const uid = payload.subscription?.entity?.notes?.uid;
      if (uid) await setUserRole(uid, 'pro', 'razorpay');
    }
    if (event === 'subscription.paused' || event === 'subscription.halted' || event === 'subscription.cancelled' || event === 'subscription.completed') {
      const uid = payload.subscription?.entity?.notes?.uid;
      if (uid) await setUserRole(uid, 'user', 'razorpay');
    }
    return res.status(200).send('ok');
  } catch (e) {
    console.error(e);
    return res.status(500).send('error');
  }
});
