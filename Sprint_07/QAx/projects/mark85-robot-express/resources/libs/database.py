from robot.api.deco import keyword
from pymongo import MongoClient
import bcrypt

client = MongoClient('mongodb+srv://qa:xperience@cluster0.d8iw87s.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')

db = client['markdb']

@keyword('Remove user from database')
def remove_user(email):
    users = db['users']
    users.delete_one({'email': email})
    print(f"REMOVE USER BY {email} REMOVIDO COM SUCESSO!!.")

@keyword('Insert user from database')
def insert_user(user):

    #Cripitografando a senha e salvando na variavel has_pass --- essa informação deve ser coletada com o dev (foi usado bcrypt )
    hash_pass = bcrypt.hashpw(user['password'].encode('utf-8'), bcrypt.gensalt(8))
    doc = {
        'name': user['name'],
        'email': user['email'],
        'password': hash_pass
    }

    users = db['users']
    users.insert_one(doc)
    print(f"USER {user} INSERIDO COM SUCESSO!!.")   

