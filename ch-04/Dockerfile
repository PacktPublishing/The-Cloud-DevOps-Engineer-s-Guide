# 1. Start from an official Python runtime as a parent image
FROM python:3.9-slim

# 2. Set the working directory in the container
WORKDIR /app

# 3. Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copy the rest of the application source code
COPY . .

# 5. Make port 8080 available to the world outside this container
EXPOSE 8080

# 6. Define the command to run your app using gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]