import requests

def fetch_workout_plans(user_id):
    response = requests.get(f'http://localhost:8000/api/user/{user_id}/workouts')
    return response.json()