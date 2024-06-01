import requests

def fetch_strongr_fastr_workout(user_id):
    response = requests.get(f'https://api.strongrfastr.com/user/{user_id}/workouts')
    return response.json()