const { once } = require('node:events');
const assert = require('node:assert/strict');
const test = require('node:test');

const app = require('../src/app');

async function startTestServer() {
  const server = app.listen(0, '127.0.0.1');
  await once(server, 'listening');

  const { port } = server.address();

  return {
    server,
    baseUrl: `http://127.0.0.1:${port}`
  };
}

test('GET / returns the welcome response', async (t) => {
  const { server, baseUrl } = await startTestServer();
  t.after(() => server.close());

  const response = await fetch(`${baseUrl}/`);
  const body = await response.json();

  assert.equal(response.status, 200);
  assert.deepEqual(body, {
    message: 'Hello DevOps'
  });
});

test('GET /health returns UP status', async (t) => {
  const { server, baseUrl } = await startTestServer();
  t.after(() => server.close());

  const response = await fetch(`${baseUrl}/health`);
  const body = await response.json();

  assert.equal(response.status, 200);
  assert.deepEqual(body, {
    status: 'UP'
  });
});
