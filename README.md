# Todo Frontend Backend Application Project

A fullstack Todo application with a React frontend, FastAPI backend, and Azure infrastructure deployment using Terraform and Azure Pipelines.

## Architecture

This project consists of three main components:

- **Frontend**: React application for the user interface
- **Backend**: FastAPI application with SQL Server database for task management
- **Infrastructure**: Azure resources deployed via Terraform (Virtual Machines, Networking, Security Groups)

## Features

- Create, read, update, and delete todo tasks
- Responsive React frontend
- RESTful API with FastAPI
- SQL Server database for data persistence
- Azure infrastructure as code with Terraform
- CI/CD pipelines with Azure DevOps

## Prerequisites

- Node.js (for frontend)
- Python 3.8+ (for backend)
- Terraform
- Azure CLI
- SQL Server (or Azure SQL Database)

## Setup and Installation

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Update the connection string in `app.py` with your SQL Server details.

4. Run the application:
   ```bash
   python app.py
   ```

The backend will start on `http://localhost:8000`.

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

The frontend will be available at `http://localhost:3000`.

### Infrastructure Deployment

1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## API Endpoints

- `GET /api` - Create tasks table
- `GET /api/tasks` - List all tasks
- `GET /api/tasks/{task_id}` - Get a specific task
- `POST /api/tasks` - Create a new task
- `PUT /tasks/{task_id}` - Update a task
- `DELETE /api/tasks/{task_id}` - Delete a task

## Azure Pipelines

The project includes Azure Pipeline configurations for automated deployment:

- `frontendDeploy.yaml` - Deploys the frontend application
- `backendDeploy.yaml` - Deploys the backend application

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

**Author**: Anurag Vijay
