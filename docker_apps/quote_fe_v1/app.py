import requests
from flask import Flask, render_template

app = Flask(__name__)


@app.route('/')
def hello_world():
    r = requests.get('https://type.fit/api/quotes')
    data = r.json()
    subject = "Hi this is the version 1 using Python. This version will display only 5 quotes"
    return render_template('index.html',
                           subject=subject,
                           data=data[0:5])


if __name__ == '__main__':
    app.run()
