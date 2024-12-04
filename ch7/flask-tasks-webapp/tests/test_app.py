import unittest
from website import create_app, db
from website.models import User

class FlaskAppTestCase(unittest.TestCase):
    def setUp(self):
        """Set up a test environment."""
        # Create the app with testing configuration
        self.app = create_app()
        self.app.config['TESTING'] = True
        self.app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'  # Use in-memory DB for testing
        self.client = self.app.test_client()

        # Create the database
        with self.app.app_context():
            db.create_all()

    def tearDown(self):
        """Clean up after tests."""
        with self.app.app_context():
            db.session.remove()
            db.drop_all()

    def test_signup(self):
        """Test user registration."""
        response = self.client.post('/signup', data={
            'email': 'testuser@example.com',
            'firstName': 'TestUser',
            'password1': 'password123',
            'password2': 'password123'
        })
        self.assertEqual(response.status_code, 200)  # Ensure the response is successful
        with self.app.app_context():
            user = User.query.filter_by(email='testuser@example.com').first()
            self.assertIsNotNone(user)
            self.assertEqual(user.first_name, 'TestUser')

    def test_login(self):
        """Test user login."""
        # First, create a test user
        with self.app.app_context():
            user = User(email='testuser@example.com', first_name='TestUser')
            user.password = 'password123'  # Assume passwords are hashed during user creation
            db.session.add(user)
            db.session.commit()

        # Attempt to log in with the correct credentials
        response = self.client.post('/login', data={
            'email': 'testuser@example.com',
            'password': 'password123'
        })
        self.assertEqual(response.status_code, 200)  # Ensure the response is successful
        self.assertIn(b'Logged Successfully!', response.data)

    def test_logout(self):
        """Test user logout."""
        with self.app.app_context():
            # Create and log in a test user
            user = User(email='testuser@example.com', first_name='TestUser')
            user.password = 'password123'
            db.session.add(user)
            db.session.commit()

        self.client.post('/login', data={
            'email': 'testuser@example.com',
            'password': 'password123'
        })
        response = self.client.get('/logout')
        self.assertEqual(response.status_code, 302)  # Redirect after logout
        self.assertIn('/login', response.location)

    def test_database_interaction(self):
        """Test database model interactions."""
        with self.app.app_context():
            # Create a test user
            user = User(email='dbtest@example.com', first_name='DBUser', password='password123')
            db.session.add(user)
            db.session.commit()

            # Retrieve the user from the database
            user_from_db = User.query.filter_by(email='dbtest@example.com').first()
            self.assertIsNotNone(user_from_db)
            self.assertEqual(user_from_db.first_name, 'DBUser')

if __name__ == '__main__':
    unittest.main()