from flask import Blueprint, render_template, request, flash, jsonify
from flask_login import login_required, current_user
from .models import Task
from . import db
import json

views = Blueprint('views', __name__)

@views.route('/', methods=['GET', 'POST'])
@login_required
def home():
    if request.method == 'POST':
        task = request.form.get('task')
        
        if len(task) < 1:
            flash('Task description is too short', category='error')
        else:
            new_task = Task(text=task, user_id=current_user.id)
            db.session.add(new_task)
            db.session.commit()
            flash('Task added!', category='success')


    return render_template("home.html", user=current_user)

@views.route('/delete-task', methods=['POST'])
@login_required
def delete_task():
    task_data = json.loads(request.data)
    taskId = task_data['taskId']
    task = Task.query.get(taskId)
    if task:
        if task.user_id == current_user.id:
            db.session.delete(task)
            db.session.commit()
            return jsonify({})
        
@views.route('/toggle-task', methods=['POST'])
def toggle_task():
    task_data = json.loads(request.data)
    taskId = task_data['taskId']
    task = Task.query.get(taskId)

    if task:
        if task.user_id == current_user.id:
            task.is_done = task_data['isDone']
            db.session.commit()
    
    return jsonify({})