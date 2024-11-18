from flask import Flask
import time

app = Flask(__name__)

@app.route('/clock', methods=['GET'])
def clock():
    return str(time.time())

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
