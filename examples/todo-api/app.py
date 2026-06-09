"""Minimal Todo API — a sample project for demonstrating Navi.

Deliberately small and deliberately imperfect: it carries a few realistic issues
(missing input validation, no auth, debug server) so a Navi REVIEW has something
concrete to find. See docs/reports/EXP/ for the report Navi produced on this file.
"""

from flask import Flask, request, jsonify

app = Flask(__name__)

# In-memory store — fine for a demo, not for production.
todos: dict[int, dict] = {}
_next_id = 1


@app.get("/todos")
def list_todos():
    return jsonify(list(todos.values()))


@app.post("/todos")
def create_todo():
    global _next_id
    data = request.get_json()
    todo = {"id": _next_id, "title": data["title"], "done": False}
    todos[_next_id] = todo
    _next_id += 1
    return jsonify(todo), 201


@app.delete("/todos/<int:todo_id>")
def delete_todo(todo_id):
    todos.pop(todo_id, None)
    return "", 204


if __name__ == "__main__":
    app.run(debug=True)
