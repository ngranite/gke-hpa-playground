# app.py
from flask import Flask, request, jsonify
import threading
import time
import os

app = Flask(__name__)

workers = []
workers_lock = threading.Lock()
stop_event = threading.Event()

def cpu_worker(worker_id):
    # Busy loop that occasionally yields so system remains responsive
    print(f"worker {worker_id} started")
    while not stop_event.is_set():
        # small busy work
        x = 0
        for i in range(100000):
            x += i*i
        # yield briefly
        time.sleep(0.01)
    print(f"worker {worker_id} exiting")

@app.route("/", methods=["GET"])
def index():
    with workers_lock:
        return jsonify({
            "pid": os.getpid(),
            "active_workers": len(workers),
        })

@app.route("/load", methods=["POST"])
def set_load():
    data = request.get_json() or {}
    action = (data.get("action") or "").lower()
    num = int(data.get("workers") or 1)

    if action == "start":
        # clear stop event so workers run
        stop_event.clear()
        started = []
        with workers_lock:
            for i in range(num):
                wid = len(workers) + 1
                t = threading.Thread(target=cpu_worker, args=(wid,), daemon=True)
                workers.append(t)
                t.start()
                started.append(wid)
        return jsonify({"status": "started", "workers_started": len(started)}), 202

    elif action == "stop":
        # signal to stop and clear list
        stop_event.set()
        with workers_lock:
            count = len(workers)
            workers.clear()
        stop_event.clear()
        return jsonify({"status": "stopped", "workers_stopped": count}), 200

    else:
        return jsonify({"error": "invalid action, use 'start' or 'stop'"}), 400

if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
