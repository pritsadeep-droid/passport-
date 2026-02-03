const admin = require('firebase-admin');
const logger = require('../utils/logger');

/**
 * Push Notification Service using Firebase Cloud Messaging
 */

let firebaseApp = null;

/**
 * Initialize Firebase Admin SDK
 */
const initializeFirebase = () => {
  if (firebaseApp) return firebaseApp;

  try {
    // Check for Firebase credentials
    const serviceAccount = process.env.FIREBASE_SERVICE_ACCOUNT;

    if (serviceAccount) {
      // Parse JSON from environment variable
      const credentials = JSON.parse(serviceAccount);
      firebaseApp = admin.initializeApp({
        credential: admin.credential.cert(credentials),
      });
      logger.info('Firebase Admin SDK initialized successfully');
    } else if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      // Use default credentials file
      firebaseApp = admin.initializeApp({
        credential: admin.credential.applicationDefault(),
      });
      logger.info('Firebase Admin SDK initialized with default credentials');
    } else {
      logger.warn('Firebase credentials not configured, push notifications disabled');
      return null;
    }

    return firebaseApp;
  } catch (error) {
    logger.error('Failed to initialize Firebase', { error: error.message });
    return null;
  }
};

/**
 * Send push notification to a single device
 * @param {string} token - FCM device token
 * @param {Object} notification - Notification payload
 * @param {string} notification.title - Notification title
 * @param {string} notification.body - Notification body
 * @param {Object} data - Optional data payload
 * @returns {Promise<Object>} Send result
 */
const sendToDevice = async (token, notification, data = {}) => {
  try {
    const app = initializeFirebase();

    if (!app) {
      logger.warn('Firebase not initialized, skipping push notification');
      return { success: true, skipped: true };
    }

    const message = {
      token,
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: {
        ...data,
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
      android: {
        priority: 'high',
        notification: {
          channelId: 'kpi_probation_channel',
          priority: 'high',
          defaultSound: true,
          defaultVibrateTimings: true,
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    const result = await admin.messaging().send(message);

    logger.info('Push notification sent', {
      messageId: result,
      title: notification.title,
    });

    return { success: true, messageId: result };
  } catch (error) {
    logger.error('Failed to send push notification', {
      error: error.message,
      token: token.substring(0, 20) + '...',
    });

    // Handle invalid tokens
    if (
      error.code === 'messaging/invalid-registration-token' ||
      error.code === 'messaging/registration-token-not-registered'
    ) {
      return { success: false, invalidToken: true, error: error.message };
    }

    return { success: false, error: error.message };
  }
};

/**
 * Send push notification to multiple devices
 * @param {string[]} tokens - Array of FCM device tokens
 * @param {Object} notification - Notification payload
 * @param {Object} data - Optional data payload
 * @returns {Promise<Object>} Send result
 */
const sendToMultipleDevices = async (tokens, notification, data = {}) => {
  try {
    const app = initializeFirebase();

    if (!app) {
      logger.warn('Firebase not initialized, skipping push notifications');
      return { success: true, skipped: true };
    }

    if (!tokens || tokens.length === 0) {
      return { success: true, skipped: true, reason: 'No tokens provided' };
    }

    const message = {
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: {
        ...data,
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
      android: {
        priority: 'high',
        notification: {
          channelId: 'kpi_probation_channel',
          priority: 'high',
          defaultSound: true,
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
      tokens,
    };

    const result = await admin.messaging().sendEachForMulticast(message);

    logger.info('Push notifications sent', {
      successCount: result.successCount,
      failureCount: result.failureCount,
    });

    // Collect invalid tokens
    const invalidTokens = [];
    result.responses.forEach((resp, idx) => {
      if (!resp.success) {
        if (
          resp.error?.code === 'messaging/invalid-registration-token' ||
          resp.error?.code === 'messaging/registration-token-not-registered'
        ) {
          invalidTokens.push(tokens[idx]);
        }
      }
    });

    return {
      success: true,
      successCount: result.successCount,
      failureCount: result.failureCount,
      invalidTokens,
    };
  } catch (error) {
    logger.error('Failed to send push notifications', {
      error: error.message,
    });

    return { success: false, error: error.message };
  }
};

/**
 * Send topic notification
 * @param {string} topic - Topic name
 * @param {Object} notification - Notification payload
 * @param {Object} data - Optional data payload
 * @returns {Promise<Object>} Send result
 */
const sendToTopic = async (topic, notification, data = {}) => {
  try {
    const app = initializeFirebase();

    if (!app) {
      logger.warn('Firebase not initialized, skipping push notification');
      return { success: true, skipped: true };
    }

    const message = {
      topic,
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: {
        ...data,
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
    };

    const result = await admin.messaging().send(message);

    logger.info('Topic notification sent', {
      messageId: result,
      topic,
    });

    return { success: true, messageId: result };
  } catch (error) {
    logger.error('Failed to send topic notification', {
      error: error.message,
      topic,
    });

    return { success: false, error: error.message };
  }
};

/**
 * Subscribe device to topic
 * @param {string} token - FCM device token
 * @param {string} topic - Topic name
 * @returns {Promise<Object>} Subscribe result
 */
const subscribeToTopic = async (token, topic) => {
  try {
    const app = initializeFirebase();

    if (!app) {
      return { success: true, skipped: true };
    }

    await admin.messaging().subscribeToTopic([token], topic);

    logger.info('Subscribed to topic', { topic });

    return { success: true };
  } catch (error) {
    logger.error('Failed to subscribe to topic', {
      error: error.message,
      topic,
    });

    return { success: false, error: error.message };
  }
};

/**
 * Unsubscribe device from topic
 * @param {string} token - FCM device token
 * @param {string} topic - Topic name
 * @returns {Promise<Object>} Unsubscribe result
 */
const unsubscribeFromTopic = async (token, topic) => {
  try {
    const app = initializeFirebase();

    if (!app) {
      return { success: true, skipped: true };
    }

    await admin.messaging().unsubscribeFromTopic([token], topic);

    logger.info('Unsubscribed from topic', { topic });

    return { success: true };
  } catch (error) {
    logger.error('Failed to unsubscribe from topic', {
      error: error.message,
      topic,
    });

    return { success: false, error: error.message };
  }
};

module.exports = {
  initializeFirebase,
  sendToDevice,
  sendToMultipleDevices,
  sendToTopic,
  subscribeToTopic,
  unsubscribeFromTopic,
};
