#!/usr/bin/python

import supervise
from flask import Flask

app = Flask(__name__)

@app.route("/sv/status/<service>")
def status(service):
    control = supervise.Service("/etc/service/" + service)
    if control.status().status == supervise.STATUS_UP: return "{'status':'up'}", 200
    return "{'status':'down'}", 503

@app.route("/sv/up/<service>")
def up(service):
    control = supervise.Service("/etc/service/" + service)
    control.start()
    return "{'status':'up'}"

@app.route("/sv/down/<service>")
def down(service):
    control = supervise.Service("/etc/service/" + service)
    control.down()
    return "{'status':'down'}"

if __name__ == "__main__":
    app.debug = True
    app.run(host='0.0.0.0')
