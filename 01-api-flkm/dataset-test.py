from pymongo import MongoClient
from flask import Flask, request
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)

client = MongoClient('mongodb://localhost:27017/')
db = client['CowlDAO']
datasets_collection = db['Datasets']
users_collection = db['Users']

class DatasetResource(Resource):
    def post(self):
        user = request.json.get('user')
        dataset = request.json.get('dataset')
        # Storing datasets in MongoDB
        datasets_collection.insert_one({'user': user, 'dataset': dataset})
        return {'status': 'success'}, 200

    def get(self, user_id):
        # Retrieving datasets from MongoDB
        datasets = datasets_collection.find({'user': user_id})
        return {'datasets': list(datasets)}, 200

api.add_resource(DatasetResource, '/datasets', '/datasets/<string:user_id>')

class UserResource(Resource):
    def post(self):
        user = request.json.get('user')
        # Creating user in MongoDB
        users_collection.insert_one({'user': user})
        return {'status': 'success'}, 200

    def get(self, user_id):
        # Retrieving user information from MongoDB
        user = users_collection.find_one({'user': user_id})
        return {'user': user}, 200

api.add_resource(UserResource, '/users', '/users/<string:user_id>')

if __name__ == '__main__':
    app.run(debug=True)
