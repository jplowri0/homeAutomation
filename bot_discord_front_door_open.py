import requests


from config import url_import,auth_key_import

url = url_import
auth_key = auth_key_import

payload={
    "content" = "Front Door is Open"
}

headers={
    "Authorization" : auth_key
}

res = requests.post(url,payload,header=headers)

