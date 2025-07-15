import requests
import time
import json

url_text = "https://app:5001"  # URL for the text response (default endpoint)
url_json = "https://app:5001/data"  # URL for the JSON response
cert = "/certs/https.crt"

# Function to validate text response
def validate_text_response(response):
    if 'text/plain' in response.headers.get('Content-Type', '').lower():
        print("[INFO] Text Response received.")
        print(f"Received Text: {response.text}")
    else:
        print("[ERROR] Expected text response, but received something else.")

# Function to validate JSON response
def validate_json_response(response):
    if 'application/json' in response.headers.get('Content-Type', '').lower():
        try:
            json_data = response.json()
            if json_data.get("status") == "success":
                print("[INFO] JSON Response is valid!")
                print(f"Received JSON: {json_data}")
            else:
                print("[ERROR] Invalid JSON response status.")
        except json.JSONDecodeError:
            print("[ERROR] Response is not valid JSON.")
    else:
        print("[ERROR] Expected JSON response, but received something else.")

# Wait for the server to be available
print("[INFO] Waiting for Java app to become available...")
for _ in range(10):
    try:
        # First request for text response
        print("[INFO] Requesting text response...")
        response_text = requests.get(url_text, verify=cert)
        if response_text.status_code == 200:
            print(f"[SUCCESS] Received Text: {response_text.text}")
            validate_text_response(response_text)
        else:
            print("[ERROR] Failed to receive a valid text response.")
        
        # Second request for JSON response
        print("[INFO] Requesting JSON response...")
        response_json = requests.get(url_json, verify=cert)
        if response_json.status_code == 200:
            print(f"[SUCCESS] Received JSON: {response_json.text}")
            validate_json_response(response_json)
        else:
            print("[ERROR] Failed to receive a valid JSON response.")
        
        exit(0)
    except Exception as e:
        print(f"[WAIT] {e}")
    time.sleep(2)

print("[FAIL] App did not respond correctly over HTTPS.")
exit(1)
