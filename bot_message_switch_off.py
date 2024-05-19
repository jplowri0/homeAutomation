import requests
from config import url_import, auth_key_import

url = url_import

payload = {
    "content" : "Door monitoring disarmed"
}
headers = {
    "Authorization" : auth_key_import
}

res = requests.post(url,payload,headers=headers)

