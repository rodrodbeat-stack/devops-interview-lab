'use strict';

function getEnvironmentSummary(environment) {
  const allowedEnvironments = ['dev', 'qa', 'prod'];

  if (typeof environment !== 'string') {
    throw new TypeError('Environment must be a string');
  }

  const normalizedEnvironment = environment.trim().toLowerCase();

  if (!allowedEnvironments.includes(normalizedEnvironment)) {
    throw new Error('Invalid deployment environment');
  }

  return {
    environment: normalizedEnvironment,
    deploymentAllowed: true
  };
}

module.exports = { getEnvironmentSummary };
