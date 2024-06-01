import requests

def fetch_food_info(food_id):
    url = "https://platform.fatsecret.com/rest/server.api"
    params = {
        'method': 'food.get.v3',
        'food_id': food_id,
        'format': 'json',
        'oauth_consumer_key': 'your_consumer_key',
        'oauth_signature_method': 'HMAC-SHA1',
        'oauth_timestamp': 'timestamp',
        'oauth_nonce': 'nonce',
        'oauth_version': '1.0',
        'oauth_signature': 'signature'
    }
    response = requests.post(url, params=params)
    return response.json()

def fetch_recipe_info(recipe):
    url = "https://api.edamam.com/api/nutrition-data"
    params = {
        'app_id': 'your_app_id',
        'app_key': 'your_app_key',
        'ingr': recipe
    }
    response = requests.get(url, params=params)
    return response.json()