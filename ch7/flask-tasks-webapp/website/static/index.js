function deleteTask(taskId) {
    fetch('/delete-task', {
        method: 'POST',
        body: JSON.stringify({ taskId: taskId })
    }).then((_res) => {
        window.location.href = "/";
    });
}

function toggleTask(taskId, isDone) {
    fetch('/toggle-task', {
        method: 'POST',
        body: JSON.stringify({ taskId: taskId, isDone: isDone })
    }).then((_res) => {
        window.location.href = "/";
    });
}