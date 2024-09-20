# Use the official Python image
FROM python:3.10

# Set the working directory
WORKDIR /app

# Copy the Python source files
COPY . /app

# Install necessary Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the app runs on
EXPOSE 5000

# Command to run the Python app
CMD ["python", "app.py"]
