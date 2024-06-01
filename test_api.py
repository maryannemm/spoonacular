import requests

def get_price_breakdown(recipe_id, api_key):
    url = f"https://api.spoonacular.com/recipes/{recipe_id}/priceBreakdownWidget.json"
    params = {'apiKey': api_key}
    response = requests.get(url, params=params)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error: {response.status_code} - {response.json()['message']}")
        return None

def main():
    api_key = '9edd626a36254739af07fd646f7fa213'
    recipe_id = 1003464

    price_breakdown = get_price_breakdown(recipe_id, api_key)
    if price_breakdown:
        print("Price breakdown:")
        print(price_breakdown)

if __name__ == "__main__":
    main()



