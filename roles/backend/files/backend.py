import os
from flask import Flask
import time

app = Flask(__name__)

# Use an environment variable for the port, with a default value
port = int(os.getenv('BACKEND_PORT', 5000))

@app.route('/clock', methods=['GET'])
def clock():
    return str(time.time())

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)
