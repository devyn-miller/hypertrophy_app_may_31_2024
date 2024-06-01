# import requests

# def fetch_nutrition_data(user_id):
#     response = requests.get(f'http://localhost:5001/api/user/{user_id}/nutrition')
#     return response.json()

from flask import request, jsonify
from . import open_nutri_tracker_bp

@open_nutri_tracker_bp.route('/api/nutrition', methods=['GET'])
def get_nutrition_data():
    user_id = request.args.get('user_id')
    # Logic to fetch nutrition data for the user
    nutrition_data = fetch_nutrition_data(user_id)
    return jsonify(nutrition_data)

def fetch_nutrition_data(user_id):
    # Example function to fetch data (replace with actual logic)
    return {
        "user_id": user_id,
        "calories": 2000,
        "protein": 150,
        "carbs": 250,
        "fats": 70
    }