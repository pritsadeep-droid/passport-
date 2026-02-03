const winston = require('winston');
const path = require('path');

// Define log format
const logFormat = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  winston.format.errors({ stack: true }),
  winston.format.printf(({ timestamp, level, message, stack, ...metadata }) => {
    let log = `${timestamp} [${level.toUpperCase()}]: ${message}`;

    // Add metadata if present
    if (Object.keys(metadata).length > 0) {
      log += ` ${JSON.stringify(metadata)}`;
    }

    // Add stack trace for errors
    if (stack) {
      log += `\n${stack}`;
    }

    return log;
  })
);

// Define log format for JSON (production)
const jsonFormat = winston.format.combine(
  winston.format.timestamp(),
  winston.format.errors({ stack: true }),
  winston.format.json()
);

// Create logger instance
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: process.env.NODE_ENV === 'production' ? jsonFormat : logFormat,
  defaultMeta: { service: 'kpi-probation-api' },
  transports: [
    // Console transport
    new winston.transports.Console({
      format:
        process.env.NODE_ENV === 'production'
          ? jsonFormat
          : winston.format.combine(winston.format.colorize(), logFormat),
    }),
  ],
});

// Add file transports in production
if (process.env.NODE_ENV === 'production') {
  const logsDir = process.env.LOGS_DIR || 'logs';

  logger.add(
    new winston.transports.File({
      filename: path.join(logsDir, 'error.log'),
      level: 'error',
      maxsize: 5242880, // 5MB
      maxFiles: 5,
    })
  );

  logger.add(
    new winston.transports.File({
      filename: path.join(logsDir, 'combined.log'),
      maxsize: 5242880, // 5MB
      maxFiles: 5,
    })
  );
}

// Stream for Morgan HTTP logging
logger.stream = {
  write: (message) => {
    logger.info(message.trim());
  },
};

// Helper methods for structured logging
logger.logRequest = (req, message = 'Request received') => {
  logger.info(message, {
    method: req.method,
    path: req.path,
    userId: req.userId,
    ip: req.ip,
  });
};

logger.logResponse = (req, statusCode, message = 'Response sent') => {
  logger.info(message, {
    method: req.method,
    path: req.path,
    statusCode,
    userId: req.userId,
  });
};

logger.logError = (error, req = null, additionalInfo = {}) => {
  const errorInfo = {
    message: error.message,
    stack: error.stack,
    ...additionalInfo,
  };

  if (req) {
    errorInfo.method = req.method;
    errorInfo.path = req.path;
    errorInfo.userId = req.userId;
  }

  logger.error('Error occurred', errorInfo);
};

module.exports = logger;
